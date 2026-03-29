local oval_params = {}
local roots = {"C","C#","D","D#","E","F","F#","G","G#","A","A#","B"}
local curves = {"Linear", "Exponential", "Logarithmic", "Sigmoid"}

function oval_params.init()
  params:add_group("OVAL MPE: GLOBAL", 4)
  params:add_option("oval_scale", "Scale", oval_scales.names, 1)
  params:set_action("oval_scale", function() oval_scales.recalculate() end)
  params:add_option("oval_root", "Root Note", roots, 3)
  params:set_action("oval_root", function() oval_scales.recalculate() end)
  params:add_number("oval_transpose", "Transpose", -12, 12, 0)
  params:set_action("oval_transpose", function() oval_scales.recalculate() end)
  params:add_number("oval_mpe_zone", "MPE Base Ch", 1, 16, 1)

  params:add_group("OVAL MPE: VELOCITY", 3)
  params:add_option("oval_vel_curve", "Curve", curves, 1)
  params:add_number("oval_vel_tension", "Tension/Slope", 1, 100, 50)
  params:add_number("oval_vel_pivot", "Sigmoid Pivot", 0, 127, 64)
  for _, p in ipairs({"oval_vel_curve", "oval_vel_tension", "oval_vel_pivot"}) do
    params:set_action(p, function() oval_math.build_lut("vel") end)
  end

  params:add_group("OVAL MPE: Z-AXIS (PRESS)", 5)
  params:add_number("oval_z_delay", "Attack Delay ms", 0, 500, 50)
  params:add_option("oval_z_curve", "Curve", curves, 1)
  params:add_number("oval_z_tension", "Tension", 1, 100, 50)
  params:add_number("oval_z_min", "Range Min", 0, 127, 0)
  params:add_number("oval_z_max", "Range Max", 0, 127, 127)
  for _, p in ipairs({"oval_z_curve", "oval_z_tension", "oval_z_min", "oval_z_max"}) do
    params:set_action(p, function() oval_math.build_lut("z") end)
  end

  params:add_group("OVAL MPE: X/Y-AXIS", 4)
  params:add_number("oval_x_sens", "X Sensitivity", 1, 200, 100)
  params:add_option("oval_y_mode", "Y Mode", {"Relative", "Bipolar Mirror"}, 2)
  params:add_number("oval_y_min", "Y Range Min", 0, 127, 0)
  params:add_number("oval_y_max", "Y Range Max", 0, 127, 127)

  params:add_group("OVAL MPE: PROXIMITY", 4)
  params:add_number("oval_prox_dest", "Dest CC", 1, 127, 74)
  params:add_option("oval_prox_inv", "Invert Sensor", {"Off", "On"}, 2)
  params:add_option("oval_prox_curve", "Curve", curves, 2)
  params:add_number("oval_prox_tension", "Tension", 1, 100, 70)
  for _, p in ipairs({"oval_prox_curve", "oval_prox_tension"}) do
    params:set_action(p, function() oval_math.build_lut("prox") end)
  end

  params:add_group("OVAL MPE: TOUCH SWITCH (CC2)", 4)
  params:add_option("oval_cc2_mode", "Mode", {"Off", "Send CC", "Send Note"}, 1)
  params:add_number("oval_cc2_dest", "Dest CC", 1, 127, 16)
  params:add_number("oval_cc2_note", "Trigger Note", 0, 127, 36)
  params:add_number("oval_cc2_vel", "Trigger Vel", 1, 127, 100)

  for s=1,8 do
    for p=1,8 do
      params:add{type="number", id="oval_c_"..s.."_"..p, name="C"..s.." P"..p, min=0, max=127, default=60, action=function() oval_scales.recalculate() end}
      params:hide("oval_c_"..s.."_"..p)
    end
  end
end
return oval_params
