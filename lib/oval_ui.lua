local oval_ui = {}
local musicutil = require("musicutil")

function oval_ui.draw(state)
  screen.level(15)
  
  if state.ui_page == 1 then
    -- HUD TACTICO: Escala y Anillo
    screen.move(0, 10)
    screen.text(oval_scales.names[params:get("oval_scale")])
    screen.move(128, 10)
    screen.text_right("TR: " .. params:get("oval_transpose"))
    
    -- Dibujar Anillo
    local cx, cy = 64, 38
    local r = 20
    for i=1, 8 do
      local note_str = musicutil.note_num_to_name(state.active_notes[i], true)
      screen.level(state.pad_status[i].pressed and 15 or 4)
      
      if i == 1 then -- Ding (Centro)
        screen.move(cx, cy + 3)
        screen.text_center(note_str)
        if state.pad_status[i].pressed then screen.circle(cx, cy, 8) screen.stroke() end
      else
        local angle = ((i-2) / 7) * math.pi * 2 - (math.pi / 2)
        local nx = cx + math.cos(angle) * r
        local ny = cy + math.sin(angle) * r
        screen.move(nx, ny + 3)
        screen.text_center(note_str)
        if state.pad_status[i].pressed then screen.circle(nx, ny, 6) screen.stroke() end
      end
    end
    
  elseif state.ui_page == 2 then
    -- MODO EDICION CUSTOM
    screen.move(0, 10)
    screen.text("EDIT CUSTOM " .. state.ui_edit_slot)
    screen.move(0, 30)
    screen.level(5)
    screen.text("Pad " .. state.ui_edit_pad .. ": ")
    screen.level(15)
    local note_val = params:get("oval_c_"..state.ui_edit_slot.."_"..state.ui_edit_pad)
    screen.text(musicutil.note_num_to_name(note_val, true) .. " ("..note_val..")")
    screen.move(0, 50)
    screen.level(3)
    screen.text("E1:Slot E2:Pad E3:Note K3:Save")
    
  elseif state.ui_page == 3 then
    screen.move(0, 10) screen.text("DYNAMICS (VEL & Z)")
    screen.move(0, 30) screen.text("Vel Curve: " .. params:string("oval_vel_curve"))
    screen.move(0, 40) screen.text("Z Curve: " .. params:string("oval_z_curve"))
    screen.move(0, 50) screen.text("Z Delay: " .. params:get("oval_z_delay") .. "ms")
    
  elseif state.ui_page == 4 then
    screen.move(0, 10) screen.text("SPATIAL (X/Y)")
    screen.move(0, 30) screen.text("X Sens: " .. params:get("oval_x_sens"))
    screen.move(0, 40) screen.text("Y Mode: " .. params:string("oval_y_mode"))
    
  elseif state.ui_page == 5 then
    screen.move(0, 10) screen.text("PROXIMITY (MACRO)")
    screen.move(0, 30) screen.text("Dest CC: " .. params:get("oval_prox_dest"))
    screen.move(0, 40) screen.text("Invert: " .. params:string("oval_prox_inv"))
    screen.move(0, 50) screen.text("Curve: " .. params:string("oval_prox_curve"))
  end
  
  -- Indicador de paginas
  for i=1, 5 do
    screen.level(state.ui_page == i and 15 or 2)
    screen.move(110 + (i*3), 60)
    screen.line_rel(2, 0)
    screen.stroke()
  end
end

return oval_ui
