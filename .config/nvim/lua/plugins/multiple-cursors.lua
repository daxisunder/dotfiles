return {
  "brenton-leighton/multiple-cursors.nvim",
  version = false,
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
      "<localleader>m",
      "<Cmd>MultipleCursorsAddVisualArea<CR>",
      mode = { "x" },
      desc = "Add cursors to the lines of the visual area",
    },
    { "<localleader>a", "<Cmd>MultipleCursorsAddMatches<CR>", mode = { "n", "x" }, desc = "Add cursors to cword" },
    {
      "<localleader>A",
      "<Cmd>MultipleCursorsAddMatchesV<CR>",
      mode = { "n", "x" },
      desc = "Add cursors to cword in previous area",
    },
    {
      "<localleader>d",
      "<Cmd>MultipleCursorsAddJumpNextMatch<CR>",
      mode = { "n", "x" },
      desc = "Add cursor and jump to next cword",
    },
    { "<localleader>D", "<Cmd>MultipleCursorsJumpNextMatch<CR>", mode = { "n", "x" }, desc = "Jump to next cword" },
    { "<localleader>l", "<Cmd>MultipleCursorsLock<CR>", mode = { "n", "x" }, desc = "Lock virtual cursors" },
  },
}
