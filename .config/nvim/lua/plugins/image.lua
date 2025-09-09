return {
  "3rd/image.nvim",
  build = false,
  config = function()
    require("image").setup({
      backend = "ueberzug",
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          filetypes = { "markdown", "org" },
          only_render_image_at_cursor = true,
          only_render_image_at_cursor_mode = "popup",
        },
        html = {
          enabled = true,
          only_render_image_at_cursor = true,
          only_render_image_at_cursor_mode = "popup",
        },
        css = {
          enabled = true,
          only_render_image_at_cursor = true,
          only_render_image_at_cursor_mode = "popup",
        },
      },
      max_height_window_percentage = 25,
      scale_factor = 0.5,
      window_overlap_clear_enabled = true,
      editor_only_render_when_focused = false,
    })
  end,
}
