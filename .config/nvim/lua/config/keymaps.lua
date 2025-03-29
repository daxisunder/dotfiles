-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- undotree
map("n", "<localleader>u", "<cmd>lua require('undotree').toggle()<cr>", { desc = "Toggle 'Undotree'" })

-- inc-rename
map("n", "<localleader>R", ":IncRename", { desc = "Toggle 'IncRename'" })

-- yankbank
map("n", "<localleader>y", "<cmd>YankBank<CR>", { desc = "Toggle 'Yankbank'" })
