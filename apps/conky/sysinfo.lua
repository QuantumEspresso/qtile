function scaleFontToDpi()
    local handle = io.popen('xrandr | grep \'*\' | awk \'{print $1}\' | cut -d"x" -f2')
    local result = handle:read('*a'):gsub('\n$','')
    handle:close()
    return result
end

function num_of_cores()
    local handle = io.popen('nproc')
    local result = handle:read('*a'):gsub('\n$','')
    handle:close()
    return result
end

scale = scaleFontToDpi() // 1080
fontsize_bar = 5
fontsize_text = 10
fontsize_header = 18
num_of_processes = 5

conky.config = {
    background = true,
    update_interval = 1,
    total_run_times = 0,
    no_buffers = true,
    double_buffer = true,
    cpu_avg_samples = 2,
    net_avg_samples = 2,
	diskio_avg_samples = 10,

    alignment = 'top_right',
    gap_x = 130/scale,
    gap_y = 110/scale,

    -- minimum_height = 180,
    minimum_width = 400,
    maximum_width = 600,

    draw_shades = false,
    draw_outline = false,
    draw_borders = false,
    draw_graph_borders = true,

    own_window = true,
	own_window_class = 'Conky',
    own_window_type = 'override',
    own_window_transparent = true,
    own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
    own_window_colour = '#000000',
    own_window_argb_visual = false,
    own_window_argb_value = 0,
    
	format_human_readable = true,
    use_xft = true,
    xftalpha =  0.1,
    uppercase = false,
    override_utf8_locale = true,

    default_color = '#ffffff',
    default_shade_color = "#ff0000",
    default_outline_color = '#00ff00',
	color0 = '#00ffff',
	color1 = '#264653',

}

conky.text = [[
    ${font Cascadia Code:pixelsize=]].. fontsize_header*scale ..[[}${color0}${alignc}------------------------ ${font Cascadia Code:bold:pixelsize=]].. fontsize_header*scale ..[[}${color0}SYSTEM${font Cascadia Code:pixelsize=]].. fontsize_header*scale ..[[}${color0} -------------------------
    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}${color0}$sysname $kernel $alignr $machine
    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}Date $alignr${time %A, %B %e}
    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}Uptime $alignr${uptime_short}
    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}Total packages $alignr${execi 1 pacman -Q | wc -l}

    ${if_gw}${font Cascadia Code:pixelsize=]].. fontsize_header*scale ..[[}${color0}${alignc}--------------- ${font Cascadia Code:bold:pixelsize=]].. fontsize_header*scale ..[[}${color0}NETWORK: ${gw_iface}${font Cascadia Code:pixelsize=]].. fontsize_header*scale ..[[}${color0} ---------------
    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}${color0}Private IP Address $alignr${addr ${gw_iface}}
    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}${color0}Public IP Address $alignr${execi 10 curl -s api.ipify.org}
    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}${color0}Down: $alignr${downspeed ${gw_iface}}
    ${downspeedgraph ${gw_iface} 20,455 #00ffff #00ffff}
    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}${color0}Up: $alignr${upspeed ${gw_iface}}
    ${upspeedgraph ${gw_iface} 20,455 #00ffff #00ffff}
    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}${color0}Downloaded: ${totaldown ${gw_iface}} ${alignr}${font Cascadia Code:bold:pixelsize=]]..fontsize_text*scale..[[}${color0}Uploaded: ${totalup ${gw_iface}}${endif}

    ${font Cascadia Code:pixelsize=]].. fontsize_header*scale ..[[}${color0}${alignc}--------------------- ${font Cascadia Code:bold:pixelsize=]].. fontsize_header*scale ..[[}${color0}PROCESSORS${font Cascadia Code:pixelsize=]].. fontsize_header*scale ..[[}${color0} --------------------
    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}${color0}CPU model${alignr}${execi 1 lscpu | grep 'Model name' | cut -f 2 -d ":" | awk '{$1=$1}1'}]]
for i = 1,num_of_cores(),1
do
    conky.text = conky.text.."\n"..[[    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}${color0}Core]]..tostring(i)..[[: ${cpu cpu]]..i..[[}% (${freq ]]..i..[[}MHz)${alignr}${cpubar cpu]]..i..[[ ]]..fontsize_bar*scale..[[, 250}]]
end
conky.text = conky.text.."\n"..[[
    ${font Cascadia Code:pixelsize=]].. fontsize_header*scale ..[[}${color0}${alignc}----------------------- ${font Cascadia Code:bold:pixelsize=]].. fontsize_header*scale ..[[}${color0}MEMORY${font Cascadia Code:pixelsize=]].. fontsize_header*scale ..[[}${color0} ----------------------
    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}${color0}Read: $alignr${diskio_read}
    ${diskiograph_read 20,455 #00ffff #00ffff 750}
    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}${color0}Write: $alignr${diskio_write}
    ${diskiograph_write 20,455 #00ffff #00ffff 750}
    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}${color0}Ram: $mem/$memmax${alignr}${membar ]]..fontsize_bar*scale..[[,250}
    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}${color0}/home: ${fs_used /home}/${fs_size /home}${alignr}${fs_bar ]]..fontsize_bar*scale..[[,250}
    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}${color0}Swap: ${swap}/${swapmax}${alignr}${swapbar ]]..fontsize_bar*scale..[[,250}
    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}${color0}Entropy: ${entropy_avail}/${entropy_poolsize}${alignr}${entropy_bar ]]..fontsize_bar*scale..[[,250}

    ${font Cascadia Code:pixelsize=]].. fontsize_header*scale ..[[}${color0}${alignc}---------------------------- ${font Cascadia Code:bold:pixelsize=]].. fontsize_header*scale ..[[}${color0}GPU${font Cascadia Code:pixelsize=]].. fontsize_header*scale ..[[}${color0} ---------------------------
    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}${color0}${execi 1 lspci | grep VGA | cut -d " " -f9- | rev | cut -d " " -f3- | rev}
    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}${color0}GPU load: ${execi 1 cat /sys/class/drm/card0/device/gpu_busy_percent}% (${execi 1 cat /sys/class/drm/card0/device/pp_dpm_sclk | awk '{if($3=="*") print $2}'}) $alignr${execbar ]]..fontsize_bar*scale..[[,250 cat /sys/class/drm/card0/device/gpu_busy_percent}
    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}${color0}VRAM: $alignr${execi 1 ~/.config/qtile/apps/conky/bytes.sh `cat /sys/class/drm/card0/device/mem_info_vram_used`} / ${execi 1 ~/.config/qtile/apps/conky/bytes.sh `cat /sys/class/drm/card0/device/mem_info_vram_total`}
    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}${color0}fan speed: $alignr${execi 1 sensors 2> /dev/null | grep fan | tr -s ' ' | cut -d ' ' -f2} RPM 
    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}${color0}GPU driver: $alignr${execi 1 lspci -nnk | grep -i vga -A3 | grep driver | cut -d ":" -f2-}

    ${font Cascadia Code:pixelsize=]].. fontsize_header*scale ..[[}${color0}${alignc}---------------------- ${font Cascadia Code:bold:pixelsize=]].. fontsize_header*scale ..[[}${color0}PROCESSES${font Cascadia Code:pixelsize=]].. fontsize_header*scale ..[[}${color0} ----------------------
    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}${color0}Total: $alignr${processes}
]]
for i = 1,num_of_processes,1
do
    conky.text = conky.text.."\n"..[[    ${font Cascadia Code:pixelsize=]].. fontsize_text*scale ..[[}${color0}${top_mem name ]]..i..[[}$alignr${top pid ]]..i..[[} PID ${top cpu ]]..i..[[}% CPU ${top mem ]]..i..[[}% Ram]]
end
