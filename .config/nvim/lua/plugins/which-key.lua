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
        max = 45,
      },
      spacing = 3, -- spacing between columns
    },
    spec = {
      mode = { "n", "v" },
      { "<leader>n", group = "org-roam", icon = { icon = " ", color = "green" } },
      { "<leader>na", group = "alias", icon = { icon = " ", color = "yellow" } },
      { "<leader>nd", group = "dailies", icon = { icon = " ", color = "yellow" } },
      { "<leader>no", group = "origin", icon = { icon = " ", color = "yellow" } },
      { "<leader>o", group = "orgmode", icon = { icon = " ", color = "green" } },
      { "<leader>O", group = "overlook", icon = { icon = " ", color = "yellow" } },
      { "<leader>fP", group = "pick", icon = { icon = "󰢷 ", color = "green" } },
      { "<leader>fPg", group = "git", icon = { icon = "󰊢 ", color = "yellow" } },
      { "<leader>fPG", group = "grep", icon = { icon = " ", color = "green" } },
      { "<leader>fPh", group = "hl/help/hist", icon = { icon = " ", color = "orange" } },
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
