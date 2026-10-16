-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
local home       = os.getenv("HOME")
local vicinaeBin = (home and (home .. "/.local/bin/vicinae")) or "vicinae"

hl.on("hyprland.start", function ()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("quickshell")
    hl.exec_cmd("vicinae server")
end)
