return {
  "echasnovski/mini.splitjoin",
  version = false,
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
