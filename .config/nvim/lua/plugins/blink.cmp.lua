return {
  "saghen/blink.cmp",
  dependencies = {
    { "Kaiser-Yang/blink-cmp-dictionary" },
    { "nvim-lua/plenary.nvim" },
    { "echasnovski/mini.snippets" },
    { "rafamadriz/friendly-snippets" },
    { "giuxtaposition/blink-cmp-copilot" },
  },
  opts = {
    snippets = { preset = "luasnip" }, -- or default (friendly-snipets), luasnip
    cmdline = { enabled = false },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    completion = {
      menu = {
        auto_show = true,
        border = "rounded",
        -- nvim-cmp style menu
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind", gap = 1 },
          },
        },
      },
      documentation = {
        auto_show = true,
        window = { border = "rounded" },
      },
      ghost_text = { enabled = true },
      keyword = { range = "full" },
      accept = {
        auto_brackets = { enabled = false },
      },
      list = {
        selection = { preselect = false, auto_insert = true },
      },
    },
    signature = {
      enabled = true,
      window = { border = "rounded" },
    },
    appearance = {
      -- Blink does not expose its default kind icons so you must copy them all (or set custom ones) and add Copilot
      kind_icons = {
        Copilot = "",
        Text = "󰉿",
        Method = "󰊕",
        Function = "󰊕",
        Constructor = "󰒓",

        Field = "󰜢",
        Variable = "󰆦 ",
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
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "copilot", "dictionary" },
      per_filetype = {
        org = { "dictionary" },
        markdown = { "dictionary" },
      },
      providers = {
        lsp = {
          name = "LSP",
          module = "blink.cmp.sources.lsp",
          opts = {}, -- Passed to the source directly, varies by source
          --  NOTE: All of these options may be functions to get dynamic behavior
          --  NOTE: See the type definitions for more information
          enabled = true, -- Whether or not to enable the provider
          async = false, -- Whether we should wait for the provider to return before showing the completions
          timeout_ms = 2000, -- How long to wait for the provider to return before showing completions and treating it as asynchronous
          transform_items = nil, -- Function to transform the items before they're returned
          should_show_items = true, -- Whether or not to show the items
          max_items = nil, -- Maximum number of items to display in the menu
          min_keyword_length = 0, -- Minimum number of characters in the keyword to trigger the provider
          -- If this provider returns 0 items, it will fallback to these providers.
          -- If multiple providers fallback to the same provider, all of the providers must return 0 items for it to fallback
          fallbacks = {},
          score_offset = 0, -- Boost/penalize the score of the items
          override = nil, -- Override the source's functions
        },
        copilot = {
          name = "Copilot",
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
        -- orgmode = {
        --   name = "Orgmode",
        --   module = "orgmode.org.autocompletion.blink",
        --   fallbacks = "buffer",
        -- },
        dictionary = {
          module = "blink-cmp-dictionary",
          name = "Dict",
          -- Make sure this is at least 2.
          -- 3 is recommended
          min_keyword_length = 3,
          opts = {
            -- Don't specify files here, only  directories (with files inside)
            dictionary_directories = { vim.fn.expand("/usr/share/wordnet") },
            -- Specify files here (.txt, .dict, .add)
            dictionary_files = {
              vim.fn.expand("~/.config/harper-ls/harper-core/words.txt"),
              vim.fn.expand("~/.config/harper-ls/harper-core/dictionary.dict"),
            },
          },
        },
      },
    },
  },
}
