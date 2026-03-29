local oval_scales = {}

-- Diccionario Completo 1+7 (Intervalos en semitonos desde el Ding)
oval_scales.dict = {
  -- Clasicos y 2a Generacion (2006-2007)["Integral / Protus"] = {7, 8, 10, 12, 14, 15, 19},
  ["Kurd / Annaziska"]  = {7, 8, 12, 14, 15, 17, 19},
  ["Hijaz"]             = {7, 10, 12, 13, 16, 17, 19},
  ["Aeolian"]           = {7, 10, 12, 14, 15, 17, 19},["Gen2-01"]           = {7, 8, 10, 12, 14, 16, 19},
  ["Gen2-02"]           = {7, 8, 10, 12, 15, 17, 19},["Gen2-03"]           = {7, 8, 11, 12, 14, 15, 19},
  ["Gen2-04"]           = {7, 8, 11, 12, 14, 17, 19},["Gen2-05"]           = {7, 8, 12, 14, 16, 17, 19},
  ["Gen2-06"]           = {7, 8, 12, 15, 17, 19, 24},
  ["Gen2-07"]           = {7, 9, 10, 12, 14, 15, 19},
  ["Gen2-08"]           = {7, 9, 11, 12, 14, 16, 19},
  ["Gen2-09"]           = {7, 9, 11, 12, 16, 17, 19},
  ["Gen2-10"]           = {7, 10, 12, 14, 15, 19, 20},
  ["Gen2-11"]           = {7, 10, 12, 14, 16, 17, 19},["Gen2-12"]           = {7, 10, 12, 14, 17, 19, 20},
  ["Gen2-13"]           = {7, 10, 12, 15, 17, 19, 20},["Gen2-14"]           = {7, 12, 14, 15, 17, 19, 20},
  ["Gen2-15"]           = {7, 12, 14, 15, 19, 24, 26},

  -- Low Hang
  ["Low Gong-Diao"]     = {2, 4, 7, 9, 12, 14, 16},["Low Shang-Diao"]    = {2, 5, 7, 10, 12, 14, 17},
  ["Low Yue-Diao"]      = {3, 5, 8, 10, 12, 15, 17},["Low Zhi-Diao"]      = {2, 5, 7, 9, 12, 14, 17},
  ["Low Yu-Diao"]       = {3, 5, 7, 10, 12, 15, 17},["Low Ake Bono-Joshi"]= {2, 3, 7, 8, 12, 14, 15},
  ["Low Iwato-Joshi"]   = {1, 5, 6, 10, 12, 13, 17},
  ["Low Goonkali"]      = {1, 5, 7, 8, 12, 13, 17},
  ["Low Pygmy"]         = {2, 3, 7, 10, 12, 14, 15},
  ["Low Pyeong Yo"]     = {2, 5, 9, 10, 12, 14, 17},
  ["Low Kumoi-Joshi"]   = {2, 3, 7, 9, 12, 14, 15},
  ["Low Kokin-Joshi"]   = {1, 5, 7, 10, 12, 13, 17},
  ["Low Zokuso-Joshi"]  = {1, 5, 6, 8, 12, 13, 17},

  -- BElls (Estrictamente 8 notas)
  ["BElls Aeolian Pent"]= {7, 10, 12, 14, 17, 19, 22},
  ["BElls Akebono"]     = {5, 7, 8, 12, 14, 17, 20},
  ["BElls Arezzo"]      = {7, 9, 11, 12, 14, 16, 19},
  ["BElls Awake"]       = {3, 7, 8, 10, 12, 15, 19},
  ["BElls Aware"]       = {3, 7, 8, 10, 12, 14, 19},
  ["BElls Baduhari"]    = {7, 11, 12, 14, 16, 17, 19},
  ["BElls Bhinna"]      = {7, 10, 12, 13, 16, 17, 19},
  ["BElls Blues"]       = {7, 10, 12, 13, 14, 17, 19},
  ["BElls Chad Gayo"]   = {7, 8, 10, 12, 17, 19, 20},
  ["BElls Devarangi"]   = {7, 8, 12, 14, 15, 18, 19},
  ["BElls Dom 7th Bajo"]= {7, 10, 12, 14, 15, 17, 19},["BElls Dorian"]      = {7, 10, 12, 14, 16, 17, 19},
  ["BElls Dbl Phrygian"]= {7, 8, 10, 12, 13, 16, 19},["BElls Egyptian"]    = {7, 10, 12, 15, 17, 19, 22},
  ["BElls Elion"]       = {4, 7, 9, 12, 14, 16, 19},
  ["BElls Genus"]       = {7, 11, 12, 14, 16, 18, 19},
  ["BElls Geyahajjajji"]= {7, 8, 11, 12, 14, 15, 19},["BElls Gopikatilaka"]= {7, 8, 11, 12, 15, 17, 19},
  ["BElls Gowleeswari"] = {7, 8, 12, 15, 19, 20, 24},["BElls Hira-Joshi"]  = {7, 8, 12, 13, 17, 19, 20},
  ["BElls Honchishi"]   = {7, 8, 10, 12, 13, 17, 19},
  ["BElls Insen"]       = {7, 8, 12, 14, 15, 17, 19},
  ["BElls Kambhoji"]    = {7, 9, 10, 12, 14, 17, 19},
  ["BElls Kapijingla"]  = {7, 9, 10, 12, 16, 17, 19},
  ["BElls Kedaram"]     = {7, 9, 11, 12, 14, 18, 19},
  ["BElls Magic Hour"]  = {3, 7, 10, 12, 14, 15, 19},
  ["BElls Mixo"]        = {7, 9, 11, 12, 16, 17, 19},
  ["BElls Mixolydian"]  = {7, 9, 12, 14, 16, 17, 19},["BElls Paradiso"]    = {4, 7, 11, 12, 14, 16, 19},
  ["BElls Paradiso 2"]  = {4, 5, 7, 12, 14, 16, 19},["BElls Pent Blues"]  = {7, 10, 12, 13, 17, 19, 22},
  ["BElls Raga Desh B"] = {7, 10, 12, 16, 17, 19, 22},["BElls Rufinus"]     = {3, 7, 8, 10, 12, 13, 15},
  ["BElls Suddha"]      = {7, 8, 10, 12, 15, 17, 19},["BElls Spyner"]      = {5, 7, 12, 14, 16, 17, 19},
  ["BElls Zheng"]       = {7, 9, 12, 14, 16, 19, 21},["BElls GUILVI"]      = {3, 5, 7, 10, 12, 14, 17}
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
  for i=1,8 do
    params:set("oval_c_"..slot.."_"..i, oval_state.active_notes[i])
  end
  print("Oval MPE: Escala guardada en Custom "..slot)
end

return oval_scales
