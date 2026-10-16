----------------------------
---- GENERAL WINDOW CONF ---
----------------------------

-- Design tokens aligned with Quickshell Light (Latte) palette
hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 8,

        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(8839efee)", "rgba(7287fdee)" }, angle = 45 },
            inactive_border = "rgba(ccd0daaa)",
        },

        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },
})
