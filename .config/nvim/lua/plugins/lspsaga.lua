return {
  "nvimdev/lspsaga.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- optional
    "echasnovski/mini.icons", -- optional
  },
  event = "LspAttach",
  config = function()
    require("lspsaga").setup({})
  end,
}
