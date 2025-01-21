return {
  "echasnovski/mini.pick",
  version = "*",
  config = function()
    require("mini.pick").setup({
      window = {
        config = {
          border = "rounded",
        },
      },
    })
  end,
}
