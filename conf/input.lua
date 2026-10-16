---------------
---- INPUT ----
---------------

-- See https://wiki.hypr.land/Configuring/Variables/#input
hl.config({
    input = {
        kb_layout    = "br",
        kb_model     = "abnt2",
        kb_variant   = "",
        follow_mouse = 1,
        sensitivity  = 0,

        touchpad = {
            natural_scroll = true,
        },
    },
})

-- Gestures
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})
