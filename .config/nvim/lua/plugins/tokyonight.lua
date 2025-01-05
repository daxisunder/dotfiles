return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    require("tokyonight").setup({
      on_colors = function(colors)
        colors.bg = "#000000"
        colors.bg_dark = "#000000"
        colors.bg_dark1 = "#1a1b26"
        colors.bg_float = "#000000"
        colors.bg_sidebar = "#000000"
        colors.bg_statusline = "#000000"
        colors.bg_popup = "#000000"
        colors.black = "#000000"
        colors.terminal_black = "#000000"
        colors.terminal = {
          black = "#000000",
          black_bright = "#1a1b26",
          blue = "#7aa2f7",
          blue_bright = "#8db0ff",
          cyan = "#7dcfff",
          cyan_bright = "#a4daff",
          green = "#9ece6a",
          green_bright = "#9fe044",
          magenta = "#bb9af7",
          magenta_bright = "#c7a9ff",
          red = "#f7768e",
          red_bright = "#ff899d",
          white = "#a9b1d6",
          white_bright = "#c0caf5",
          yellow = "#e0af68",
          yellow_bright = "#faba4a",
        }
      end,
    })
  end,
}
