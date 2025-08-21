return {
  "echasnovski/mini.diff",
  version = "*",
  config = function()
    require("mini.diff").setup({
      view = {
        style = "sign",
        signs = {
          add = "+",
          change = "o",
          delete = "-",
        },
      },
    })
  end,
}
