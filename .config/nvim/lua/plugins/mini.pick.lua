return {
  "echasnovski/mini.pick",
  version = false,
  event = "VeryLazy",
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
