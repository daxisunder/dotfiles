return {
  "dmtrKovalenko/fff.nvim",
  build = function()
    -- downloads a prebuilt binary or falls back to cargo build
    require("fff.download").download_or_build_binary()
  end,
  lazy = false, -- the plugin lazy-initialises itself
  opts = {
    layout = {
      height = 0.6,
      width = 0.7,
      preview_size = 0.6,
      show_scrollbar = false,
      anchor = "center",
    },
    keymaps = {
      close = "<Esc>",
      select = "<CR>",
      select_split = "<C-s>",
      select_vsplit = "<C-v>",
      select_tab = "<C-t>",
      move_up = { "<Up>", "<C-p>" },
      move_down = { "<Down>", "<C-n>" },
      preview_scroll_up = "<C-u>",
      preview_scroll_down = "<C-d>",
      toggle_debug = "<F2>",
      cycle_grep_modes = "<S-Tab>",
      cycle_previous_query = "<C-Up>",
      toggle_select = "<Tab>",
      send_to_quickfix = "<C-q>",
      focus_list = "<leader>l",
      focus_preview = "<leader>p",
    },
    git = {
      status_text_color = true, -- true to color filenames by git status
    },
    debug = {
      enabled = true,
      show_scores = true,
    },
    logging = {
      enabled = true,
      log_file = vim.fn.stdpath("log") .. "/fff.log",
      log_level = "info",
    },
  },
  keys = {
    {
      "<localleader>ff",
      function()
        require("fff").find_files()
      end,
      desc = "FFFind files",
    },
    {
      "<localleader>fg",
      function()
        require("fff").live_grep()
      end,
      desc = "LiFFFe grep",
    },
    {
      "<localleader>fz",
      function()
        require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } })
      end,
      desc = "Live fffuzy grep",
    },
    {
      "<localleader>fc",
      function()
        require("fff").live_grep({ query = vim.fn.expand("<cword>") })
      end,
      desc = "Search current word",
    },
  },
}
