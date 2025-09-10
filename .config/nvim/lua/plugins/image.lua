return {
  "3rd/image.nvim",
  build = false,
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("image").setup({
      backend = "ueberzug",
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          filetypes = { "markdown", "orgmode" },
          only_render_image_at_cursor = true,
          only_render_image_at_cursor_mode = "inline",
          floating_windows = false,
        },
        typst = {
          enabled = true,
          filetypes = { "typst" },
          only_render_image_at_cursor = true,
          only_render_image_at_cursor_mode = "inline",
          floating_windows = false,
        },
        html = {
          enabled = true,
          filetypes = { "html", "xhtml", "htm" },
          only_render_image_at_cursor = true,
          only_render_image_at_cursor_mode = "popup",
          floating_windows = false,
        },
        css = {
          enabled = true,
          filetypes = { "css", "sass", "scss" },
          only_render_image_at_cursor = true,
          only_render_image_at_cursor_mode = "inline",
          floating_windows = false,
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = 20,
      max_height_window_percentage = 20,
      scale_factor = 1.0,
      window_overlap_clear_enabled = true,
      editor_only_render_when_focused = false,
    })
  end,
}
