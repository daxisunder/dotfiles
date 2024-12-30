-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Floaterm
vim.api.nvim_set_keymap("n", "<F7>", ":FloatermNew<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<F8>", ":FloatermKill<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<F9>", ":FloatermToggle<CR>", { noremap = true })
