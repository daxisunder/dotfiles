return {
	"plugin/full-border",
	require("full-border"):setup({
		-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
		type = ui.Border.ROUNDED,
	}),
	require("yaziline"):setup(),
}
