return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("tokyonight").setup({
      on_colors = function(c)
        c.bg = "#000000"
        c.bg_dark = "#000000"
        c.bg_dark1 = "#1a1b26"
        c.bg_float = "#000000"
        c.bg_popup = "#000000"
        c.bg_sidebar = "#000000"
        c.bg_statusline = "#1a1b26"
        c.bg_visual = "#1a1b26"
        c.black = "#000000"
        c.terminal_black = "#000000"
        c.terminal = {
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
      on_highlights = function(hl, c)
        c.bg = "#000000"
        c.bg_dark1 = "#1a1b26"
        hl.BlinkCmpDocBorder = {
          bg = c.bg,
          fg = c.bg_dark1,
        }
        hl.BlinkCmpMenuBorder = {
          bg = c.bg,
          fg = c.bg_dark1,
        }
        hl.BlinkCmpSignatureHelpBorder = {
          bg = c.bg,
          fg = c.bg_dark1,
        }
        hl.CursorColumn = {
          bg = c.bg_dark1,
        }
        hl.CursorLine = {
          bg = c.bg_dark1,
        }
        hl.FloatBorder = {
          bg = c.bg,
          fg = c.bg_dark1,
        }
        hl.FzfLuaBorder = {
          bg = c.bg,
          fg = c.bg_dark1,
        }
        hl.LspFloatWinBorder = {
          bg = c.bg,
          fg = c.bg_dark1,
        }
        hl.LspInfoBorder = {
          bg = c.bg,
          fg = c.bg_dark1,
        }
        hl.LspSagaCodeActionBorder = {
          bg = c.bg,
          fg = c.bg_dark1,
        }
        hl.LspSagaDefPreviewBorder = {
          bg = c.bg,
          fg = c.bg_dark1,
        }
        hl.LspSagaHoverBorder = {
          bg = c.bg,
          fg = c.bg_dark1,
        }
        hl.LspSagaRenameBorder = {
          bg = c.bg,
          fg = c.bg_dark1,
        }
        hl.LspSagaSignatureHelpBorder = {
          bg = c.bg,
          fg = c.bg_dark1,
        }
        hl.NeoTestBorder = {
          bg = c.bg,
          fg = c.bg_dark1,
        }
        hl.PmenuSel = {
          bg = "#1a1b26",
        }
        hl.PmenuThumb = {
          bg = "#1a1b26",
        }
        hl.SnacksPickerInputBorder = {
          bg = c.bg,
          fg = c.bg_dark1,
        }
        hl.TabLine = {
          bg = c.bg_dark1,
        }
        hl.TreesitterContext = {
          bg = c.bg_dark1,
        }
        hl.WinSeparator = {
          bold = true,
          fg = c.bg_dark1,
        }
      end,
    })
  end,
}
