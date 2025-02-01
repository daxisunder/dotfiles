return {
  "chipsenkbeil/org-roam.nvim",
  tag = "0.1.1",
  dependencies = {
    "nvim-orgmode/orgmode",
    tag = "0.3.7",
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
