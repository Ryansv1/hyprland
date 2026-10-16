---------------------
---- KEYBINDINGS ----
---------------------

local home        = os.getenv("HOME")
local vicinaeBin  = (home and (home .. "/.local/bin/vicinae")) or "vicinae"
local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "vicinae toggle"
local mainMod     = "SUPER"

-- Core Application Launchers
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q",      hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + space",  hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + D",      hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + C",      hl.dsp.window.close())
hl.bind(mainMod .. " + F",      hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + V",      hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P",      hl.dsp.window.pseudo())
hl.bind(mainMod .. " + backslash", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + M",      hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

-- Directional Focus (Arrows + Vim H/J/K/L)
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + h",     hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + j",     hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + k",     hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + l",     hl.dsp.focus({ direction = "right" }))

-- Window Movement (SHIFT + Arrows + SHIFT + Vim H/J/K/L)
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + h",     hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + j",     hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + k",     hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + l",     hl.dsp.window.move({ direction = "right" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special Workspace (Scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Mouse Navigation & Resizing
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272",  hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273",  hl.dsp.window.resize(), { mouse = true })

-- Productivity Tools: Screenshots & Color Picker
hl.bind("Print",                   hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy --type image/png"))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy --type image/png"))
hl.bind("CTRL + Print",            hl.dsp.exec_cmd("grim - | wl-copy --type image/png"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))

-- Interactive Resize Submap
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function ()
    hl.bind("right", hl.dsp.window.resize({ x = 20, y = 0, relative = true }),  { repeating = true })
    hl.bind("left",  hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
    hl.bind("up",    hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
    hl.bind("down",  hl.dsp.window.resize({ x = 0, y = 20, relative = true }),  { repeating = true })
    hl.bind("l",     hl.dsp.window.resize({ x = 20, y = 0, relative = true }),  { repeating = true })
    hl.bind("h",     hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
    hl.bind("k",     hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
    hl.bind("j",     hl.dsp.window.resize({ x = 0, y = 20, relative = true }),  { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
    hl.bind("Return", hl.dsp.submap("reset"))
end)

-- Laptop / Multimedia Keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("quickshell ipc call osd adjustBrightness 0.05 2>/dev/null || brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("quickshell ipc call osd adjustBrightness -0.05 2>/dev/null || brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
