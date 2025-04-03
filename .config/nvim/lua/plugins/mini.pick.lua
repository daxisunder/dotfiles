return {
  "echasnovski/mini.pick",
  event = "VeryLazy",
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
