return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
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
      "vim",
      "yaml",
    },
  },
  vim.filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})
}