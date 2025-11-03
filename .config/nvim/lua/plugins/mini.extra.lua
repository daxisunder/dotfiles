return {
  "nvim-mini/mini.extra",
  version = false,
  event = "VeryLazy",
  config = function()
    require("mini.extra").setup({})
  end,
}
