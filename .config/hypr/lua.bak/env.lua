-- environment variables
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("GDK_BACKEND", "wayland", "x11")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland", "xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "hyprland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")

-- cursor settings
hl.env("HYPERCURSOR_THEME", "rose-pine-hyprcursor")
hl.env("HYPERCURSOR_SIZE", "24")
hl.env("XCURSORTHEME", "BreezeX-Black")
hl.env("XCURSORSIZE", "24")

-- xwayland toolkit specific scale
--hl.env("GDK_SCALE", "2")

-- firefox specific settings
hl.env("MOZ_ENABLE_WAYLAND", "1")

--electron specific settings >28
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- VM specific settings
--hl.env("LIBGL_ALWAYS_SOFTWARE", "1")
--hl.env("WLR_RENDERER_ALLOW_SOFTWARE", "1")
