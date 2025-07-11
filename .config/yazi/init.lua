---@diagnostic disable: undefined-global

return {
	"plugin/full-border",
	require("full-border"):setup({
		type = ui.Border.ROUNDED,
	}),
	require("yaziline"):setup(),
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
}
