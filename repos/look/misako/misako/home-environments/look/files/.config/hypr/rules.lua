hl.workspace_rule({
    workspace = "name:spotify",
    monitor = "HDMI-A-1",
    default = false,
})

hl.workspace_rule({
    workspace = "name:vesktop",
    monitor = "HDMI-A-1",
    default = false,
})

hl.workspace_rule({
    workspace = "name:steam",
    monitor = "HDMI-A-1",
    default = false,
})

hl.layer_rule({
    match = { namespace = "notifications" },
    no_screen_share = true
})

hl.window_rule({
    name = "telegram",
    match = {
        class = "^(org.telegram.desktop)$",
        initial_title = "^(Telegram)$",
    },
    workspace = "special:telegram silent",
    tag = "nofancy",
    float = true,
    no_screen_share = true,
    size = "(monitor_w*0.25) (monitor_h*0.8)",
    move = "(monitor_w*0.6) (monitor_h*0.05)",
    opacity = "0.95 override 0.8 override",
})

hl.window_rule({
    name = "telegram-viewer",
    match = {
        class = "^(org.telegram.desktop)$",
        initial_title = "^(Media viewer)$",
    },
    workspace = "special:telegram silent",
    tag = "nofancy",
    size = "(monitor_w*0.5) (monitor_h*0.8)",
    move = "(monitor_w*0.05) (monitor_h*0.05)",
    float = true,
    no_screen_share = true,
    suppress_event = "1",
    fullscreen_state = "0 0",
})

hl.window_rule({
    name = "steam",
    match = {
        class = "^(steam)$",
    },
    workspace = "name:steam silent",
    float = false,
})

hl.window_rule({
    match = {
        title = "^()$",
        class = "^(steam)$",
    },
    float = true,
})

hl.window_rule({
    match = {
        title = "^(Sign in to Steam)$",
        class = "^(steam)$",
    },
    float = true,
})

hl.window_rule({
    name = "vesktop",
    match = {
        class = "^(vesktop)$",
    },
    workspace = "name:vesktop silent",
    tag = "nofancy",
    idle_inhibit = "none",
    -- no_screen_share = 1
})

hl.window_rule({
    name = "cinny",
    match = {
        class = "^(cinny)$",
    },
    workspace = "name:vesktop silent",
    -- no_screen_share = true,
})

hl.window_rule({
    name = "spotify",
    match = {
        class = "^(spotify)$",
    },
    workspace = "name:spotify silent",
})

hl.window_rule({
    name = "aerc",
    match = {
        class = "^(com.mail.aerc)$",
    },
    workspace = "special:aerc silent",
})

hl.window_rule({
    name = "senpai",
    match = {
        class = "^(com.irc.senpai)$",
    },
    workspace = "special:senpai silent",
})

hl.window_rule({
    name = "newsraft",
    match = {
        class = "^(com.rss.newsraft)$",
    },
    workspace = "special:newsraft silent",
})

hl.window_rule({
    name = "browser",
    match = {
        class = "^(zen|chromium-browser)$",
    },
    workspace = "2 silent",
    tag = "nofancy",
})

hl.window_rule({
    name = "game",
    match = {
        class = "^(.*\\.exe|steam_app_.*|Minecraft.*)$",
    },
    workspace = "8 silent",
    tag = "nofancy",
    content = "game",
    fullscreen = true,
})

hl.window_rule({
    name = "game-fixes",
    match = {
        class = "^(conhost\\.exe)$",
    },
    workspace = "8 silent",
    tag = "nofancy",
    content = "game",
    float = true,
})

hl.window_rule({
    name = "whatsapp",
    match = {
        title = "(.*WhatsApp.*)",
        class = "^(zen)$",
    },
    no_screen_share = true,
})

hl.window_rule({
    name = "pdf",
    match = {
        class = "^(org.pwmt.zathura|sioyek)$",
    },
    tag = "nofancy",
    -- no_screen_share = 1
    content = "image",
})

hl.window_rule({
    name = "media",
    match = {
        class = "^(mpv|com.obsproject.Studio)$",
    },
    tag = "nofancy",
    content = "video",
})

hl.window_rule({
    name = "awakened-poe-trade",
    match = {
        class = "^(awakened-poe-trade)$",
    },
    size = "(monitor_w) (monitor_h)",
    float = true,
    no_blur = true,
    no_focus = true,
    no_shadow = true,
    pin = true,
    render_unfocused = true,
    center = true,
    fullscreen = true,
})

hl.window_rule({
    name = "nofancy",
    match = {
        tag = "nofancy",
    },
    opaque = true,
    no_blur = true,
    no_anim = true,
    no_shadow = true,
})

