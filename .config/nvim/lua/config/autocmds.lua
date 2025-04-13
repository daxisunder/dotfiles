-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local autocmd = vim.api.nvim_create_autocmd

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

-- Disable auto-commenting new lines
autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Disable New Line Comment",
})

-- Set ltex LSP to attach to org files
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*org",
  callback = function()
    vim.bo.filetype = "org"
  end,
})

-- cmdline messages
autocmd({ "CmdlineEnter" }, {
  callback = function()
    vim.opt.messagesopt = "hit-enter,history:1000"
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorMoved" }, {
      callback = function()
        vim.opt.messagesopt = "wait:500,history:1000"
      end,
      once = true,
    })
  end,
  desc = "Only show Cmdline message when triggered",
})
