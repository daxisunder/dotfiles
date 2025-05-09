-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local harpoon = require("harpoon")

-- mini.pick
map("n", "<leader>fP", ":Pick", { desc = "Open mini.pick" })

-- line diagnostics
map("n", "<localleader>k", function()
  vim.diagnostic.config({ virtual_lines = { current_line = true }, virtual_text = false })

  vim.api.nvim_create_autocmd("CursorMoved", {
    group = vim.api.nvim_create_augroup("line-diagnostics", { clear = true }),
    callback = function()
      vim.diagnostic.config({ virtual_lines = false, virtual_text = true })
      return true
    end,
  })
end, { desc = "Toggle 'line-diagnostics'" })

-- image-clip snacks integration
map("n", "<leader>fi", function()
  Snacks.picker.files({
    ft = { "jpg", "jpeg", "png", "webp" },
    confirm = function(self, item, _)
      self:close()
      require("img-clip").paste_image({}, "./" .. item.file)
    end,
  })
end, { desc = "Find image to paste" })

-- lazygit
if vim.fn.executable("lazygit") == 1 then
  map("n", "<leader>gg", function()
    Snacks.lazygit({ cwd = LazyVim.root.git() })
  end, { desc = "Lazygit (Root Dir)" })
  map("n", "<leader>gG", function()
    Snacks.lazygit()
  end, { desc = "Lazygit (cwd)" })
  map("n", "<leader>gf", function()
    Snacks.picker.git_log_file()
  end, { desc = "Git Current File History" })
  map("n", "<leader>gl", function()
    Snacks.picker.git_log({ cwd = LazyVim.root.git() })
  end, { desc = "Git Log" })
  map("n", "<leader>gL", function()
    Snacks.picker.git_log()
  end, { desc = "Git Log (cwd)" })
end

map("n", "<leader>gb", function()
  Snacks.picker.git_log_line()
end, { desc = "Git Blame Line" })
map({ "n", "x" }, "<leader>gB", function()
  Snacks.gitbrowse()
end, { desc = "Git Browse (open)" })
map({ "n", "x" }, "<leader>gY", function()
  Snacks.gitbrowse({
    open = function(url)
      vim.fn.setreg("+", url)
    end,
    notify = false,
  })
end, { desc = "Git Browse (copy)" })

-- smart-translate
map({ "n", "v" }, "<leader>t", ":Translate<CR>", { desc = "Translate Text Under Cursor" })

-- "<leader>'{char}" opens file containing mark upper{char}
map("n", "<leader>'", function()
  local char = vim.fn.getcharstr(-1)
  if char == "\27" then
    return -- got <esc>
  end
  local m = vim.api.nvim_get_mark(char:upper(), {})
  if m[4] ~= "" then
    vim.cmd.edit(m[4])
  end
end, { desc = "Open file containing mark" })
