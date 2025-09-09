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
      org_todo_keywords = { "TODO", "ACTIVE", "PARTIAL", "PENDING", "|", "DONE", "ABORTED" },
      org_todo_keyword_faces = {
        ACTIVE = ":foreground green :weight bold",
        PARTIAL = ":foreground blue :weight bold",
        PENDING = ":foreground orange :weight bold",
        ABORTED = ":background red :foreground magenta :slant italic :underline on",
        TODO = ":background #000000 :foreground red", -- overrides builtin color for `TODO` keyword
        DONE = ":background red :foreground #000000", -- overrides builtin color for `DONE` keyword
      },
      org_ellipsis = "",
      win_split_mode = "vertical",
      org_hide_leading_stars = false,
      org_adapt_indentaion = false,
      org_startup_indented = true,
      org_id_link_to_org_use_id = true,
      org_use_tag_inheritance = true,
      org_tags_column = 0,
      org_cycle_separator_lines = 0,
      org_blank_before_new_entry = { heading = true, plain_list_item = true },
      org_priority_highest = "A",
      org_priority_default = "B",
      org_priority_lowest = "F",
      org_deadline_warning_days = 0,
      org_babel_default_header_args = { [":tangle"] = "yes", [":noweb"] = "yes" },
      emacs_config = { executable_path = "emacs", config_path = "/home/daxis/.config/doom/init.el" },
      folds = {
        colored = true,
      },
      agenda = {
        preview_window = {
          border = "rounded",
        },
      },
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
