-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local g = vim.g
local o = vim.opt

g.deprecation_warnings = true
g.filetype_plugin_on = true
g.loaded_java_provider = 0
g.loaded_javac_provider = 0
g.loaded_julia_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.trouble_lualine = true
g.vimtex_view_general_viewer = "okular"
g.vimtex_view_general_options = "--unique file:@pdf#src:@line@tex"
o.cursorcolumn = true
o.list = true
o.listchars = {
  conceal = "󰇙",
  extends = "󰇘",
  nbsp = "󱥸",
  precedes = "󰇘",
  tab = "󱗽·",
  trail = "·",
}
o.scrolloff = 8
o.sidescrolloff = 8
o.startofline = true
