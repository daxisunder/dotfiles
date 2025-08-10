return {
  "mhanberg/output-panel.nvim",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("output_panel").setup({
      max_buffer_size = 5000, -- default
    })
  end,
  cmd = { "OutputPanel" },
  keys = {
    {
      "<leader>co",
      vim.cmd.OutputPanel,
      mode = { "n", "v" },
      desc = "Output Panel",
    },
  },
}
