-- Oval MPE Bridge v1.0
-- Tribunal Supremo Forense
--
-- Middleware de correccion y
-- ruteo MPE para Oval Sound.

local oval_params = include("lib/oval_params")
local oval_scales = include("lib/oval_scales")
local oval_math = include("lib/oval_math")
local oval_midi = include("lib/oval_midi")
local oval_ui = include("lib/oval_ui")

oval_state = {
  active_notes = {}, -- [1..8] = nota MIDI actual
  pad_status = {},   -- [1..8] = {pressed=bool, x_origin=int, z_timer=float, vel=int}
  ui_page = 1,
  ui_edit_slot = 1,
  ui_edit_pad = 1,
  dirty = true
}

function init()
  print("Oval MPE Bridge: Iniciando secuencia de arranque...")
  
  -- Inicializar estado de pads
  for i=1,8 do
    oval_state.pad_status[i] = {pressed=false, x_origin=64, z_timer=0, vel=0}
    oval_state.active_notes[i] = 60
  end

  -- Cargar modulos
  oval_math.init()
  oval_scales.init()
  oval_params.init()
  oval_midi.init()
  
  -- Reloj de UI (30fps)
  oval_state.ui_clock = clock.run(function()
    while true do
      clock.sleep(1/30)
      if oval_state.dirty then
        redraw()
        oval_state.dirty = false
      end
    end
  end)
  
  -- Forzar calculo inicial
  oval_scales.recalculate()
  print("Oval MPE Bridge: Sistema Armado.")
end

function key(n, z)
  if n == 2 and z == 1 then
    oval_state.ui_page = util.clamp(oval_state.ui_page - 1, 1, 5)
    oval_state.dirty = true
  elseif n == 3 and z == 1 then
    if oval_state.ui_page == 2 then
      oval_scales.save_custom(oval_state.ui_edit_slot)
    else
      oval_state.ui_page = util.clamp(oval_state.ui_page + 1, 1, 5)
    end
    oval_state.dirty = true
  end
end

function enc(n, d)
  if oval_state.ui_page == 2 then
    if n == 1 then
      oval_state.ui_edit_slot = util.clamp(oval_state.ui_edit_slot + d, 1, 8)
    elseif n == 2 then
      oval_state.ui_edit_pad = util.clamp(oval_state.ui_edit_pad + d, 1, 8)
    elseif n == 3 then
      oval_scales.edit_custom_note(oval_state.ui_edit_slot, oval_state.ui_edit_pad, d)
    end
  else
    if n == 1 then
      params:set("oval_scale", util.clamp(params:get("oval_scale") + d, 1, #oval_scales.names))
    elseif n == 2 then
      params:set("oval_root", util.clamp(params:get("oval_root") + d, 0, 11))
    elseif n == 3 then
      params:set("oval_transpose", util.clamp(params:get("oval_transpose") + d, -12, 12))
    end
  end
  oval_state.dirty = true
end

function redraw()
  screen.clear()
  oval_ui.draw(oval_state)
  screen.update()
end

function cleanup()
  if oval_state.ui_clock then clock.cancel(oval_state.ui_clock) end
  oval_midi.cleanup()
end
