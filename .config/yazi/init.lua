---@diagnostic disable: undefined-global

return {
	"plugin/full-border",
	require("full-border"):setup({
		type = ui.Border.ROUNDED,
	}),
	require("yaziline"):setup({
		color = "#8db0ff",
		secondary_color = "#3b4261",
		default_files_color = "darkgray", -- color of the file counter when it's inactive
		selected_files_color = "magenta",
		yanked_files_color = "green",
		cut_files_color = "red",
		separator_style = "liney", -- "angly" | "curvy" | "liney" | "empty"
		separator_open = "",
		separator_close = "",
		separator_open_thin = "",
		separator_close_thin = "",
		separator_head = "",
		separator_tail = "",
		select_symbol = "",
		yank_symbol = "",
		filename_max_length = 24, -- truncate when filename > 24
		filename_truncate_length = 6, -- leave 6 chars on both sides
		filename_truncate_separator = "...",
	}),
	-- user:group add-on to show user and group names in the status line
	Status:children_add(function(self)
		local h = self._current.hovered
		if h and h.link_to then
			return " -> " .. tostring(h.link_to)
		else
			return ""
		end
	end, 3300, Status.LEFT),
	Status:children_add(function()
		local h = cx.active.current.hovered
		if h == nil or ya.target_family() ~= "unix" then
			return ""
		end
		return ui.Line({
			ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
			":",
			ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("cyan"),
			" ",
		})
	end, 500, Status.RIGHT),
	-- require("githead"):setup({
	-- 	order = {
	-- 		"__spacer__",
	-- 		"branch",
	-- 		"commit",
	-- 		"__spacer__",
	-- 		"behind_ahead_remote",
	-- 		"__spacer__",
	-- 		"untracked",
	-- 		"state",
	-- 		"unstaged",
	-- 		"__spacer__",
	-- 		"staged",
	-- 	},
	-- 	show_numbers = true,
	-- 	show_branch = true,
	-- 	branch_prefix = "",
	-- 	branch_color = "#288BD2",
	-- 	always_show_commit = true,
	-- 	commit_color = "#859A00",
	-- 	show_behind_ahead_remote = true,
	-- 	behind_remote_symbol = "↓",
	-- 	ahead_remote_symbol = "↑",
	-- 	behind_remote_color = "#DC322E",
	-- 	ahead_remote_color = "#4DB6AC",
	-- 	show_state = true,
	-- 	show_state_prefix = false,
	-- 	state_symbol = "!!",
	-- 	state_color = "#B58901",
	-- 	staged_symbol = "✔",
	-- 	staged_color = "green",
	-- 	unstaged_symbol = "Δ",
	-- 	unstaged_color = "#288BD2",
	-- 	untracked_symbol = "?",
	-- 	untracked_color = "#415F65",
	-- }),
	require("git"):setup(),
	require("restore"):setup({
		position = { "center", w = 70, h = 40 },
		show_confirm = true,
		theme = {
			title = "blue",
			header = "green",
			header_warning = "yellow",
			list_item = { odd = "blue", even = "blue" },
		},
	}),
	require("no-header"):setup(),
	require("gvfs"):setup({
		-- (Optional) Allowed keys to select device.
		which_keys = "1234567890qwertyuiopasdfghjklzxcvbnm-=[]\\;',./!@#$%^&*()_+{}|:\"<>?",
		-- (Optional) Save file.
		-- Default: ~/.config/yazi/gvfs.private
		save_path = os.getenv("HOME") .. "/.config/yazi/gvfs.private",
		input_position = { "center", y = 0, w = 60 },
		-- (Optional) Select where to save passwords. Default: nil
		-- Available options: "keyring", "pass", or nil
		password_vault = nil,
		-- (Optional) Only need if you set password_vault = "pass"
		-- Read the guide at SECURE_SAVED_PASSWORD.md to get your key_grip
		key_grip = "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB",
		-- (Optional) save password automatically after mounting. Default: false
		save_password_autoconfirm = false,
	}),
}
