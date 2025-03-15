-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Use the localleader key to toggle the undotree
vim.keymap.set("n", "<localleader>u", "<cmd>lua require('undotree').toggle()<cr>", { desc = "Toggle 'Undotree'" })
