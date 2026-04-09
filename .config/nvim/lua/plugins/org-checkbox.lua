return {
  "massix/org-checkbox.nvim",
  ft = { "org" },
  config = function()
    require("orgcheckbox").setup()
  end,
}
