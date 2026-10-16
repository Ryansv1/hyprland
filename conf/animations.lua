--------------------
---- ANIMATIONS ----
--------------------

-- See https://wiki.hypr.land/Configuring/Animations/
hl.config({
    animations = {
        enabled = true,
    },
})

-- High-velocity deceleration curves for modern, snappy responsiveness
hl.curve("easeOutExpo",   { type = "bezier", points = { { 0.16, 1.0 }, { 0.3, 1.0 } } })
hl.curve("easeOutQuart",  { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })
hl.curve("almostLinear",  { type = "bezier", points = { { 0.5, 0.5 },  { 0.75, 1.0 } } })
hl.curve("linear",        { type = "bezier", points = { { 0.0, 0.0 },  { 1.0, 1.0 } } })

-- Leaf animations (speed parameter in deciseconds: 1ds = 100ms)
hl.animation({ leaf = "global",           enabled = true,  speed = 2.5, bezier = "easeOutExpo" })

-- Windows: snappy spawn (250ms), immediate dismiss (150ms), smooth move without bounce
hl.animation({ leaf = "windows",          enabled = true,  speed = 2.5, bezier = "easeOutExpo" })
hl.animation({ leaf = "windowsIn",        enabled = true,  speed = 2.5, bezier = "easeOutExpo",  style = "popin 85%" })
hl.animation({ leaf = "windowsOut",       enabled = true,  speed = 1.5, bezier = "easeOutQuart", style = "popin 90%" })
hl.animation({ leaf = "windowsMove",      enabled = true,  speed = 2.5, bezier = "easeOutExpo",  style = "slide" })

-- Fades: crisp and clean (150ms - 200ms)
hl.animation({ leaf = "fade",             enabled = true,  speed = 2.0, bezier = "almostLinear" })
hl.animation({ leaf = "fadeIn",           enabled = true,  speed = 2.0, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",          enabled = true,  speed = 1.5, bezier = "almostLinear" })
hl.animation({ leaf = "fadeSwitch",       enabled = true,  speed = 1.8, bezier = "almostLinear" })
hl.animation({ leaf = "fadeShadow",       enabled = true,  speed = 2.0, bezier = "almostLinear" })
hl.animation({ leaf = "fadeDim",          enabled = true,  speed = 2.0, bezier = "almostLinear" })

-- Layers & Popups
hl.animation({ leaf = "layers",           enabled = true,  speed = 2.5, bezier = "easeOutExpo" })
hl.animation({ leaf = "layersIn",         enabled = true,  speed = 2.5, bezier = "easeOutExpo",  style = "fade" })
hl.animation({ leaf = "layersOut",        enabled = true,  speed = 1.5, bezier = "linear",       style = "fade" })

-- Borders: snappy color transition; disable continuous loop to avoid battery/GPU drain
hl.animation({ leaf = "border",           enabled = true,  speed = 1.5, bezier = "linear" })
hl.animation({ leaf = "borderangle",      enabled = false })

-- Workspaces: slidefade 20% to avoid wide-screen disorientation
hl.animation({ leaf = "workspaces",       enabled = true,  speed = 2.8, bezier = "easeOutExpo",  style = "slidefade 20%" })
hl.animation({ leaf = "workspacesIn",     enabled = true,  speed = 2.8, bezier = "easeOutExpo",  style = "slidefade 20%" })
hl.animation({ leaf = "workspacesOut",    enabled = true,  speed = 2.8, bezier = "easeOutExpo",  style = "slidefade 20%" })
hl.animation({ leaf = "specialWorkspace", enabled = true,  speed = 2.5, bezier = "easeOutExpo",  style = "slidefadevert 15%" })
