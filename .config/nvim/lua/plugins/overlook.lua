return {
  "WilliamHsieh/overlook.nvim",
  event = "VeryLazy",
  lazy = true,
  opts = {},
  -- Optional: set up common keybindings
  keys = {
    {
      "<leader>Od",
      function()
        require("overlook.api").peek_definition()
      end,
      desc = "Overlook: Peek Definition",
    },
    {
      "<leader>Oc",
      function()
        require("overlook.api").peek_cursor()
      end,
      desc = "Overlook: Peek Cursor",
    },
    {
      "<leader>OQ",
      function()
        require("overlook.api").close_all()
      end,
      desc = "Overlook: Close All Popups",
    },
    {
      "<leader>Or",
      function()
        require("overlook.api").restore_popup()
      end,
      desc = "Overlook: Restore Popup",
    },
    {
      "<leader>OR",
      function()
        require("overlook.api").restore_all_popups()
      end,
      desc = "Overlook: Restore All Popups",
    },
    {
      "<leader>Os",
      function()
        require("overlook.api").open_in_split()
      end,
      desc = "Overlook: Open Popup In Split",
    },
    {
      "<leader>Ov",
      function()
        require("overlook.api").open_in_vsplit()
      end,
      desc = "Overlook: Open Popup In VSplit",
    },
    {
      "<leader>Ot",
      function()
        require("overlook.api").open_in_tab()
      end,
      desc = "Overlook: Open Popup In New Tab",
    },
    {
      "<leader>Oo",
      function()
        require("overlook.api").open_in_original_window()
      end,
      desc = "Overlook: Open Popup In Original Window",
    },
  },
}
