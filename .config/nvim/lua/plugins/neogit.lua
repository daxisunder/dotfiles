return {
  "NeogitOrg/neogit",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "esmuellert/codediff.nvim", -- optional
    "folke/snacks.nvim", -- optional
  },
  cmd = "Neogit",
  keys = {
    {
      "<leader>gn",
      function()
        require("neogit").open({ kind = "split" })
      end,
      desc = "Neogit UI",
    },
  },
}
