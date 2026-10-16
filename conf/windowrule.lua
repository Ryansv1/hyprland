--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Window-Rules/

-- Suppress maximize requests
hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix XWayland dragging issues
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Productivity floating dialogs
hl.window_rule({
    name  = "float-system-dialogs",
    match = {
        class = "(pavucontrol|org.pulseaudio.pavucontrol|polkit-gnome-authentication-agent-1)",
    },
    float = true,
})

hl.window_rule({
    name  = "float-file-dialogs",
    match = {
        title = "(Open Files?|Save As?|Select a File.*|All Files.*)",
    },
    float = true,
})

-- Vicinae Window Rule
hl.window_rule({
    name  = "vicinae-floating",
    match = { class = "vicinae" },
    float = true,
    pin   = true,
})
