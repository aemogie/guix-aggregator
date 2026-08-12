require("variables")
--
-- Application bindings
--
-- TODO: better handle hardcoded directories
hl.bind("SUPER + return"        , hl.dsp.exec_cmd(term), { repeating = true })
hl.bind("print"                 , hl.dsp.exec_cmd("grim -g \"$(slurp)\" -t png - | wl-copy -t image/png"))
hl.bind("CTRL + print"          , hl.dsp.exec_cmd("grim -g \"$(slurp -o)\" -t png - | wl-copy -t image/png"))
hl.bind("CTRL + ALT_L + print"  , hl.dsp.exec_cmd("grim -t png - | wl-copy -t image/png"))
hl.bind("SUPER + SHIFT + d"     , hl.dsp.exec_cmd("bemenu-run -i -n -l 5 -p spawn:"))
hl.bind("SUPER + SHIFT + g"     , hl.dsp.exec_cmd("zathura \"$(find /home/look/desktop/graduacao -regex '.*\\.pdf' | bemenu --no-exec -n -i -l 10 -p Book:)\""))
hl.bind("SUPER + SHIFT + b"     , hl.dsp.exec_cmd("zathura \"$(find /home/look/books/direito -regex '.*\\.pdf' | bemenu --no-exec -n -i -l 10 -p Book:)\""))

hl.bind("SUPER + e"             , hl.dsp.exec_cmd(term .. " -e " .. editor))
hl.bind("SUPER + SHIFT + return", hl.dsp.exec_cmd(term .. " -e " .. fm))
hl.bind("SUPER + b"             , hl.dsp.exec_cmd("zen"))
hl.bind("SUPER + z"             , hl.dsp.exec_cmd("mpv \"$(wl-paste)\""))

hl.bind("CTRL + mouse_down", function()
    local w = hl.get_active_window()
    if w ~= nil and w.class == "steam_app_238960" or w.class == "awakened-poe-trade" then
        hl.dispatch(hl.dsp.exec_cmd("xdotool search --name 'Path' click 1"))
    end
end)

hl.bind("CTRL + mouse_up", function()
    local w = hl.get_active_window()
    if w ~= nil and w.class == "steam_app_238960" or w.class == "awakened-poe-trade" then
        hl.dispatch(hl.dsp.exec_cmd("xdotool search --name 'Path' click 1"))
    end
end)

--
-- Window bindings
--
hl.bind("SUPER + CTRL + q"     , hl.dsp.exit())
hl.bind("SUPER + SHIFT + q"    , hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + tab"          , hl.dsp.window.cycle_next(""))
hl.bind("SUPER + q"            , hl.dsp.window.close(), { repeating = true })
hl.bind("SUPER + f"            , hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("SUPER + m"            , hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind("SUPER + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + space"        , hl.dsp.focus({ urgent_or_last = true }))
hl.bind("SUPER + SHIFT + r"    , hl.dsp.force_renderer_reload())
hl.bind("SUPER + SHIFT + p"    , hl.dsp.window.pseudo())

--
-- Workspace bindings
--
local workspaces = {
  { "1", 1 }, { "2", 2 }, { "3", 3 }, { "4", 4 }, { "5", 5 },
  { "6", 6 }, { "7", 7 }, { "8", 8 }, { "9", 9 }, { "0", 10 },
  { "minus",        "special:telegram" },
  { "equal",        "special:aerc"     },
  { "bracketleft",  "special:senpai"   },
  { "dead_acute",   "special:newsraft" },
  { "dead_tilde",   "name:spotify"     },
  { "ccedilla",     "name:fluxer"      },
  { "bracketright", "name:steam"       },
}

for _, bind in ipairs(workspaces) do
  local key, ws = bind[1], bind[2]
  local name = type(ws) == "string" and ws:match("^special:(.+)$")
  if name then
    hl.bind("SUPER + " .. key, hl.dsp.workspace.toggle_special(name))
  else
    hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = ws }))
  end
  hl.bind("SUPER + SHIFT + " .. bind[1], hl.dsp.window.move({ workspace = bind[2], follow = false }))
end

local dirs = {
  left  = { "left" , "h" },
  right = { "right", "l" },
  up    = { "up"   , "k" },
  down  = { "down" , "j" },
}

for dir, keys in pairs(dirs) do
  for _, key in ipairs(keys) do
    hl.bind("SUPER + "                .. key, hl.dsp.focus({ direction = dir }))
    hl.bind("SUPER + SHIFT + "        .. key, hl.dsp.window.swap({ direction = dir }))
    hl.bind("SUPER + CTRL + SHIFT + " .. key, hl.dsp.workspace.move({ monitor = dir }))
  end
end

--
-- XF bindings
--
hl.bind("XF86AudioRaiseVolume" , hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume" , hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute"        , hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMicMute"     , hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))

hl.bind("XF86AudioPlay"        , hl.dsp.exec_cmd("playerctl -p spotify play-pause"), { locked = true })
hl.bind("XF86AudioPause"       , hl.dsp.exec_cmd("playerctl -p spotify pause"), { locked = true })
hl.bind("XF86AudioStop"        , hl.dsp.exec_cmd("playerctl -p spotify stop"), { locked = true })
hl.bind("XF86AudioNext"        , hl.dsp.exec_cmd("playerctl -p spotify next"), { locked = true })
hl.bind("XF86AudioPrev"        , hl.dsp.exec_cmd("playerctl -p spotify previous"), { locked = true })

hl.bind("XF86MonBrightnessUp"  , hl.dsp.exec_cmd("light -A 10"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("light -U 10"), { locked = true, repeating = true })

--
-- Resize windows
--
-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag())
hl.bind("SUPER + mouse:273", hl.dsp.window.resize())

hl.bind("SUPER + r", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
  local dirs = {
    { keys = { "right", "l" }, delta = { x = 10 , y = 0  } },
    { keys = { "left" , "h" }, delta = { x = -10, y = 0  } },
    { keys = { "up"   , "k" }, delta = { x = 0  , y = -10 } },
    { keys = { "down" , "j" }, delta = { x = 0  , y = 10  } },
  }

  for _, dir in ipairs(dirs) do
    local action = hl.dsp.window.resize({ x = dir.delta.x, y = dir.delta.y, relative = true })
    for _, key in ipairs(dir.keys) do
      hl.bind(key, action, { repeating = true })
    end
  end

  hl.bind("escape", hl.dsp.submap("reset"))
end)

--
-- Present mode
--
hl.bind("SUPER + p", hl.dsp.submap("present"))

hl.define_submap("present", function()
  hl.bind("m"        , hl.dsp.exec_cmd("wl-present mirror"))
  hl.bind("o"        , hl.dsp.exec_cmd("wl-present set-output"))
  hl.bind("r"        , hl.dsp.exec_cmd("wl-present set-region"))
  hl.bind("SHIFT + r", hl.dsp.exec_cmd("wl-present unset-region"))
  hl.bind("s"        , hl.dsp.exec_cmd("wl-present set-scaling"))
  hl.bind("f"        , hl.dsp.exec_cmd("wl-present toggle-freeze"))

  hl.bind("escape", hl.dsp.submap("reset"))
end)

local MAX_ZOOM = 3
local MIN_ZOOM = 1
local ZOOM_TOGGLE_FACTOR = 1.5

---@param offset number
---@return nil
local function zoom(offset)
    local current = hl.get_config("cursor.zoom_factor")
    if offset ~= nil then
        current = current + offset
    elseif current ~= MIN_ZOOM then
        current = MIN_ZOOM
    else
        current = ZOOM_TOGGLE_FACTOR
    end
    current = math.max(MIN_ZOOM, math.min(MAX_ZOOM, current))
    hl.config({ cursor = { zoom_factor = current } })
end

hl.bind("SUPER + Z", zoom)
hl.bind("SUPER + KP_ADD", function()
    zoom(0.5)
end)
hl.bind("SUPER + minus", function()
    zoom(-0.5)
end)
