------------------------------------------------------------
-- Hyprland Modular Configuration (Lua API)
------------------------------------------------------------

-- Configure Lua package search path to resolve conf modules
local config_dir = os.getenv("XDG_CONFIG_HOME") and (os.getenv("XDG_CONFIG_HOME") .. "/hypr") or (os.getenv("HOME") .. "/.config/hypr")
package.path = config_dir .. "/?.lua;" .. config_dir .. "/?/init.lua;" .. package.path

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("PATH", (os.getenv("HOME") .. "/.local/bin:") .. (os.getenv("PATH") or ""))

-------------------------------
---- SPECIALIZED MODULES ------
-------------------------------

require("conf.monitor")
require("conf.window")
require("conf.decoration")
require("conf.animations")
require("conf.layout")
require("conf.input")
require("conf.autostart")
require("conf.keybinding")
require("conf.windowrule")
