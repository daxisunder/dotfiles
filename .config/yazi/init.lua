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
		-- Set the position for confirm and overwrite dialogs.
		-- don't forget to set height: `h = xx`
		-- https://yazi-rs.github.io/docs/plugins/utils/#ya.input
		position = { "center", w = 70, h = 40 },

		-- Show confirm dialog before restore.
		-- NOTE: even if set this to false, overwrite dialog still pop up
		show_confirm = true,

		-- colors for confirm and overwrite dialogs
		theme = {
			title = "blue",
			header = "green",
			-- header color for overwrite dialog
			header_warning = "yellow",
			list_item = { odd = "blue", even = "blue" },
		},
	}),
}
