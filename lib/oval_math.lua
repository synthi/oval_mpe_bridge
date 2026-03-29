local oval_math = {}

oval_math.luts = {
  vel = {},
  z = {},
  prox = {}
}

function oval_math.init()
  -- Inicializacion diferida, se llama desde params
end

function oval_math.build_lut(target)
  local curve = params:get("oval_"..target.."_curve")
  local tension = params:get("oval_"..target.."_tension") / 100
  local pivot = target == "vel" and params:get("oval_vel_pivot") or 64
  local min_val = target ~= "vel" and params:get("oval_"..target.."_min") or 0
  local max_val = target ~= "vel" and params:get("oval_"..target.."_max") or 127

  for i=0, 127 do
    local norm = i / 127
    local res = norm
    
    if curve == 2 then -- Exp
      res = math.pow(norm, 1 + (tension * 4))
    elseif curve == 3 then -- Log
      res = math.pow(norm, 1 / (1 + (tension * 4)))
    elseif curve == 4 then -- Sigmoid
      local k = (tension * 10) + 1
      local p = pivot / 127
      res = 1 / (1 + math.exp(-k * (norm - p)))
      -- Normalizar sigmoide
      local min_s = 1 / (1 + math.exp(-k * (0 - p)))
      local max_s = 1 / (1 + math.exp(-k * (1 - p)))
      res = (res - min_s) / (max_s - min_s)
    end
    
    -- Aplicar Clamp y Rescale
    local final_val = min_val + (res * (max_val - min_val))
    oval_math.luts[target][i] = util.clamp(math.floor(final_val), 0, 127)
  end
end

function oval_math.dynamic_zero(current, origin, sens)
  local delta = current - origin
  local scaled = delta * (sens / 50)
  return util.clamp(8192 + math.floor(scaled * 64), 0, 16383)
end

function oval_math.bipolar_mirror(val, min_v, max_v)
  local abs_val = math.abs(val - 64) * 2
  local norm = abs_val / 127
  return util.clamp(math.floor(min_v + (norm * (max_v - min_v))), 0, 127)
end

return oval_math
