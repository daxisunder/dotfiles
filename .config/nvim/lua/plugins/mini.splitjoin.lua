return {
  "echasnovski/mini.splitjoin",
  version = "*",
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
