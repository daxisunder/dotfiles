return {
  "massix/org-checkbox.nvim",
  config = function()
    require("orgcheckbox").setup()
  end,
  ft = { "org" },
}
