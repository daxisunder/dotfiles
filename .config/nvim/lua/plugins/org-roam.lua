return {
  "chipsenkbeil/org-roam.nvim",
  dependencies = {
    "nvim-orgmode/orgmode",
  },
  ft = "org",
  config = function()
    require("org-roam").setup({
      directory = "~/Dropbox/orgroam",
      org_files = {
        "~/Dropbox/orgfiles",
      },
      bindings = {
        prefix = "<Leader>O",
      },
    })
  end,
}
