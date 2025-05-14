return {
  "ellisonleao/carbon-now.nvim",
  lazy = true,
  cmd = "CarbonNow",
  config = function()
    require("carbon-now").setup({
      base_url = "https://carbon.now.sh/",
      options = {
        bg = "black",
        drop_shadow_blur = "68px",
        drop_shadow = true,
        drop_shadow_offset_y = "20px",
        font_family = "Hack",
        font_size = "18px",
        line_height = "133%",
        line_numbers = true,
        theme = "material",
        titlebar = "Made with carbon-now.nvim",
        watermark = true,
        width = "680",
        window_theme = "sharp",
        padding_horizontal = "0px",
        padding_vertical = "0px",
      },
    })
  end,
}
