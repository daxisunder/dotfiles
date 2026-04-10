return {
  "nvim-mini/mini.diff",
  dependencies = {
    { "lewis6991/gitsigns.nvim", enabled = false },
  },
  version = false,
  event = "LazyFile",
  config = function()
    require("mini.diff").setup({
      view = {
        style = "sign",
        signs = {
          add = "+",
          change = "o",
          delete = "-",
        },
        priority = 199,
      },
    })
  end,
}
