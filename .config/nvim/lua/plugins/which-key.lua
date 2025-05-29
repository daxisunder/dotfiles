return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "classic",
    win = {
      -- don't allow the popup to overlap with the cursor
      no_overlap = false,
      -- width = 1,
      -- height = { min = 4, max = 25 },
      -- col = 0,
      -- row = math.huge,
      border = "rounded", -- none, single, double, shadow
      padding = { 1, 0 }, -- extra window padding [top/bottom, right/left]
      title = true,
      title_pos = "left",
      zindex = 1000,
      -- Additional vim.wo and vim.bo options
      bo = {},
      wo = {
        -- winblend = 10, -- value between 0-100 0 for fully opaque and 100 for fully transparent
      },
    },
    layout = {
      width = {
        -- min and max width of the columns
        min = 25,
      },
      spacing = 3, -- spacing between columns
    },
    spec = {
      mode = { "n", "v" },
      { "<leader>n", group = "org-roam", icon = { icon = " ", color = "green" } },
      { "<leader>o", group = "orgmode", icon = { icon = " ", color = "green" } },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
