return {
  "sphamba/smear-cursor.nvim",
  enabled = false,
  event = "CursorMoved",
  cond = vim.g.neovide == nil,
  opts = {
    never_draw_over_target = true,
    hide_target_hack = true,
    gamma = 1,
    -- Smear cursor color. Defaults to Cursor GUI color if not set.
    -- Set to "none" to match the text color at the target cursor position.
    cursor_color = "none",
    -- Background color. Defaults to Normal GUI background color if not set.
    normal_bg = "none",
    -- Smear cursor when switching buffers or windows.
    smear_between_buffers = true,
    -- Smear cursor when moving within line or to neighbor lines.
    smear_between_neighbor_lines = true,
    -- Draw the smear in buffer space instead of screen space when scrolling
    scroll_buffer_space = true,
    -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
    -- Smears will blend better on all backgrounds.
    legacy_computing_symbols_support = true,
    -- Smear cursor in insert mode.
    -- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.
    smear_insert_mode = true,
    vertical_bar_cursor_insert_mode = true,
    -- Smear cursor in replace mode.
    smear_replace_mode = true,
    horizontal_bar_cursor_replace_mode = true,
  },
  specs = {
    -- disable mini.animate cursor
    {
      "nvim-mini/mini.animate",
      optional = true,
      opts = {
        cursor = { enable = false },
      },
    },
  },
}
