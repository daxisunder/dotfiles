return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- add any options here
    notify = {
      enabled = true,
    },
    lsp = {
      hover = {
        enabled = true,
      },
      signature = {
        auto_open = {
          enabled = true,
        },
      },
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = false, -- requires hrsh7th/nvim-cmp
      },
    },
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = true, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = "rounded",
    },
  },
}
