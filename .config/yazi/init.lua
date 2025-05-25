return {
	"plugin/full-border",
	require("full-border"):setup({
		-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
		type = ui.Border.ROUNDED,
	}),
	require("yaziline"):setup(),
	require("githead"):setup(),
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
			ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
			" ",
		})
	end, 500, Status.RIGHT),

	Header:children_add(function()
		if ya.target_family() ~= "unix" then
			return ""
		end
		return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
	end, 500, Header.LEFT),
}
