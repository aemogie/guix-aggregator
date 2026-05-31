require("variables")

hl.env("HYPRCURSOR_THEME", "McMojave")
hl.env("HYPRCURSOR_SIZE", "32")
hl.env("XCURSOR_THEME", "McMojave")
hl.env("XCURSOR_SIZE", "16")

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 10,
        border_size = 1,
        col = {
            active_border = white,
            inactive_border = black,
        },
    },
    decoration = {
        rounding = 12,
        -- multisample_edges = true
        active_opacity = 0.90,
        inactive_opacity = 0.90,
        -- This overrides window rules
        fullscreen_opacity = 1.0,
        blur = {
            enabled = true,
            size = 2,
            passes = 2,
            ignore_opacity = true,
            xray = false,
            noise = 0.0000,
            contrast = 0.8916,
            brightness = 0.8172,
            special = false,
        },
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            sharp = false,
            -- ignore_window = true,
            color = "rgba(1a1a1aee)",
            color_inactive = "rgba(1a1a1aee)",
            offset = "0 0",
            scale = 1.0,
        },
        dim_inactive = false,
        dim_strength = 0.5,
        dim_special = 0.2,
        dim_around = 0.4,
        -- screen_shader
    },
    animations = {
        enabled = false,
    },
})

