-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local g = vim.g
local opt = vim.opt

g.loaded_perl_provider = 0
opt.cursorcolumn = true
opt.list = true
opt.listchars = {
  conceal = "󰇙",
  extends = "󰇘",
  nbsp = "󱥸",
  precedes = "󰇘",
  tab = "󱗽·",
  trail = "·",
}
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.startofline = true
