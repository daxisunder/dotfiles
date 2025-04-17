local util = require("lspconfig.util")
local lspconfig = require("lspconfig")
local capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

return {
  "neovim/nvim-lspconfig",
  dependencies = { "saghen/blink.cmp" },
  event = "VeryLazy",
  opts = {
    servers = {
      lspconfig.asm_lsp.setup({
        capabilities = capabilities,
        cmd = { "asm-lsp" },
        filetypes = { "asm", "vmasm" },
        single_file_support = true,
        root_dir = function(fname)
          return vim.fs.dirname(vim.fs.find({ ".asm-lsp.toml", ".git" }, { path = fname, upward = true })[1])
        end,
      }),
      lspconfig.jsonls.setup({
        capabilities = capabilities,
        cmd = { "vscode-json-language-server", "--stdio" },
        filetypes = { "json", "jsonc" },
        root_dir = function(fname)
          return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
        end,
        init_options = {
          provideFormatter = true,
        },
        single_file_support = true,
      }),
      lspconfig.ruby_lsp.setup({
        capabilities = capabilities,
        cmd = { "ruby-lsp" },
        filetypes = { "ruby", "eruby" },
        root_dir = util.root_pattern("Gemfile", ".git"),
        init_options = {
          formatter = "auto",
        },
        single_file_support = true,
      }),
      lspconfig.rubocop.setup({
        capabilities = capabilities,
        cmd = { "rubocop", "--lsp" },
        filetypes = { "ruby" },
        root_dir = util.root_pattern("Gemfile", ".git"),
      }),
      lspconfig.phpactor.setup({
        capabilities = capabilities,
        cmd = { "phpactor", "language-server" },
        filetypes = { "php" },
        root_dir = function(pattern)
          local cwd = vim.loop.cwd()
          local root = util.root_pattern("composer.json", ".git", ".phpactor.json", ".phpactor.yml")(pattern)
          -- prefer cwd if root is a descendant
          return util.path.is_descendant(cwd, root) and cwd or root
        end,
      }),
      lspconfig.perlls.setup({
        capabilities = capabilities,
        cmd = {
          "perl",
          "-MPerl::LanguageServer",
          "-e",
          "Perl::LanguageServer::run",
          "--",
          "--port 13603",
          "--nostdio 0",
        },
        settings = {
          perl = {
            perlCmd = "perl",
            perlInc = " ",
            fileFilter = { ".pm", ".pl" },
            ignoreDirs = ".git",
          },
        },
        filetypes = { "perl" },
        root_dir = function(fname)
          return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
        end,
        single_file_support = true,
      }),
      lspconfig.hyprls.setup({
        capabilities = capabilities,
        cmd = { "hyprls", "--stdio" },
        filetypes = { "hyprlang" },
        root_dir = function(fname)
          return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
        end,
        single_file_support = true,
      }),
      lspconfig.ltex.setup({
        capabilities = capabilities,
        cmd = { "ltex-ls" },
        filetypes = { "latex", "tex", "org", "bib", "plaintext", "markdown", "mail", "text" },
        root_dir = function(fname)
          return vim.fn.fnamemodify(fname, ":h")
        end,
        settings = {
          ltex = {
            enabled = { "org", "markdown", "text", "plaintext" },
            language = "en-US",
            check_text = {
              on_change = true,
              on_open = false,
              on_save = false,
            },
          },
        },
      }),
      lspconfig.textlsp.setup({
        capabilities = capabilities,
        cmd = { "textlsp" },
        filetypes = { "text", "tex", "org" },
        root_dir = function(fname)
          return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
        end,
        single_file_support = true,
        settings = {
          textLSP = {
            analysers = {
              languagetool = {
                enabled = true,
                check_text = {
                  on_change = true,
                  on_open = false,
                  on_save = false,
                },
              },
              ollama = {
                enabled = false,
                check_text = {
                  on_open = false,
                  on_save = false,
                  on_change = false,
                },
                model = "phi3:3.8b-instruct", -- smaller but faster model
                -- model = "phi3:14b-instruct",  -- more accurate
                max_token = 50,
              },
            },
            documents = {
              language = "auto:en",
              min_length_language_detect = 20,
              org = {
                org_todo_keywords = { "TODO", "IN_PROGRESS", "DONE" },
              },
              txt = {
                parse = true,
              },
            },
          },
        },
      }),
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        log_level = 2,
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath("config") then
              return
            end
          end
          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                -- Depending on the usage, you might want to add additional paths here.
                "${3rd}/luv/library",
                -- "${3rd}/busted/library",
              },
              -- or pull in all of 'runtimepath'.  NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
              -- library = vim.api.nvim_get_runtime_file("", true)
            },
          })
        end,
        settings = {
          Lua = {},
        },
      }),
      lspconfig.harper_ls.setup({
        capabilities = capabilities,
        enabled = true,
        filetypes = { "markdown", "org" },
        settings = {
          ["harper-ls"] = {
            -- userDictPath = "$XDG_CONFIG_HOME/user/dict/path/dict.txt",
            fileDictPath = "~/.config/harper-ls/harper-core/dictionary.dict",
            linters = {
              SpellCheck = true,
              SpelledNumbers = true,
              AnA = false,
              SentenceCapitalization = false,
              UnclosedQuotes = true,
              WrongQuotes = false,
              LongSentences = false,
              RepeatedWords = true,
              Spaces = true,
              Matcher = true,
              CorrectNumberSuffix = true,
            },
            codeActions = {
              ForceStable = false,
            },
            markdown = {
              IgnoreLinkTitle = true,
            },
            diagnosticSeverity = "hint",
            isolateEnglish = false,
          },
        },
      }),
      lspconfig.bashls.setup({
        capabilities = capabilities,
        cmd = { "bash-language-server", "start" },
        settings = {
          bashIde = {
            globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
          },
        },
        filetypes = { "bash", "sh" },
        root_dir = function(fname)
          return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
        end,
        single_file_support = true,
      }),
      lspconfig.cssls.setup({
        capabilities = capabilities,
        cmd = { "vscode-css-language-server", "--stdio" },
        filetypes = { "css", "scss", "less" },
        init_options = { provideFormatter = true }, -- needed to enable formatting capabilities
        root_dir = util.root_pattern("package.json", ".git"),
        single_file_support = true,
        settings = {
          css = { validate = true },
          scss = { validate = true },
          less = { validate = true },
        },
      }),
      lspconfig.css_variables.setup({
        capabilities = capabilities,
        cmd = { "css-variables-language-server", "--stdio" },
        filetypes = { "css", "scss", "less" },
        root_dir = util.root_pattern("package.json", ".git"),
        -- Same as inlined defaults that don't seem to work without hardcoding them in the lua config
        -- https://github.com/vunguyentuan/vscode-css-variables/blob/763a564df763f17aceb5f3d6070e0b444a2f47ff/packages/css-variables-language-server/src/CSSVariableManager.ts#L31-L50
        settings = {
          cssVariables = {
            lookupFiles = { "**/*.less", "**/*.scss", "**/*.sass", "**/*.css" },
            blacklistFolders = {
              "**/.cache",
              "**/.DS_Store",
              "**/.git",
              "**/.hg",
              "**/.next",
              "**/.svn",
              "**/bower_components",
              "**/CVS",
              "**/dist",
              "**/node_modules",
              "**/tests",
              "**/tmp",
            },
          },
        },
      }),
      require("lspconfig").wasm_language_tools.setup({
        capabilities = capabilities,
        cmd = { "wat_server" },
        filetypes = { "wat" },
        single_file_support = true,
        -- `settings` section is optional
        settings = { format = {}, lint = {} },
      }),
    },
  },
}
