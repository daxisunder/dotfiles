return {
  "echasnovski/mini.basics",
  version = "*",
  config = function()
    require("mini.basics").setup({
      options = {
        basic = true,
        extra_ui = true,
        win_borders = "rounded",
      },
      mappings = {
        basic = true,
        option_toggle_prefix = [[\]],
        windows = true,
        move_with_alt = true,
      },
      autocommands = {
        basic = true,
        relnum_in_visual_mode = false,
      },
      silent = false,
    })
  end,
}
