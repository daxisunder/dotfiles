-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.startofline = true
opt.cursorcolumn = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.list = true
opt.listchars = {
  tab = "󱗽·",
  trail = "·",
  extends = "󰇘",
  precedes = "󰇘",
  conceal = "󰇙",
  nbsp = "󱥸",
}
