return {
  "nvim-mini/mini.animate",
  version = false,
  enabled = true,
  config = function()
    require("mini.animate").setup({
      cursor = {
        enable = false,
      },
      scroll = {
        enable = false,
      },
      resize = {
        enable = true,
      },
      open = {
        enable = true,
      },
      close = {
        enable = true,
      },
    })
  end,
}
