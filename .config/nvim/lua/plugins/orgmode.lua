return {
  "nvim-orgmode/orgmode",
  event = "VeryLazy",
  ft = { "org" },
  config = function()
    -- Setup orgmode
    require("orgmode").setup({
      org_agenda_files = "~/Dropbox/org.files/**/*",
      org_default_notes_file = "~/Dropbox/org.files/refile.org",
    })
  end,
}
