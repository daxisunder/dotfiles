-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local autocmd = vim.api.nvim_create_autocmd
local Snacks = require("snacks")
local progress = vim.defaulttable()

-- Hyprlang LSP
autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.hl", "hypr*.conf" },
  callback = function(event)
    print(string.format("starting hyprls for %s", vim.inspect(event)))
    vim.lsp.start({
      name = "hyprlang",
      cmd = { "hyprls" },
      root_dir = vim.fn.getcwd(),
    })
  end,
})

-- Snacks rename (for mini.files)
autocmd("User", {
  pattern = "MiniFilesActionRename",
  callback = function(event)
    Snacks.rename.on_rename_file(event.data.from, event.data.to)
  end,
})

-- Configure mini.files (window border)
autocmd("User", {
  pattern = "MiniFilesWindowOpen",
  callback = function(args)
    local win_id = args.data.win_id
    -- Customize window-local settings
    vim.wo[win_id].winblend = 20
    local config = vim.api.nvim_win_get_config(win_id)
    config.border = "rounded"
    vim.api.nvim_win_set_config(win_id, config)
  end,
})

-- Configure mini.files (line numbers)
autocmd("User", {
  pattern = "MiniFilesWindowUpdate",
  callback = function(args)
    vim.wo[args.data.win_id].number = true
    vim.wo[args.data.win_id].relativenumber = true
  end,
})

-- Disable auto-commenting new lines
autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Disable New Line Comment",
})

-- Center scren on InsertEnter
autocmd("InsertEnter", {
  callback = function()
    vim.cmd("normal! zz")
  end,
  desc = "Center screen on InsertEnter",
})

-- Set LSP to recognize org files
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.org",
  callback = function()
    vim.bo.filetype = "org"
  end,
})

-- Set LSP to recognize tex files
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.tex",
  callback = function()
    vim.bo.filetype = "latex"
  end,
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save_cursor = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, save_cursor)
  end,
  desc = "Remove trailing whitespace on save",
})

-- LSP progress
autocmd("LspProgress", {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ("[%3d%%] %s%s"):format(
            value.kind == "end" and 100 or value.percentage or 100,
            value.title or "",
            value.message and (" **%s**"):format(value.message) or ""
          ),
          done = value.kind == "end",
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(table.concat(msg, "\n"), "info", {
      id = "lsp_progress",
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and " "
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})
