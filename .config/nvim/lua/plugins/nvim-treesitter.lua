return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      "bash",
      "css",
      "html",
      "hyprlang",
      "javascript",
      "json",
      "jsonc",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "rasi",
      "regex",
      "scss",
      "toml",
      "tsx",
      "typescript",
      "typst",
      "vim",
      "yaml",
    })
  end,
  vim.filetype.add({
    pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
  }),
}
