return {
  "nvim-zh/colorful-winsep.nvim",
  lazy = true,
  event = { "WinLeave" },
  config = function()
    require("colorful-winsep").setup({
      symbols = { "─", "│", "╭", "╮", "╰", "╯" },
    })
  end,
}
