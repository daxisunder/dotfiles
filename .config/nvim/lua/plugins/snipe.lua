return {
  "leath-dub/snipe.nvim",
  event = "VeryLazy",
  keys = {
    {
      "gb",
      function()
        require("snipe").open_buffer_menu()
      end,
      desc = "Open Snipe buffer menu",
    },
  },
  opts = {
    ui = {
      open_win_override = {
        title = " Snipe Buffer Menu ",
        border = "rounded", -- use "rounded" for rounded border
      },
      buffer_format = {
        "icon",
        " ",
        "filename",
        " ",
        "",
        " ",
        "directory",
        function(buf)
          if vim.fn.isdirectory(vim.api.nvim_buf_get_name(buf.id)) == 1 then
            return " ", "SnipeText"
          end
        end,
      },
    },
    hints = {
      -- Charaters to use for hints (NOTE: make sure they don't collide with the navigation keymaps)
      ---@type string
      dictionary = "123456789",
    },
  },
}
