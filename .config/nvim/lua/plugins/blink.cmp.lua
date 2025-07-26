return {
  "saghen/blink.cmp",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    -- { "Kaiser-Yang/blink-cmp-dictionary" },
    { "archie-judd/blink-cmp-words" },
    { "rafamadriz/friendly-snippets" },
    { "fang2hou/blink-copilot" },
    {
      "saghen/blink.compat",
      optional = true, -- make optional so it's only enabled if any extras need it
      opts = {},
      version = not vim.g.lazyvim_blink_main and "*",
    },
  },
  version = "1.*",
  lazy = true,
  event = "VimEnter",
  opts = {
    keymap = {
      preset = "none", -- default, enter, super-tab or none
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = {
        function(cmp)
          cmp.show({ providers = { "snippets" } })
        end,
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
      ["<C-n>"] = { "select_next", "fallback_to_mappings" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
      ["<A-1>"] = {
        function(cmp)
          cmp.accept({ index = 1 })
        end,
      },
      ["<A-2>"] = {
        function(cmp)
          cmp.accept({ index = 2 })
        end,
      },
      ["<A-3>"] = {
        function(cmp)
          cmp.accept({ index = 3 })
        end,
      },
      ["<A-4>"] = {
        function(cmp)
          cmp.accept({ index = 4 })
        end,
      },
      ["<A-5>"] = {
        function(cmp)
          cmp.accept({ index = 5 })
        end,
      },
      ["<A-6>"] = {
        function(cmp)
          cmp.accept({ index = 6 })
        end,
      },
      ["<A-7>"] = {
        function(cmp)
          cmp.accept({ index = 7 })
        end,
      },
      ["<A-8>"] = {
        function(cmp)
          cmp.accept({ index = 8 })
        end,
      },
      ["<A-9>"] = {
        function(cmp)
          cmp.accept({ index = 9 })
        end,
      },
      ["<A-0>"] = {
        function(cmp)
          cmp.accept({ index = 0 })
        end,
      },
    },
    completion = {
      menu = {
        auto_show = true,
        scrollbar = false,
        border = "rounded",
        draw = {
          columns = {
            { "kind_icon", "label", gap = 1 },
            { "kind", "item_idx", gap = 1 },
          },
          components = {
            item_idx = {
              text = function(ctx)
                return ctx.idx == 10 and "0" or ctx.idx >= 10 and " " or tostring(ctx.idx)
              end,
              highlight = "Boolean", -- optional, only if you want to change its color
            },
            label = {
              text = function(ctx)
                return require("colorful-menu").blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require("colorful-menu").blink_components_highlight(ctx)
              end,
            },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = "rounded",
        },
      },
      ghost_text = {
        enabled = true,
        show_with_menu = false,
        show_without_menu = true,
        show_with_selection = false,
        show_without_selection = true,
      },
      keyword = {
        range = "prefix",
      },
      accept = {
        dot_repeat = true,
        create_undo_point = true,
        resolve_timeout_ms = 100,
        auto_brackets = {
          enabled = true,
        },
      },
      list = {
        max_items = 20,
        selection = {
          preselect = false,
          auto_insert = true,
        },
        cycle = {
          from_top = true,
          from_bottom = true,
        },
      },
    },
    signature = {
      enabled = true,
      trigger = {
        enabled = true,
        show_on_keyword = false,
        show_on_trigger_character = true,
        show_on_insert = false,
        show_on_insert_on_trigger_character = true,
      },
      window = {
        border = "rounded",
        treesitter_highlighting = true,
        show_documentation = false,
      },
    },
    cmdline = {
      keymap = {
        preset = "inherit",
      },
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
        trigger = {
          show_on_blocked_trigger_characters = {},
          show_on_x_blocked_trigger_characters = {},
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
        menu = {
          auto_show = true,
        },
        ghost_text = {
          enabled = true,
        },
      },
    },
    term = {
      enabled = true,
      keymap = { preset = "inherit" }, -- Inherits from top level `keymap` config when not set
      sources = {},
      completion = {
        trigger = {
          show_on_blocked_trigger_characters = {},
          show_on_x_blocked_trigger_characters = nil, -- Inherits from top level `completion.trigger.show_on_blocked_trigger_characters` config when not set
        },
        -- Inherits from top level config options when not set
        list = {
          selection = {
            preselect = nil,
            auto_insert = nil,
          },
        },
        menu = {
          auto_show = nil,
        },
        ghost_text = {
          enabled = nil,
        },
      },
    },
    fuzzy = {
      implementation = "prefer_rust_with_warning",
    },
    snippets = {
      preset = "default", -- or luasnip, mini.snippets
      -- Function to use when expanding LSP provided snippets
      expand = function(snippet)
        vim.snippet.expand(snippet)
      end,
      -- Function to use when checking if a snippet is active
      active = function(filter)
        return vim.snippet.active(filter)
      end,
      -- Function to use when jumping between tab stops in a snippet, where direction can be negative or positive
      jump = function(direction)
        vim.snippet.jump(direction)
      end,
    },
    sources = {
      default = {
        "lsp",
        "path",
        "snippets",
        "buffer",
        "copilot",
        "thesaurus",
        "lazydev",
        "omni",
        "cmdline",
      },
      per_filetype = {
        text = { "dictionary" },
        markdown = { "thesaurus" },
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
          min_keyword_length = 2, -- Minimum number of characters in the keyword to trigger the provider
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
            show_hidden_files_by_default = true,
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
          name = "blink-cmp-words",
          module = "blink-cmp-words.dictionary",
          -- All available options
          opts = {
            -- The number of characters required to trigger completion.
            -- Set this higher if completion is slow, 3 is default.
            dictionary_search_threshold = 3,
            -- See above
            pointer_symbols = { "!", "&", "^" },
          },
        },
        thesaurus = {
          name = "blink-cmp-words",
          module = "blink-cmp-words.thesaurus",
          -- All available options
          opts = {
            -- A score offset applied to returned items.
            -- By default the highest score is 0 (item 1 has a score of -1, item 2 of -2 etc..).
            score_offset = 0,
            -- Default pointers define the lexical relations listed under each definition,
            -- see Pointer Symbols below.
            -- Default is as below ("antonyms", "similar to" and "also see").
            pointer_symbols = { "!", "&", "^" },
          },
        },
        -- dictionary = {
        --   module = "blink-cmp-dictionary",
        --   name = "Dict",
        --   -- Make sure this is at least 2.
        --   -- 3 is recommended
        --   min_keyword_length = 3,
        --   opts = {
        --     -- Don't specify files here, only  directories (with files inside)
        --     dictionary_directories = { vim.fn.expand("/usr/share/wordnet") },
        --     -- Specify files here (.txt, .dict, .add)
        --     dictionary_files = {
        --       vim.fn.expand("$HOME/.config/harper-ls/harper-core/words.txt"),
        --       vim.fn.expand("$HOME/.config/harper-ls/harper-core/dictionary.dict"),
        --       -- user dictionary
        --       vim.fn.expand("$HOME/.config/harper-ls/dictionary.txt"),
        --     },
        --   },
        -- },
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
      compat = {},
    },
  },
  opts_extend = { "sources.completion.enabled_providers", "sources.compat", "sources.default" },
}
