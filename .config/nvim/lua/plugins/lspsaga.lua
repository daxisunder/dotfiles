return {
  "nvimdev/lspsaga.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- optional
    "nvim-mini/mini.icons", -- optional
  },
  event = "LspAttach",
  config = function()
    require("lspsaga").setup({})
  end,
}
