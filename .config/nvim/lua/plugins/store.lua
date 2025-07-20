return {
  "alex-popov-tech/store.nvim",
  dependencies = {
    "MeanderingProgrammer/render-markdown.nvim", -- optional, for pretty readme preview / help window
  },
  event = "VeryLazy",
  cmd = "Store",
  keys = {
    { "<leader>sP", "<cmd>Store<cr>", desc = "Open Plugin Store" },
  },
  opts = {
    -- optional configuration here
  },
}
