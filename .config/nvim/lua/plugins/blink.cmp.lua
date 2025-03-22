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
    snippets = {
      preset = "default",
    },
    completion = {
      menu = {
        border = "rounded",
      },
      documentation = {
        auto_show = true,
        window = {
          border = "rounded",
        },
      },
      -- Displays a preview of the selected item on the current line
      ghost_text = {
        enabled = true,
      },
      keyword = {
        range = "full",
      },
      accept = {
        auto_brackets = {
          enabled = false,
        },
      },
      list = {
        selection = {
          preselect = false,
          auto_insert = true,
        },
      },
    },
    signature = {
      window = {
        border = "rounded",
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
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "copilot", "dictionary" },
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
