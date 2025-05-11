local harpoon = require("harpoon")
local harpoon_extensions = require("harpoon.extensions")

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 3,
    },
    settings = {
      save_on_toggle = true,
      sync_on_ui_close = true,
      mark_branch = false,
      tabline = true,
      tabline_prefix = "   ",
      tabline_suffix = "   ",
    },
  },
  keys = function()
    local keys = {
      {
        "<leader>H",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon File",
      },
      {
        "<leader>h",
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list(), {
            ui_max_width = 70,
            ui_min_width = 40,
          })
          local winids = vim.api.nvim_list_wins()
          local harpoon_win = vim.iter(winids):find(function(winid)
            local buf = vim.api.nvim_win_get_buf(winid)
            return vim.bo[buf].filetype == "harpoon"
          end)
          if not harpoon_win then
            return
          end
          vim.api.nvim_win_set_config(harpoon_win, {
            anchor = "NW",
            col = 0,
            row = 0,
            relative = "editor",
            title = " Harpoon Quick Menu ",
            border = "rounded",
          })
        end,
        desc = "Harpoon Quick Menu",
      },
    }
    for i = 1, 5 do
      table.insert(keys, {
        "<leader>" .. i,
        function()
          require("harpoon"):list():select(i)
        end,
        desc = "Harpoon to File " .. i,
      })
    end
    return keys
  end,
  harpoon:extend(harpoon_extensions.builtins.highlight_current_file()),
  harpoon:extend({
    UI_CREATE = function(cx)
      vim.keymap.set("n", "<C-v>", function()
        harpoon.ui:select_menu_item({ vsplit = true })
      end, { buffer = cx.bufnr })

      vim.keymap.set("n", "<C-s>", function()
        harpoon.ui:select_menu_item({ split = true })
      end, { buffer = cx.bufnr })

      vim.keymap.set("n", "<C-t>", function()
        harpoon.ui:select_menu_item({ tabedit = true })
      end, { buffer = cx.bufnr })
    end,
  }),
}
