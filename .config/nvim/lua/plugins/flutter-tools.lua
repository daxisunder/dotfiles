local capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
local on_attach = ...

return {
  "nvim-flutter/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("flutter-tools").setup({
      decorations = {
        statusline = {
          app_version = true,
          device = true,
        },
      },
      debugger = {
        enabled = true,
      },
      widget_guides = {
        enabled = true,
      },
      dev_log = {
        enabled = true,
        open_cmd = "15split",
        notify_errors = true,
      },
      dev_tools = {
        autostart = false,
        auto_open_browser = false,
      },
      outline = {
        open_cmd = "30vnew",
        auto_open = false,
      },
      lsp = {
        color = {
          enabled = true,
          background = false,
          foreground = false,
          virtual_text = true,
          virtual_text_str = "■",
        },
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          analysisExcludedFolders = {
            "build",
            ".dart_tool",
          },
        },
      },
    })
  end,
}
