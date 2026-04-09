return {
  "nvim-mini/mini-git",
  version = false,
  event = "VeryLazy",
  config = function()
    require("mini.git").setup()
  end,
}
