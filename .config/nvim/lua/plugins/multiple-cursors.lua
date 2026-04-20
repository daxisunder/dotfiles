return {
  "brenton-leighton/multiple-cursors.nvim",
  version = false,
  lazy = true,
  config = function(_, opts)
    vim.api.nvim_set_hl(0, "MultipleCursorsCursor", { bg = "#7dcfff", fg = "#000000" })
    vim.api.nvim_set_hl(0, "MultipleCursorsLockedCursor", { bg = "#faba47", fg = "#000000" })
    vim.api.nvim_set_hl(0, "MultipleCursorsVisual", { bg = "#9dce6a", fg = "#000000" })
    vim.api.nvim_set_hl(0, "MultipleCursorsLockedVisual", { bg = "#f7768e", fg = "#000000" })
    require("multiple-cursors").setup(opts)
  end,
  keys = {
    { "<C-j>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "x" }, desc = "Add cursor and move down" },
    { "<C-k>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "x" }, desc = "Add cursor and move up" },
    { "<C-Down>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "i", "x" }, desc = "Add cursor and move down" },
    { "<C-Up>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "i", "x" }, desc = "Add cursor and move up" },
    { "<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = { "n", "i" }, desc = "Add or remove cursor" },
    {
      "<leader>Mm",
      "<Cmd>MultipleCursorsAddVisualArea<CR>",
      mode = { "x" },
      desc = "Add cursors to the lines of the visual area",
    },
    { "<leader>a", "<Cmd>MultipleCursorsAddMatches<CR>", mode = { "n", "x" }, desc = "Add cursors to cword" },
    {
      "<leader>MA",
      "<Cmd>MultipleCursorsAddMatchesV<CR>",
      mode = { "n", "x" },
      desc = "Add cursors to cword in previous area",
    },
    {
      "<leader>Md",
      "<Cmd>MultipleCursorsAddJumpNextMatch<CR>",
      mode = { "n", "x" },
      desc = "Add cursor and jump to next cword",
    },
    { "<leader>MD", "<Cmd>MultipleCursorsJumpNextMatch<CR>", mode = { "n", "x" }, desc = "Jump to next cword" },
    { "<leader>Ml", "<Cmd>MultipleCursorsLock<CR>", mode = { "n", "x" }, desc = "Lock virtual cursors" },
  },
}
