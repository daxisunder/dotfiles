require("full-border"):setup({
	type = ui.Border.ROUNDED,
})

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
})

-- user:group add-on to show user and group names in the yaziline
Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return " -> " .. tostring(h.link_to)
	else
		return ""
	end
end, 3300, Status.LEFT)
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
end, 500, Status.RIGHT)

-- signs for git.yazi
th.git = th.git or {}
th.git.added_sign = "+"
th.git.modified_sign = "o"
th.git.deleted_sign = "-"
require("git"):setup()

require("recycle-bin"):setup()

require("no-header"):setup()

require("sshfs"):setup()

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
})

-- require("githead"):setup({
-- 	order = {
-- 		"__spacer__",
-- 		"stashes",
-- 		"__spacer__",
-- 		"state",
-- 		"__spacer__",
-- 		"staged",
-- 		"__spacer__",
-- 		"unstaged",
-- 		"__spacer__",
-- 		"untracked",
-- 		"__spacer__",
-- 		"branch",
-- 		"remote_branch",
-- 		"__spacer__",
-- 		"tag",
-- 		"__spacer__",
-- 		"commit",
-- 		"__spacer__",
-- 		"behind_ahead_remote",
-- 		"__spacer__",
-- 	},
--
-- 	branch_borders = "[]",
-- 	branch_prefix = "|",
-- 	branch_color = "#7aa2f7",
-- 	remote_branch_color = "#9ece6a",
-- 	always_show_remote_branch = true,
-- 	always_show_remote_repo = true,
--
-- 	tag_symbol = "󰓼",
-- 	always_show_tag = true,
-- 	tag_color = "#bb9af7",
--
-- 	commit_symbol = "",
-- 	always_show_commit = true,
-- 	commit_color = "#e0af68",
--
-- 	staged_color = "#73daca",
-- 	staged_symbol = "●",
--
-- 	unstaged_color = "#e0af68",
-- 	unstaged_symbol = "✗",
--
-- 	untracked_color = "#f7768e",
-- 	untracked_symbol = "?",
--
-- 	state_color = "#f5c359",
-- 	state_symbol = "󱐋",
--
-- 	stashes_color = "#565f89",
-- 	stashes_symbol = "⚑",
-- }),
