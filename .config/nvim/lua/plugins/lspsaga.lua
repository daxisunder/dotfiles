return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  config = function()
    require("lspsaga").setup({})
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- optional
    "echasnovski/mini.icons", -- optional
  },
}
