return {
  "mikesmithgh/kitty-scrollback.nvim",
  enabled = true,
  lazy = true,
  cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth", "KittyScrollbackGenerateCommandLineEditing" },
  event = { "User KittyScrollbackLaunch" },
  version = "*", -- latest stable version, may have breaking changes if major version changed
  config = function()
    require("kitty-scrollback").setup({
      status_window = {
        show_timer = true,
      },
      visual_selection_highlight_mode = "lighten",
    })
  end,
}
