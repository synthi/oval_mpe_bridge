local oval_scales = {}

-- Diccionario 1+7 (Intervalos en semitonos desde el Ding)
oval_scales.dict = {
  ["Integral / Protus"] = {7, 8, 10, 12, 14, 15, 19},["Kurd / Annaziska"]  = {7, 8, 10, 12, 14, 15, 17},
  ["Hijaz"]             = {7, 10, 12, 13, 16, 17, 19},
  ["Aeolian"]           = {7, 8, 10, 12, 14, 15, 17},
  ["Pygmy"]             = {7, 10, 12, 15, 17, 19, 22},
  ["Gen2-01"]           = {7, 8, 10, 12, 14, 16, 19},
  ["Gen2-02"]           = {7, 8, 10, 12, 15, 17, 19},
  ["Gen2-03"]           = {7, 8, 11, 12, 14, 15, 19},
  ["Gen2-04"]           = {7, 8, 11, 12, 14, 17, 19},["Gen2-05"]           = {7, 8, 12, 14, 16, 17, 19},
  ["Gen2-06"]           = {7, 8, 12, 15, 17, 19, 24},["Low Gong-Diao"]     = {2, 4, 7, 9, 12, 14, 16},
  ["Low Pygmy"]         = {2, 3, 7, 10, 12, 14, 15}
}

oval_scales.names = {}

function oval_scales.init()
  for k, _ in pairs(oval_scales.dict) do table.insert(oval_scales.names, k) end
  table.sort(oval_scales.names)
  for i=1,8 do table.insert(oval_scales.names, "Custom "..i) end
end

function oval_scales.recalculate()
  local scale_idx = params:get("oval_scale")
  local scale_name = oval_scales.names[scale_idx]
  local root_note = (params:get("oval_root") - 1) + 36 -- C2 base
  local transpose = params:get("oval_transpose")
  local base_ding = root_note + transpose + 12 -- Default Ding octave
  
  if string.match(scale_name, "Custom") then
    local slot = tonumber(string.sub(scale_name, -1))
    for i=1,8 do
      oval_state.active_notes[i] = params:get("oval_c_"..slot.."_"..i)
    end
  else
    local intervals = oval_scales.dict[scale_name]
    oval_state.active_notes[1] = base_ding
    for i=1,7 do
      oval_state.active_notes[i+1] = base_ding + intervals[i]
    end
  end
  oval_state.dirty = true
end

function oval_scales.edit_custom_note(slot, pad, delta)
  local id = "oval_c_"..slot.."_"..pad
  params:set(id, util.clamp(params:get(id) + delta, 0, 127))
end

function oval_scales.save_custom(slot)
  -- Guarda la escala actual en el slot custom
  for i=1,8 do
    params:set("oval_c_"..slot.."_"..i, oval_state.active_notes[i])
  end
  print("Oval MPE: Escala guardada en Custom "..slot)
end

return oval_scales
