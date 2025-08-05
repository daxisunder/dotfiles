return {
  "WilliamHsieh/overlook.nvim",
  event = "VeryLazy",
  lazy = true,
  opts = {},
  -- Optional: set up common keybindings
  keys = {
    {
      "<localleader>pd",
      function()
        require("overlook.api").peek_definition()
      end,
      desc = "Overlook: Peek Definition",
    },
    {
      "<localleader>pc",
      function()
        require("overlook.api").peek_cursor()
      end,
      desc = "Overlook: Peek Cursor",
    },
    {
      "<localleader>pQ",
      function()
        require("overlook.api").close_all()
      end,
      desc = "Overlook: Close All Popups",
    },
    {
      "<localleader>pr",
      function()
        require("overlook.api").restore_popup()
      end,
      desc = "Overlook: Restore Popup",
    },
    {
      "<localleader>pR",
      function()
        require("overlook.api").restore_all_popups()
      end,
      desc = "Overlook: Restore All Popups",
    },
    {
      "<localleader>ps",
      function()
        require("overlook.api").open_in_split()
      end,
      desc = "Overlook: Open Popup In Split",
    },
    {
      "<localleader>pv",
      function()
        require("overlook.api").open_in_vsplit()
      end,
      desc = "Overlook: Open Popup In VSplit",
    },
    {
      "<localleader>pt",
      function()
        require("overlook.api").open_in_tab()
      end,
      desc = "Overlook: Open Popup In New Tab",
    },
    {
      "<localleader>po",
      function()
        require("overlook.api").open_in_original_window()
      end,
      desc = "Overlook: Open Popup In Original Window",
    },
  },
}
