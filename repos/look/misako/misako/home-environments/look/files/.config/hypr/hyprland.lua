require("autostart")
require("input")
require("output")
require("theme")
require("rules")
require("keybinds")

hl.config({
    general = {
        layout = "dwindle",
        no_focus_fallback = true,
        resize_on_border = false,
        extend_border_grab_area = 15,
        hover_icon_on_border = true,
    },
    debug = {
        disable_logs = true,
        enable_stdout_logs = false,
    },
    misc = {
        disable_hyprland_logo = true,
        animate_manual_resizes = false,
        disable_autoreload = true,
        render_unfocused_fps = 15,
        enable_swallow = false,
        swallow_regex = "^(com.mitchellh.ghostty|foot)$",
        swallow_exception_regex = "^(guix shell wev -- we ~)$",
        initial_workspace_tracking = 0,
    },
    cursor = {
        inactive_timeout = 0,
        no_warps = false,
        no_hardware_cursors = true,
        sync_gsettings_theme = false,
        default_monitor = "desc:SAM",
    },
    binds = {
        hide_special_on_workspace_change = true,
        scroll_event_delay = 0,
    },
    render = {
        direct_scanout = 2, -- controled by content type game
        cm_enabled = false,
    },
    xwayland = {
        enabled = true,
    },
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
    opengl = {
        nvidia_anti_flicker = false,
    },
})

