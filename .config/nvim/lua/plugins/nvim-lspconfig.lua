local util = require("lspconfig.util")
local lspconfig = require("lspconfig")

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      lspconfig.asm_lsp.setup({
        cmd = { "asm-lsp" },
        filetypes = { "asm", "vmasm" },
        single_file_support = true,
        root_dir = function(fname)
          return vim.fs.dirname(vim.fs.find({ ".asm-lsp.toml", ".git" }, { path = fname, upward = true })[1])
        end,
      }),
      lspconfig.jsonls.setup({
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
        cmd = { "ruby-lsp" },
        filetypes = { "ruby", "eruby" },
        root_dir = util.root_pattern("Gemfile", ".git"),
        init_options = {
          formatter = "auto",
        },
        single_file_support = true,
      }),
      lspconfig.rubocop.setup({
        cmd = { "rubocop", "--lsp" },
        filetypes = { "ruby" },
        root_dir = util.root_pattern("Gemfile", ".git"),
      }),
      lspconfig.phpactor.setup({
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
        cmd = { "hyprls", "--stdio" },
        filetypes = { "hyprlang" },
        root_dir = function(fname)
          return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
        end,
        single_file_support = true,
      }),
      lspconfig.ltex.setup({
        filetypes = { "latex", "tex", "bib" },
      }),
      lspconfig.textlsp.setup({
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
                check_text = {
                  on_change = false,
                  on_open = true,
                  on_save = true,
                },
                enabled = true,
              },
            },
            documents = {
              org = {
                org_todo_keywords = { "TODO", "IN_PROGRESS", "DONE" },
              },
            },
          },
        },
      }),
      lspconfig.lua_ls.setup({
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
              path ~= vim.fn.stdpath("config")
              and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
            then
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
                -- "${3rd}/luv/library"
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
        enabled = true,
        filetypes = { "markdown", "org" },
        settings = {
          ["harper_ls"] = {
            -- userDictPath = "$XDG_CONFIG_HOME/harper-ls/harper-core/dictionary.dict",
            fileDictPath = "~/.config/harper-ls/harper-core/dictionary.dict",
            linters = {
              SpellCheck = true,
              SpelledNumbers = true,
              AnA = true,
              SentenceCapitalization = true,
              UnclosedQuotes = true,
              WrongQuotes = true,
              LongSentences = true,
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
    },
  },
}
