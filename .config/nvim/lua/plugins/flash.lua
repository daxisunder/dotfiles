return {
  "folke/flash.nvim",
  event = "VeryLazy",
  optional = true,
  specs = {
    {
      "folke/snacks.nvim",
      opts = {
        modes = {
          search = {
            jump = {
              autojump = false,
            },
          },
        },
        picker = {
          win = {
            input = {
              keys = {
                ["<a-s>"] = { "flash", mode = { "n", "i" } },
                ["s"] = { "flash" },
              },
            },
          },
          actions = {
            flash = function(picker)
              require("flash").jump({
                pattern = "^",
                label = { after = { 0, 0 } },
                search = {
                  mode = "search",
                  exclude = {
                    function(win)
                      return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
                    end,
                  },
                },
                action = function(match)
                  local idx = picker.list:row2idx(match.pos[1])
                  picker.list:_move(idx, true, true)
                end,
              })
            end,
          },
        },
      },
      keys = {
        {
          "s",
          mode = { "n", "x", "o" },
          function()
            require("flash").jump()
          end,
          desc = "Flash",
        },
        {
          "S",
          mode = { "n", "o", "x" },
          function()
            require("flash").treesitter()
          end,
          desc = "Flash Treesitter",
        },
        {
          "<leader>cw",
          mode = "n",
          function()
            require("flash").jump({ pattern = vim.fn.expand("<cword>") })
          end,
          desc = "Flash Current Word",
        },
        {
          "r",
          mode = "o",
          function()
            require("flash").remote()
          end,
          desc = "Remote Flash",
        },
        {
          "R",
          mode = { "o", "x" },
          function()
            require("flash").treesitter_search()
          end,
          desc = "Treesitter Search",
        },
        {
          "<c-s>",
          mode = { "c" },
          function()
            require("flash").toggle()
          end,
          desc = "Toggle Flash Search",
        },
        -- Simulate nvim-treesitter incremental selection
        {
          "<c-space>",
          mode = { "n", "o", "x" },
          function()
            require("flash").treesitter({
              actions = {
                ["<c-space>"] = "next",
                ["<BS>"] = "prev",
              },
            })
          end,
          desc = "Treesitter Incremental Selection",
        },
      },
    },
  },
}
