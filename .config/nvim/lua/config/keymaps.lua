-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local Snacks = require("snacks")
local Luasnip = require("luasnip")

-- name a file without writing it out
map("n", "<leader>F", ":file ", { desc = "File Name (Full Path)" })

-- luasnip
map({ "i", "s" }, "<Tab>", function()
  Luasnip.jump(1)
end, { silent = true })
map({ "i", "s" }, "<S-Tab>", function()
  Luasnip.jump(-1)
end, { silent = true })

-- mini.pick
map({ "n", "v" }, "<leader>Pb", ":Pick buffers<CR>", { desc = "Pick: Buffers" })
map({ "n", "v" }, "<leader>PB", ":Pick buf_lines<CR>", { desc = "Pick: Buffer Lines" })
map({ "n", "v" }, "<leader>Pc", ":Pick commands<CR>", { desc = "Pick: Commands" })
map({ "n", "v" }, "<leader>PC", ":Pick cli<CR>", { desc = "Pick: CLI" })
map({ "n", "v" }, "<leader>Pd", ":Pick diagnostic<CR>", { desc = "Pick: Diagnostics" })
map({ "n", "v" }, "<leader>Pe", ":Pick explorer<CR>", { desc = "Pick: Explorer" })
map({ "n", "v" }, "<leader>Pf", ":Pick files<CR>", { desc = "Pick: Files" })
map({ "n", "v" }, "<leader>Pk", ":Pick keymaps<CR>", { desc = "Pick: Keymaps" })
map({ "n", "v" }, "<leader>Pl", ":Pick list", { desc = "Pick: List (scope)" })
map({ "n", "v" }, "<leader>Pm", ":Pick manpages<CR>", { desc = "Pick: Manpages" })
map({ "n", "v" }, "<leader>Po", ":Pick options<CR>", { desc = "Pick: Options" })
map({ "n", "v" }, "<leader>Pr", ":Pick registers<CR>", { desc = "Pick: Registers" })
map({ "n", "v" }, "<leader>Pt", ":Pick treesitter<CR>", { desc = "Pick: Treesitter" })
map({ "n", "v" }, "<leader>Pgb", ":Pick git_branches<CR>", { desc = "Pick: Git Branches" })
map({ "n", "v" }, "<leader>Pgc", ":Pick git_commits<CR>", { desc = "Pick: Git Commits" })
map({ "n", "v" }, "<leader>Pgf", ":Pick git_files<CR>", { desc = "Pick: Git Files" })
map({ "n", "v" }, "<leader>Pgh", ":Pick git_hunks<CR>", { desc = "Pick: Git Hunks" })
map({ "n", "v" }, "<leader>PGg", ":Pick grep<CR>", { desc = "Pick: Grep" })
map({ "n", "v" }, "<leader>PGl", ":Pick grep_live<CR>", { desc = "Pick: Grep Live" })
map({ "n", "v" }, "<leader>Phh", ":Pick help<CR>", { desc = "Pick: Help" })
map({ "n", "v" }, "<leader>Php", ":Pick hipatterns<CR>", { desc = "Pick: HIpatterns" })
map({ "n", "v" }, "<leader>PhH", ":Pick history<CR>", { desc = "Pick: History" })
map({ "n", "v" }, "<leader>Phg", ":Pick hl_groups<CR>", { desc = "Pick: Hl Groups" })

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
end, { desc = "Find Image To Paste" })

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

-- change list (noice)
map("n", "<leader>snc", ":changes<CR>", { desc = "Noice Changes" })
