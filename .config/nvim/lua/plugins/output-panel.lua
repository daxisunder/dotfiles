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
      "<localleader>o",
      vim.cmd.OutputPanel,
      mode = "n",
      desc = "Toggle 'output panel'",
    },
  },
}
