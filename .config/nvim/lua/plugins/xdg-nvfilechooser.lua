return {
  "shenawy29/xdg-nvfilechooser.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  version = false,
  event = "VeryLazy",
  config = function()
    require("xdg-nvfilechooser").setup({
      picker = "snacks",
      -- Already set by default. Goto_path for the rare case when you want to pick a file in the outside of $HOME.
      keymaps = {
        ["<C-e>"] = { "goto_path", mode = { "n", "i" } },
      },
    })
  end,
}
