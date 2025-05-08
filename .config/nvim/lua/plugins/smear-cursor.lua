return {
  "sphamba/smear-cursor.nvim",
  enabled = true,
  event = "CursorMoved",
  cond = vim.g.neovide == nil,
  opts = {
    hide_target_hack = true,
    -- Smear cursor color. Defaults to Cursor GUI color if not set.
    -- Set to "none" to match the text color at the target cursor position.
    cursor_color = "none",
    -- Background color. Defaults to Normal GUI background color if not set.
    normal_bg = "none",
    -- Smear cursor when switching buffers or windows.
    smear_between_buffers = true,
    -- Smear cursor when moving within line or to neighbor lines.
    smear_between_neighbor_lines = true,
    -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
    -- Smears will blend better on all backgrounds.
    legacy_computing_symbols_support = true,
  },
  specs = {
    -- disable mini.animate cursor
    {
      "echasnovski/mini.animate",
      optional = true,
      opts = {
        cursor = { enable = false },
      },
    },
  },
}
