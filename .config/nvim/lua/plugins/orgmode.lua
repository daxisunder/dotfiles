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
      org_agenda_files = { "~/Dropbox/orgfiles/**/*" },
      org_default_notes_file = "~/Dropbox/orgfiles/refile.org",
      org_todo_keywords = {
        "TODO",
        "ACTIVE",
        "PARTIAL",
        "PLANNING",
        "|",
        "CANCELED",
        "DONE",
      },
      org_todo_keyword_faces = {
        TODO = ":foreground #9ece6a :weight bold",
        ACTIVE = ":foreground #7dcfff :weight bold :slant italic",
        PARTIAL = ":foreground #7aa2f7 :weight bold :slant italic",
        PLANNING = ":foreground #e0af68 :weight bold :slant italic",
        CANCELED = ":foreground #f7768e :weight bold",
        DONE = ":foreground #bb9af7 :weight bold",
      },
      org_ellipsis = "...",
      win_split_mode = "vertical",
      org_hide_leading_stars = true,
      org_hide_emphasis_markers = true,
      org_agenda_skip_scheduled_if_done = true,
      org_adapt_indentaion = false,
      org_startup_indented = true,
      org_id_link_to_org_use_id = true,
      org_use_tag_inheritance = true,
      org_tags_column = 0,
      org_cycle_separator_lines = 0,
      org_blank_before_new_entry = {
        heading = true,
        plain_list_item = true,
      },
      org_priority_highest = "A",
      org_priority_default = "B",
      org_priority_lowest = "F",
      org_deadline_warning_days = 0,
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
