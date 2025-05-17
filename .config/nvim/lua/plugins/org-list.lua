return {
  "hamidi-dev/org-list.nvim",
  event = "VeryLazy",
  config = function()
    require("org-list").setup({
      mapping = {
        key = "<leader>oL", -- nvim-orgmode users: you might want to change this to <leader>olt
        desc = "org cycle list types",
      },
      checkbox_toggle = {
        enabled = true,
        key = "<C-,>", -- Change the checkbox toggle key
        desc = "Toggle checkbox state",
        filetypes = { "org", "markdown" }, -- Add more filetypes as needed
      },
    })
  end,
}
