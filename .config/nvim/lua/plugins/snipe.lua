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
        border = "rounded",
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
      ---@type string
      dictionary = "123456789",
    },
  },
}
