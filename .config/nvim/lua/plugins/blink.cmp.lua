return {
  "saghen/blink.cmp",
  dependencies = {
    { "Kaiser-Yang/blink-cmp-dictionary" },
    { "nvim-lua/plenary.nvim" },
    { "L3MON4D3/LuaSnip", version = "v2.*" },
    { "fang2hou/blink-copilot" },
    {
      "saghen/blink.compat",
      optional = true, -- make optional so it's only enabled if any extras need it
      opts = {},
      version = not vim.g.lazyvim_blink_main and "*",
    },
  },
  lazy = true,
  event = "InsertEnter",
  opts = {
    completion = {
      menu = {
        auto_show = true,
        border = "rounded",
        draw = {
          columns = {
            { "kind_icon" },
            { "label", "label_description", "kind", gap = 1 },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = { border = "rounded" },
      },
      ghost_text = {
        enabled = true,
        show_with_menu = true,
        show_without_selection = true,
      },
      keyword = { range = "full" },
      accept = {
        auto_brackets = { enabled = true },
      },
      list = {
        selection = { preselect = true, auto_insert = true },
      },
    },
    signature = {
      enabled = true,
      trigger = {
        enabled = true,
        show_on_keyword = true,
        show_on_trigger_character = true,
        show_on_insert = true,
        show_on_insert_on_trigger_character = true,
      },
      window = {
        treesitter_highlighting = true,
        show_documentation = true,
      },
    },
    cmdline = {
      enabled = true,
      sources = function()
        local type = vim.fn.getcmdtype()
        -- Search forward and backward
        if type == "/" or type == "?" then
          return { "buffer" }
        end
        -- Commands
        if type == ":" or type == "@" then
          return { "cmdline" }
        end
        return {}
      end,
      completion = {
        menu = {
          auto_show = true,
        },
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    snippets = { preset = "luasnip" }, -- or default (friendly-snipets), mini.snippets
    sources = {
      compat = {},
      default = { "lsp", "path", "snippets", "buffer", "copilot", "dictionary", "lazydev", "omni", "cmdline" },
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
          -- If multiple providers fallback to the same provider, all the providers must return 0 items for it to fallback
          fallbacks = {},
          score_offset = 0, -- Boost/penalize the score of the items
          override = nil, -- Override the source's functions
        },
        path = {
          module = "blink.cmp.sources.path",
          score_offset = 3,
          fallbacks = { "buffer" },
          opts = {
            trailing_slash = true,
            label_trailing_slash = true,
            get_cwd = function(context)
              return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
            end,
            show_hidden_files_by_default = false,
          },
        },
        snippets = {
          module = "blink.cmp.sources.snippets",
          score_offset = -1,
          -- For `snippets.preset == 'luasnip'`
          opts = {
            -- Whether to use show_condition for filtering snippets
            use_show_condition = true,
            -- Whether to show autosnippets in the completion list
            show_autosnippets = true,
          },
        },
        buffer = {
          module = "blink.cmp.sources.buffer",
          score_offset = -3,
          opts = {
            -- default to all visible buffers
            get_bufnrs = function()
              return vim
                .iter(vim.api.nvim_list_wins())
                :map(function(win)
                  return vim.api.nvim_win_get_buf(win)
                end)
                :filter(function(buf)
                  return vim.bo[buf].buftype ~= "nofile"
                end)
                :totable()
            end,
          },
        },
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
          opts = {
            max_completions = 2,
            max_attempts = 2,
            kind_name = "Copilot", ---@type string | false
            kind_icon = " ", ---@type string | false
            kind_hl = false, ---@type string | false
            debounce = 200, ---@type integer | false
            auto_refresh = {
              backward = true,
              forward = true,
            },
          },
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
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100, -- show at a higher priority than lsp
        },
        omni = {
          module = "blink.cmp.sources.complete_func",
          enabled = function()
            return vim.bo.omnifunc ~= "v:lua.vim.lsp.omnifunc"
          end,
          opts = {
            complete_func = function()
              return vim.bo.omnifunc
            end,
          },
        },
        cmdline = {
          module = "blink.cmp.sources.cmdline",
        },
      },
    },
  },
  opts_extend = { "sources.completion.enabled_providers", "sources.compat", "sources.default" },
}
