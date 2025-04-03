return {
  "nvim-orgmode/orgmode",
  dependencies = {
    "akinsho/org-bullets.nvim",
    "massix/org-checkbox.nvim",
    "saghen/blink.cmp",
  },
  event = "VeryLazy",
  ft = { "org" },
  config = function()
    -- Setup orgmode
    require("orgmode").setup({
      org_agenda_files = "~/Dropbox/orgfiles/**/*",
      org_default_notes_file = "~/Dropbox/orgfiles/refile.org",
    })
    require("org-bullets").setup()
    require("orgcheckbox").setup()
    require("blink.cmp").setup({
      sources = {
        per_filetype = {
          org = { "orgmode" },
        },
        providers = {
          orgmode = {
            name = "Orgmode",
            module = "orgmode.org.autocompletion.blink",
            fallbacks = { "buffer" },
          },
        },
      },
    })
  end,
}
