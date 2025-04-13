return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      "bash",
      "css",
      "diff",
      "html",
      "hyprlang",
      "javascript",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "php",
      "printf",
      "python",
      "query",
      "rasi",
      "regex",
      "ruby",
      "rust",
      "scss",
      "toml",
      "tsx",
      "typescript",
      "typst",
      "vim",
      "yaml",
    })
  end,
  sync_install = false,
  auto_install = false,
  vim.filetype.add({
    pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
  }),
  highlight = {
    enable = true,
  },
  additional_vim_regex_highlighting = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}
