return {
  "NStefan002/screenkey.nvim",
  version = "*", -- or branch = "dev", to use the latest commit
  lazy = false,
  config = function()
    require("screenkey").setup({
      win_opts = {
        row = vim.o.lines - vim.o.cmdheight - 0,
        col = vim.o.columns - 0,
        relative = "editor",
        anchor = "SE",
        width = 40,
        height = 3,
        border = "rounded",
        title = " Screenkey ",
        title_pos = "center",
        style = "minimal",
        focusable = false,
        noautocmd = true,
      },
    })
  end,
}
