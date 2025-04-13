return {
  "folke/lazydev.nvim",
  event = "VeryLazy",
  ft = "lua", -- only load on lua files
  opts = {
    librnry = {
      -- See the configuration section for more details
      -- Load luvit types when the `vim.uv` word is found
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      { path = "LazyVim", words = { "LazyVim" } },
      { path = "snacks.nvim", words = { "Snacks" } },
      { path = "lazy.nvim", words = { "LazyVim" } },
    },
  },
  { "folke/neodev.nvim", enabled = false }, -- make sure to uninstall or disable neodev.nvim
}
