return {
  "chrisgrieser/nvim-scissors",
  lazy = "true",
  config = function()
    require("scissors").setup({
      snippetDir = vim.fn.stdpath("config") .. "/snippets",
      editSnippetPopup = {
        height = 0.4, -- relative to the window, between 0-1
        width = 0.6,
        border = "rounded", -- `vim.o.winborder` on nvim 0.11, otherwise "rounded"
        keymaps = {
          -- if not mentioned otherwise, the keymaps apply to normal mode
          cancel = "q",
          saveChanges = "<CR>", -- alternatively, can also use `:w`
          goBackToSearch = "<BS>",
          deleteSnippet = "<C-BS>",
          duplicateSnippet = "<C-d>",
          openInFile = "<C-o>",
          insertNextPlaceholder = "<C-p>", -- insert & normal mode
          showHelp = "?",
        },
      },
      snippetSelection = {
        picker = "auto",
      },
      ---@type "yq"|"jq"|"none"|string[]
      jsonFormatter = "jq",
      backdrop = {
        enabled = true,
        blend = 50, -- between 0-100
      },
      icons = {
        scissors = "󰩫",
      },
    })
  end,
}
