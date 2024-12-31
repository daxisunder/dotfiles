return {
  "saghen/blink.cmp",
  config = function()
    require("blink.cmp").setup({
      sources = {
        completion = {
          enabled_providers = { "lsp", "path", "snippets", "buffer", "orgmode" },
          -- Or if you want to use only this provider in org files
          -- enabled_providers = function()
          --   if vim.bo.filetype == 'org' then
          --     return { 'orgmode' }
          --   end
          --   return { 'lsp', 'path', 'snippets', 'buffer' }
          -- end
        },
        providers = {
          orgmode = {
            name = "Orgmode",
            module = "orgmode.org.autocompletion.blink",
          },
        },
      },
    })
  end,
}
