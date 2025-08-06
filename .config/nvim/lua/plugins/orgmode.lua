return {
  "nvim-orgmode/orgmode",
  dependencies = {
    "akinsho/org-bullets.nvim",
    "massix/org-checkbox.nvim",
    "saghen/blink.cmp",
  },
  event = "VeryLazy",
  ft = { "org", "orgagenda" },
  cmd = "Org",
  config = function()
    require("orgmode").setup({
      org_agenda_files = "~/Dropbox/orgfiles/**/*",
      org_default_notes_file = "~/Dropbox/orgfiles/refile.org",
      org_todo_keywords = { "TODO", "WAITING", "|", "DONE", "DELEGATED" },
      org_todo_keyword_faces = {
        WAITING = ":foreground blue :weight bold",
        DELEGATED = ":background #FFFFFF :slant italic :underline on",
        TODO = ":background #000000 :foreground red", -- overrides builtin color for `TODO` keyword
      },
      org_babel_default_header_args = { [":tangle"] = "yes", [":noweb"] = "yes" },
      emacs_config = { executable_path = "emacs", config_path = "/home/daxis/.config/doom/init.el" },
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
