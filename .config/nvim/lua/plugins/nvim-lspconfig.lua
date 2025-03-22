return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ruby_lsp = {
        mason = false,
        cmd = { vim.fn.expand("~/.asdf/shims/ruby-lsp") },
      },
      rubocop = {
        mason = false,
        cmd = { vim.fn.expand("~/.asdf/shims/rubocop") },
      },
      require("lspconfig").harper_ls.setup({
        enabled = true,
        filetypes = { "markdown", "org" },
        settings = {
          ["harper_ls"] = {
            -- userDictPath = "$XDG_CONFIG_HOME/harper-ls/harper-core/dictionary.dict",
            fileDictPath = "~/.config/harper-ls/harper-core/dictionary.dict",
            linters = {
              SpellCheck = true,
              SpelledNumbers = false,
              AnA = true,
              SentenceCapitalization = true,
              UnclosedQuotes = true,
              WrongQuotes = false,
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
    },
  },
}
