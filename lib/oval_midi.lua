local oval_midi = {}
local midi_in
local midi_out

-- Mapeo fisico del Oval (60-67) a indices logicos (1-8)
local phys_to_log = {[67]=1, [60]=2,[66]=3, [61]=4, [65]=5, [62]=6,[64]=7, [63]=8}
-- Mapeo de Canal CC (1-8) a indice logico (1-8) basado en la nota fisica asociada
local ch_to_pad = {[1]=2, [2]=4, [3]=6, [4]=8, [5]=7, [6]=5, [7]=3, [8]=1}

function oval_midi.init()
  midi_in = midi.connect(1)
  midi_out = midi.connect(2)
  
  midi_in.event = function(data)
    local msg = midi.to_msg(data)
    if not msg then return end
    
    -- Filtro CC17 (Ruido fantasma Bluetooth en Canal 9)
    if msg.type == "cc" and msg.cc == 17 then return end
    
    local base_ch = params:get("oval_mpe_zone")
    
    -- PROXIMIDAD GLOBAL (CC7) -> Exclusivo del Canal 8
    if msg.type == "cc" and msg.cc == 7 and msg.ch == 8 then
      local val = msg.val
      if params:get("oval_prox_inv") == 2 then val = 127 - val end
      local final_val = oval_math.luts.prox[val] or val
      midi_out:cc(params:get("oval_prox_dest"), final_val, base_ch) -- Envia por Canal 1 (Macro MPE)
      return
    end

    -- PROCESAMIENTO DE NOTAS (Canal 1)
    if msg.type == "note_on" and msg.ch == 1 then
      local pad = phys_to_log[msg.note]
      if pad then
        local mpe_ch = base_ch + pad
        local mapped_note = oval_state.active_notes[pad]
        local vel = oval_math.luts.vel[msg.vel] or msg.vel
        
        oval_state.pad_status[pad].pressed = true
        oval_state.pad_status[pad].z_timer = util.time()
        oval_state.pad_status[pad].vel = vel
        
        midi_out:note_on(mapped_note, vel, mpe_ch)
        oval_state.dirty = true
      end
      
    elseif msg.type == "note_off" and msg.ch == 1 then
      local pad = phys_to_log[msg.note]
      if pad then
        local mpe_ch = base_ch + pad
        local mapped_note = oval_state.active_notes[pad]
        
        oval_state.pad_status[pad].pressed = false
        midi_out:note_off(mapped_note, 0, mpe_ch)
        midi_out:channel_pressure(0, mpe_ch)
        midi_out:pitchbend(8192, mpe_ch)
        oval_state.dirty = true
      end
      
    -- PROCESAMIENTO DE CCs POLIFONICOS (Canales 1-8)
    elseif msg.type == "cc" and msg.ch >= 1 and msg.ch <= 8 then
      local pad = ch_to_pad[msg.ch]
      if pad and oval_state.pad_status[pad].pressed then
        local mpe_ch = base_ch + pad
        
        if msg.cc == 1 then -- Z-Axis (Presion)
          local delay = params:get("oval_z_delay") / 1000
          if (util.time() - oval_state.pad_status[pad].z_timer) > delay then
            local z_val = oval_math.luts.z[msg.val] or msg.val
            midi_out:channel_pressure(z_val, mpe_ch)
          end
          
        elseif msg.cc == 3 then -- X-Axis (Pitch Bend)
          if oval_state.pad_status[pad].z_timer == util.time() then
            oval_state.pad_status[pad].x_origin = msg.val
          end
          local pb = oval_math.dynamic_zero(msg.val, oval_state.pad_status[pad].x_origin, params:get("oval_x_sens"))
          midi_out:pitchbend(pb, mpe_ch)
          
        elseif msg.cc == 5 then -- Y-Axis (Timbre CC74)
          local y_val = msg.val
          if params:get("oval_y_mode") == 2 then
            y_val = oval_math.bipolar_mirror(msg.val, params:get("oval_y_min"), params:get("oval_y_max"))
          end
          midi_out:cc(74, y_val, mpe_ch)
          
        elseif msg.cc == 2 then -- Touch Switch (Gate)
          local mode = params:get("oval_cc2_mode")
          if mode == 2 then -- Send CC
            midi_out:cc(params:get("oval_cc2_dest"), msg.val == 1 and 127 or 0, mpe_ch)
          elseif mode == 3 then -- Send Note
            if msg.val == 1 then
              midi_out:note_on(params:get("oval_cc2_note"), params:get("oval_cc2_vel"), mpe_ch)
            else
              midi_out:note_off(params:get("oval_cc2_note"), 0, mpe_ch)
            end
          end
        end
      end
    end
  end
end

function oval_midi.cleanup()
  for i=1, 16 do midi_out:cc(123, 0, i) end
end
return oval_midi
