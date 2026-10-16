----------------
---- LAYOUT ----
----------------

-- See https://wiki.hypr.land/Configuring/Dwindle-Layout/
-- See https://wiki.hypr.land/Configuring/Master-Layout/
hl.config({
    dwindle = {
        preserve_split = true,
        smart_resizing = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper  = 0,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        vrr                      = 0,
    },
})
