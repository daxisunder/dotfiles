return {
  "echasnovski/mini.files",
  config = function()
    require("mini.files").setup({
      -- Customization of explorer windows
      windows = {
        -- Maximum number of windows to show side by side
        max_number = math.huge,
        -- Whether to show preview of file/directory under cursor
        preview = false,
        -- Width of focused window
        width_focus = 25,
        -- Width of non-focused window
        width_nofocus = 25,
        -- Width of preview window
        width_preview = 25,
      },
      options = {
        -- Whether to use for editing directories
        -- Disabled by default in LazyVim because neo-tree is used for that
        use_as_default_explorer = true,
        -- If set to false, files are moved to the trash directory
        -- To get this dir run :echo stdpath('data')
        -- ~/.local/share/neobean/mini.files/trash
        permanent_delete = false,
      },
      -- Module mappings created only inside explorer.
      -- Use `''` (empty string) to not create one.
      mappings = {
        close = "q",
        go_in = "l",
        go_in_plus = "L",
        go_out = "h",
        go_out_plus = "H",
        mark_goto = "'",
        mark_set = "m",
        reset = "<BS>",
        reveal_cwd = "@",
        show_help = "g?",
        synchronize = "=",
        trim_left = "<",
        trim_right = ">",
      },
    })
  end,
}
