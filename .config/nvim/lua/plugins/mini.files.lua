return {
  "nvim-mini/mini.files",
  version = false,
  event = "VeryLazy",
  config = function()
    require("mini.files").setup({
      options = {
        permanent_delete = false,
        use_as_default_explorer = true,
      },
      mappings = {
        close = "q",
        go_in = "L",
        go_in_plus = "l",
        go_out = "H",
        go_out_plus = "h",
        mark_goto = "'",
        mark_set = "m",
        reset = "<BS>",
        reveal_cwd = "@",
        show_help = "g?",
        synchronize = "=",
        trim_left = "<",
        trim_right = ">",
      },
      windows = {
        max_number = 3,
        preview = true,
        width_focus = 30,
        width_nofocus = 30,
        width_preview = 60,
      },
    })
  end,
}
