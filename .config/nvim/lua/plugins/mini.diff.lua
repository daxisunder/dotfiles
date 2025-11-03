return {
  "nvim-mini/mini.diff",
  version = false,
  event = "VeryLazy",
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
