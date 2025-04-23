return {
  "aznhe21/actions-preview.nvim",
  event = { "LspAttach" },
  config = function()
    require("actions-preview").setup({
      backend = { "snacks", "minipick", "telescope", "nui" },
      snacks = {
        layout = { preset = "ivy" },
      },
    })
    vim.keymap.set({ "v", "n" }, "ga", require("actions-preview").code_actions, { desc = "Code Actions" })
  end,
}
