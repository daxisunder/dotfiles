return {
  "alex-popov-tech/store.nvim",
  branch = "2.0-beta",
  dependencies = {
    "MeanderingProgrammer/render-markdown.nvim", -- optional, for pretty readme preview / help window
  },
  event = "VeryLazy",
  cmd = "Store",
  keys = {
    { "<leader>sP", "<cmd>Store<cr>", desc = "Plugin Store" },
  },
  opts = {},
}
