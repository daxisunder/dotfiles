-- return {
--   "NStefan002/screenkey.nvim",
--   version = "*", -- or branch = "dev", to use the latest commit
--   event = "VeryLazy",
--   config = function()
--     require("screenkey").setup({
--       win_opts = {
--         row = vim.o.lines - vim.o.cmdheight - 0,
--         col = vim.o.columns - 0,
--         relative = "editor",
--         anchor = "SE",
--         width = 40,
--         height = 3,
--         border = "rounded",
--         title = " Screenkey ",
--         title_pos = "left",
--         style = "minimal",
--         focusable = false,
--         noautocmd = true,
--       },
--     })
--   end,
--   keys = {
--     { "<leader>uk", "<cmd>Screenkey<cr>", desc = "Open Screenkey" },
--   },
-- }
return {
  "nvchad/showkeys",
  cmd = "ShowkeysToggle",
  event = "VeryLazy",
  keys = {
    { "<leader>uk", "<cmd>ShowkeysToggle<cr>", desc = "Open Screenkey" },
  },
  opts = {
    timeout = -1,
    maxkeys = 5,
    show_count = true,
    position = "bottom-right",
    winopts = {
      border = "rounded",
    },
  },
}
