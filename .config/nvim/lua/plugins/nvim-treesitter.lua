return {
  "nvim-treesitter/nvim-treesitter",
  version = false, -- last release is way too old and doesn't work on Windows
  build = ":TSUpdate",
  event = { "LazyFile", "VeryLazy" },
  lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
  init = function(plugin)
    require("lazy.core.loader").add_to_rtp(plugin)
    require("nvim-treesitter.query_predicates")
  end,
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
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
  vim.filetype.add({
    pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
  }),
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
  additional_vim_regex_highlighting = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  config = function(_, opts)
    if type(opts.ensure_installed) == "table" then
      opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)
    end
    require("nvim-treesitter.configs").setup(opts)
  end,
}
