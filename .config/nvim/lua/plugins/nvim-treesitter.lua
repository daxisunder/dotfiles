return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  -- remove the commit pin when we update to Neeovim 0.12
  commit = vim.fn.has("nvim-0.12") == 0 and "7caec274fd19c12b55902a5b795100d21531391f" or nil,
  version = false,
  build = function()
    local TS = require("nvim-treesitter")
    if not TS.get_installed then
      LazyVim.error("Please restart Neovim and run `:TSUpdate` to use the `nvim-treesitter` **main** branch.")
      return
    end
    -- make sure we're using the latest treesitter util
    package.loaded["lazyvim.util.treesitter"] = nil
    LazyVim.treesitter.build(function()
      TS.update(nil, { summary = true })
    end)
  end,
  lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
  event = { "LazyFile", "VeryLazy" },
  cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
  opts_extend = { "ensure_installed" },
  opts = {
    -- LazyVim config for treesitter
    ensure_installed = {
      "bash",
      "c",
      "css",
      "dart",
      "diff",
      "graphql",
      "html",
      "http",
      "hyprlang",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "kitty",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
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
      "vimdoc",
      "xml",
      "yaml",
    },
  },
  config = function(_, opts)
    local TS = require("nvim-treesitter")
    -- some quick sanity checks
    if not TS.get_installed then
      return LazyVim.error("Please use `:Lazy` and update `nvim-treesitter`")
    elseif vim.fn.executable("tree-sitter") == 0 then
      return LazyVim.error({
        "**treesitter-main** requires the `tree-sitter` CLI executable to be installed.",
        "Run `:checkhealth nvim-treesitter` for more information.",
      })
    elseif type(opts.ensure_installed) ~= "table" then
      return LazyVim.error("`nvim-treesitter` opts.ensure_installed must be a table")
    end
    -- setup treesitter
    TS.setup(opts)
    LazyVim.treesitter.get_installed(true)
    -- install missing parsers
    local install = vim.tbl_filter(function(lang)
      return not LazyVim.treesitter.have(lang)
    end, opts.ensure_installed or {})
    if #install > 0 then
      TS.install(install, { summary = true }):await(function()
        LazyVim.treesitter.get_installed(true) -- refresh the installed langs
      end)
    end
    -- treesitter highlighting
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(ev)
        if LazyVim.treesitter.have(ev.match) then
          pcall(vim.treesitter.start)
        end
      end,
    })
    -- kitty syntax highlighting
    vim.api.nvim_create_autocmd("User", {
      pattern = "TSUpdate",
      callback = function()
        ---@diagnostic disable-next-line: missing-fields
        require("nvim-treesitter.parsers").kitty = {
          ---@diagnostic disable-next-line: missing-fields
          install_info = {
            url = "https://github.com/OXY2DEV/tree-sitter-kitty",
          },
        }
      end,
    })
  end,
}
