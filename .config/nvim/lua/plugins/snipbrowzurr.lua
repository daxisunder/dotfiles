return {
  "blaze-d83/snipbrowzurr.nvim",
  event = "VeryLazy",
  config = function()
    require("snipbrowzurr").setup({ keymap = "<leader>so" })
  end,
}
