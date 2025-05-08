return {
  "aznhe21/actions-preview.nvim",
  event = { "LspAttach" },
  config = function()
    require("actions-preview").setup({
      backend = { "snacks", "minipick", "nui", "telescope" },
      snacks = {
        layout = { preset = "ivy" },
      },
    })
    vim.keymap.set(
      { "v", "n" },
      "<leader>cp",
      require("actions-preview").code_actions,
      { desc = "Code Actions Preview" }
    )
  end,
}
