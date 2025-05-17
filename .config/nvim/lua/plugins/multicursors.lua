return {
  "smoka7/multicursors.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvimtools/hydra.nvim",
  },
  opts = {
    DEBUG_MODE = false,
    create_commands = true, -- create Multicursor user commands
    updatetime = 50, -- selections get updated if this many milliseconds nothing is typed in the insert mode see :help updatetime
    nowait = true, -- see :help :map-nowait
    mode_keys = {
      append = "a",
      change = "c",
      extend = "e",
      insert = "i",
    }, -- set bindings to start these modes
    normal_keys = normal_keys,
    insert_keys = insert_keys,
    extend_keys = extend_keys,
    -- see :help hydra-config.hint
    hint_config = {
      float_opts = {
        border = "rounded",
      },
      position = "bottom",
    },
    generate_hints = {
      normal = true,
      insert = true,
      extend = true,
      config = {
        -- determines how many columns are used to display the hints. If you leave this option nil, the number of columns will depend on the size of your window.
        column_count = 10,
        -- maximum width of a column.
        max_hint_length = 25,
      },
    },
  },
  cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
  keys = {
    {
      mode = { "v", "n" },
      "<localleader>m",
      "<cmd>MCstart<cr>",
      desc = "Toggle 'multicursor'",
    },
  },
}
