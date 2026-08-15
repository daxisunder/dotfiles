-- autostart.lua
local home = os.getenv("HOME")
local scriptsDir = home .. "/.config/hypr/scripts"
local wallDIR = home .. "/Pictures/wallpapers"
local lock = scriptsDir .. "/LockScreen.sh"
local SwwwRandom = scriptsDir .. "/WallpaperAutoChange.sh"

hl.on("hyprland.start", function()
	-- startup
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("pactl set-sink-mute 0 0") -- unmute audio sink; change last 0 to 1 to start muted

	-- start hypridle to start hyprlock
	hl.exec_cmd("hypridle &")

	-- polkit (Polkit Gnome / KDE / Hyprland)
	-- hl.exec_cmd(scriptsDir .. "/Polkit.sh")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")

	-- startup apps
	hl.exec_cmd("waybar")
	hl.exec_cmd("nm-applet --indicator")
	-- hl.exec_cmd("blueman-applet")
	hl.exec_cmd("swaync")
	hl.exec_cmd("firefox")
	hl.exec_cmd("sleep 5 && udiskie")
	hl.exec_cmd("dropbox start -i")
	hl.exec_cmd("sleep 5 && protonvpn-app")
	-- hl.exec_cmd("signal-desktop")
	hl.exec_cmd("sleep 5 && desktop-wakatime-x11")

	-- clipboard manager
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("wl-paste --primary --watch wl-copy")
	hl.exec_cmd("wl-clip-persist --clipboard primary")

	-- wallpaper stuff
	hl.exec_cmd("awww-daemon --format xrgb")
	hl.exec_cmd(SwwwRandom .. " " .. wallDIR) -- random wallpaper switcher every 30 minutes

	-- XDG desktop portal (should auto-start, if not this force-starts it)
	hl.exec_cmd(scriptsDir .. "/PortalHyprland.sh")

	-- interactive-wallpaper (needs more testing)
	-- hl.exec_cmd(home .. "/projects/interactive-wallpaper/shader-desk/build/interactive-wallpaper")
	-- hl.exec_cmd(home .. "/projects/interactive-wallpaper/shader-desk/build/evdev-pointer-daemon --socket /tmp/evdev-pointer.sock")

	-- start plugins on hyprland start (if you have any plugins, add them here)
	hl.exec_cmd("hyprpm reload -n")
end)
