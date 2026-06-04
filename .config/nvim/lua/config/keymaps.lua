-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local Snacks = require("snacks")

map({ "n", "v" }, ";", ":", { desc = "Enter Command Mode", noremap = true, silent = true })

-- restart session/neovim
map("n", "<leader>qr", function()
  local session = vim.fn.stdpath("state") .. "/restart_session.vim"
  vim.cmd("mksession! " .. vim.fn.fnameescape(session))
  vim.cmd("restart source " .. vim.fn.fnameescape(session))
end, { desc = "Restart Session/Neovim" })

-- search clipboard history
map({ "n" }, "<leader>sv", ":lua Snacks.picker.cliphist()<CR>", { desc = "Clipboard History" })

-- name a file without writing it out
map("n", "<leader>F", ":file ", { desc = "File Name (Full Path)" })

-- line diagnostics
map("n", "<leader>uK", function()
  vim.diagnostic.config({ virtual_lines = { current_line = true }, virtual_text = false })
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = vim.api.nvim_create_augroup("line-diagnostics", { clear = true }),
    callback = function()
      vim.diagnostic.config({ virtual_lines = false, virtual_text = true })
      return true
    end,
  })
end, { desc = "Expand 'line-diagnostics'" })

-- image-clip snacks integration
map("n", "<leader>fi", function()
  Snacks.picker.files({
    ft = { "jpg", "jpeg", "png", "webp" },
    confirm = function(self, item, _)
      self:close()
      require("img-clip").paste_image({}, "./" .. item.file)
    end,
  })
end, { desc = "Find Image To Paste" })

-- snacks picker for snippets
map("n", "<leader>fs", function()
  Snacks.picker.snippets()
end, { desc = "Find Snippet" })

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
end, { desc = "Open File Containing Mark" })

-- quickfix list
map("n", "<leader>xd", function()
  local diagnostics = vim.diagnostic.get(0)
  local qflist = {}
  for _, diagnostic in ipairs(diagnostics) do
    table.insert(qflist, {
      bufnr = diagnostic.bufnr,
      lnum = diagnostic.lnum + 1,
      col = diagnostic.col + 1,
      text = diagnostic.message,
      type = diagnostic.severity == vim.diagnostic.severity.ERROR and "E" or "W",
    })
  end
  vim.fn.setqflist(qflist)
end, { desc = "Send Diagnostics To QF List" })

-- location list
map("v", "<leader>xl", function()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local lines = vim.fn.getline(start_line, end_line)
  if type(lines) == "string" then
    lines = { lines }
  end
  local loclist = {}
  for i, line in ipairs(lines) do
    table.insert(loclist, {
      filename = vim.fn.bufname("%"),
      lnum = start_line + i - 1,
      text = line,
    })
  end
  vim.fn.setloclist(0, loclist)
  vim.cmd("lopen")
end, { desc = "Send Lines To Location List" })

-- delete all comments in the current buffer
map("n", "<leader>cD", function()
  vim.cmd(("g/^%s/d"):format(vim.fn.escape(vim.fn.substitute(vim.o.commentstring, "%s", "", "g"), "/.*[]~")))
end, { desc = "Delete Comments in Current Buffer" })

-- alias "find & replace all" to leader + r
map("n", "<leader>r", ":%s///gI<Left><Left><Left><Left>", { desc = "Find & Replace All" })
