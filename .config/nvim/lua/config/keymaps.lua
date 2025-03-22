-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Use the localleader key to toggle the undotree
map("n", "<localleader>u", "<cmd>lua require('undotree').toggle()<cr>", { desc = "Toggle 'undotree'" })
