return {
  "chipsenkbeil/org-roam.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-orgmode/orgmode",
  },
  config = function()
    require("org-roam").setup({
      directory = "~/Dropbox/orgroam",
      org_files = {
        "~/Dropbox/orgfiles",
      },
    })
  end,
}
