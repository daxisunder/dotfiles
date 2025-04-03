return {
  "massix/org-checkbox.nvim",
  event = "VeryLazy",
  config = function()
    require("orgcheckbox").setup()
  end,
  ft = { "org" },
}
