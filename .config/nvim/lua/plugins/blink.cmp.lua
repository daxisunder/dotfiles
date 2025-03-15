return {
  "saghen/blink.cmp",
  dependencies = {
    { "echasnovski/mini.snippets" },
    { "rafamadriz/friendly-snippets" },
    { "giuxtaposition/blink-cmp-copilot" },
  },
  opts = {
    snippets = { preset = "default" },
    completion = {
      menu = { border = "rounded" },
      documentation = { window = { border = "rounded" } },
      keyword = { range = "full" },
      accept = { auto_brackets = { enabled = false } },
      list = { selection = { preselect = false, auto_insert = true } },
    },
    signature = { window = { border = "rounded" } },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer", "copilot", "lazydev", "ripgrep" },
    per_filetype = {
      org = { "orgmode" },
    },
    providers = {
      copilot = {
        name = "copilot",
        module = "blink-cmp-copilot",
        score_offset = 100,
        async = true,
        transform_items = function(_, items)
          local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          local kind_idx = #CompletionItemKind + 1
          CompletionItemKind[kind_idx] = "Copilot"
          for _, item in ipairs(items) do
            item.kind = kind_idx
          end
          return items
        end,
      },
      orgmode = {
        name = "Orgmode",
        module = "orgmode.org.autocompletion.blink",
        fallbacks = "buffer",
      },
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        -- make lazydev completions top priority (see `:h blink.cmp`)
        score_offset = 100,
      },
      ripgrep = {
        module = "blink-cmp-rg",
        name = "Ripgrep",
        -- options below are optional, these are the default values
        opts = {
          -- `min_keyword_length` only determines whether to show completion items in the menu,
          -- not whether to trigger a search. And we only has one chance to search.
          prefix_min_len = 3,
          get_command = function(context, prefix)
            return {
              "rg",
              "--no-config",
              "--json",
              "--word-regexp",
              "--ignore-case",
              "--",
              prefix .. "[\\w_-]+",
              vim.fs.root(0, ".git") or vim.fn.getcwd(),
            }
          end,
          get_prefix = function(context)
            return context.line:sub(1, context.cursor[2]):match("[%w_-]+$") or ""
          end,
        },
      },
    },
    appearance = {
      -- Blink does not expose its default kind icons so you must copy them all (or set your custom ones) and add Copilot
      kind_icons = {
        Copilot = "",
        Text = "󰉿",
        Method = "󰊕",
        Function = "󰊕",
        Constructor = "󰒓",

        Field = "󰜢",
        Variable = "󰆦",
        Property = "󰖷",

        Class = "󱡠",
        Interface = "󱡠",
        Struct = "󱡠",
        Module = "󰅩",

        Unit = "󰪚",
        Value = "󰦨",
        Enum = "󰦨",
        EnumMember = "󰦨",

        Keyword = "󰻾",
        Constant = "󰏿",

        Snippet = "󱄽",
        Color = "󰏘",
        File = "󰈔",
        Reference = "󰬲",
        Folder = "󰉋",
        Event = "󱐋",
        Operator = "󰪚",
        TypeParameter = "󰬛",
      },
    },
  },
}
