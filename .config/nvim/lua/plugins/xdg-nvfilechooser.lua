return {
  "shenawy29/xdg-nvfilechooser.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  config = function()
    require("xdg-nvfilechooser").setup({
      picker = "snacks",
      keymaps = {
        ["<C-e>"] = { "goto_path", mode = { "n", "i" } },
      },
    })
  end,
}
