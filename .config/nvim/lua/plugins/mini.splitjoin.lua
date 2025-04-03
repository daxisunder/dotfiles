return {
  "echasnovski/mini.splitjoin",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("mini.splitjoin").setup({
      mappings = {
        toggle = "gS",
        split = "",
        join = "",
      },
    })
  end,
}
