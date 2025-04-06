conky.config = {
    out_to_console = false,
    out_to_ncurses = false,
    out_to_stderr = false,    
    out_to_x = false,
    out_to_wayland = true,
    alignment = 'top_left',
    font = 'Adwaita Mono:size=11',
    gap_x = 60,
    gap_y = 60,
    minimum_height = 5,
    minimum_width = 2,
    no_buffers = true,
    own_window = true,
    own_window_transparent = false,
    own_window_argb_visual = true,
    own_window_type = 'dock',
    background = true,
    double_buffer = true,
    use_xft = true,
    own_window_argb_value = 170,
    own_window_class = 'Conky',
    own_window_colour = '222222'
};


-- Variables: https://conky.cc/variables
conky.text = [[
${color grey}SSS/GNU - Supreme Sexp System$color

${color grey}Info:$color ${scroll 32 Conky $conky_version - $sysname $nodename $kernel $machine}
$hr
${color grey}CPU Usage:$color $cpu% ${cpubar 4}
${color grey}Frequency (in GHz):$color $freq_g
${color grey}RAM Usage:$color $mem/$memmax - $memperc% ${membar 4}
${color grey}Uptime:$color $uptime
${color grey}Swap Usage:$color $swap/$swapmax - $swapperc% ${swapbar 4}
${color grey}Processes:$color $processes  ${color grey}Running:$color $running_processes
$hr
${color grey}File systems:
 / $color${fs_used /}/${fs_size /} ${fs_bar 6 /}
${color grey}Networking:
Up:$color ${upspeed} ${color grey} - Down:$color ${downspeed}
$hr
${color grey}Name              PID     CPU%   MEM%
${color lightgrey}${top name 1} ${top pid 1} ${top cpu 1} ${top mem 1}
${color lightgrey}${top name 2} ${top pid 2} ${top cpu 2} ${top mem 2}
${color lightgrey}${top name 3} ${top pid 3} ${top cpu 3} ${top mem 3}
${color lightgrey}${top name 4} ${top pid 4} ${top cpu 4} ${top mem 4}
]]

