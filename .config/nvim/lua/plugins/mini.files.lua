return {
  "nvim-mini/mini.files",
  version = false,
  event = "VeryLazy",
  config = function()
    require("mini.files").setup({
      options = {
        permanent_delete = false,
        use_as_default_explorer = true,
      },
      mappings = {
        close = "q",
        go_in = "L",
        go_in_plus = "l",
        go_out = "H",
        go_out_plus = "h",
        mark_goto = "'",
        mark_set = "m",
        reset = "<BS>",
        reveal_cwd = "@",
        show_help = "g?",
        synchronize = "=",
        trim_left = "<",
        trim_right = ">",
      },
      windows = {
        max_number = 3,
        preview = true,
        width_focus = 30,
        width_nofocus = 30,
        width_preview = 60,
      },
    })
    -- the code below is responsible for adding git status to mini.files
    local nsMiniFiles = vim.api.nvim_create_namespace("mini_files_git")
    local autocmd = vim.api.nvim_create_autocmd
    local _, MiniFiles = pcall(require, "mini.files")
    local gitStatusCache = {}
    local cacheTimeout = 2000 -- Cache timeout in milliseconds

    local function isSymlink(path)
      local stat = vim.loop.fs_lstat(path)
      return stat and stat.type == "link"
    end

    ---@type table<string, {symbol: string, hlGroup: string}>
    ---@param status string
    ---@return string symbol, string hlGroup
    local function mapSymbols(status, is_symlink)
      local statusMap = {
    -- stylua: ignore start
        [" M"] = { symbol = "✹", hlGroup  = "MiniDiffSignChange"}, -- Modified in the working directory
        ["M "] = { symbol = "•", hlGroup  = "MiniDiffSignChange"}, -- modified in index
        ["MM"] = { symbol = "≠", hlGroup  = "MiniDiffSignChange"}, -- modified in both working tree and index
        ["A "] = { symbol = "+", hlGroup  = "MiniDiffSignAdd"   }, -- Added to the staging area, new file
        ["AA"] = { symbol = "≈", hlGroup  = "MiniDiffSignAdd"   }, -- file is added in both working tree and index
        ["D "] = { symbol = "-", hlGroup  = "MiniDiffSignDelete"}, -- Deleted from the staging area
        ["AM"] = { symbol = "⊕", hlGroup  = "MiniDiffSignChange"}, -- added in working tree, modified in index
        ["AD"] = { symbol = "-•", hlGroup = "MiniDiffSignChange"}, -- Added in the index and deleted in the working directory
        ["R "] = { symbol = "→", hlGroup  = "MiniDiffSignChange"}, -- Renamed in the index
        ["U "] = { symbol = "‖", hlGroup  = "MiniDiffSignChange"}, -- Unmerged path
        ["UU"] = { symbol = "⇄", hlGroup  = "MiniDiffSignAdd"   }, -- file is unmerged
        ["UA"] = { symbol = "⊕", hlGroup  = "MiniDiffSignAdd"   }, -- file is unmerged and added in working tree
        ["??"] = { symbol = "?", hlGroup  = "MiniDiffSignDelete"}, -- Untracked files
        ["!!"] = { symbol = "!", hlGroup  = "MiniDiffSignChange"}, -- Ignored files
        -- stylua: ignore end
      }

      local result = statusMap[status] or { symbol = "?", hlGroup = "NonText" }
      local gitSymbol = result.symbol
      local gitHlGroup = result.hlGroup
      local symlinkSymbol = is_symlink and "↩" or ""
      local combinedSymbol = (symlinkSymbol .. gitSymbol):gsub("^%s+", ""):gsub("%s+$", "")
      local combinedHlGroup = is_symlink and "MiniDiffSignDelete" or gitHlGroup
      return combinedSymbol, combinedHlGroup
    end

    ---@param cwd string
    ---@param callback function
    ---@return nil
    local function fetchGitStatus(cwd, callback)
      local function on_exit(content)
        if content.code == 0 then
          callback(content.stdout)
          vim.g.content = content.stdout
        end
      end
      vim.system({ "git", "status", "--ignored", "--porcelain" }, { text = true, cwd = cwd }, on_exit)
    end

    ---@param str string|nil
    ---@return string
    local function escapePattern(str)
      if not str then
        return ""
      end
      return (str:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1"))
    end

    ---@param buf_id integer
    ---@param gitStatusMap table
    ---@return nil
    local function updateMiniWithGit(buf_id, gitStatusMap)
      vim.schedule(function()
        local nlines = vim.api.nvim_buf_line_count(buf_id)
        local cwd = vim.fs.root(buf_id, ".git")
        local escapedcwd = escapePattern(cwd)
        if vim.fn.has("win32") == 1 then
          escapedcwd = escapedcwd:gsub("\\", "/")
        end

        for i = 1, nlines do
          local entry = MiniFiles.get_fs_entry(buf_id, i)
          if not entry then
            break
          end
          local relativePath = entry.path:gsub("^" .. escapedcwd .. "/", "")
          local status = gitStatusMap[relativePath]

          if status then
            local is_symlink = isSymlink(entry.path)
            local symbol, hlGroup = mapSymbols(status, is_symlink)
            vim.api.nvim_buf_set_extmark(buf_id, nsMiniFiles, i - 1, 0, {
              -- NOTE: if you want the signs on the right uncomment those and comment
              -- the 3 lines after
              virt_text = { { symbol, hlGroup } },
              virt_text_pos = "right_align",
              -- sign_text = symbol,
              -- sign_hl_group = hlGroup,
              -- priority = 2,
            })
            -- This below code is responsible for coloring the text of the items. comment it out if you don't want that
            local line = vim.api.nvim_buf_get_lines(buf_id, i - 1, i, false)[1]
            -- Find the name position accounting for potential icons
            local nameStartCol = line:find(vim.pesc(entry.name)) or 0

            if nameStartCol > 0 then
              vim.api.nvim_buf_add_highlight(
                buf_id,
                nsMiniFiles,
                hlGroup,
                i - 1,
                nameStartCol - 1,
                nameStartCol + #entry.name - 1
              )
            end
          else
          end
        end
      end)
    end

    ---@param content string
    ---@return table
    local function parseGitStatus(content)
      local gitStatusMap = {}
      for line in content:gmatch("[^\r\n]+") do
        local status, filePath = string.match(line, "^(..)%s+(.*)")
        local parts = {}
        for part in filePath:gmatch("[^/]+") do
          table.insert(parts, part)
        end
        local currentKey = ""
        for i, part in ipairs(parts) do
          if i > 1 then
            currentKey = currentKey .. "/" .. part
          else
            currentKey = part
          end
          if i == #parts then
            gitStatusMap[currentKey] = status
          else
            if not gitStatusMap[currentKey] then
              gitStatusMap[currentKey] = status
            end
          end
        end
      end
      return gitStatusMap
    end

    ---@param buf_id integer
    ---@return nil
    local function updateGitStatus(buf_id)
      local cwd = vim.fs.root(buf_id, ".git")
      if not cwd or not vim.fs.root(cwd, ".git") then
        return
      end

      local currentTime = os.time()
      if gitStatusCache[cwd] and currentTime - gitStatusCache[cwd].time < cacheTimeout then
        updateMiniWithGit(buf_id, gitStatusCache[cwd].statusMap)
      else
        fetchGitStatus(cwd, function(content)
          local gitStatusMap = parseGitStatus(content)
          gitStatusCache[cwd] = {
            time = currentTime,
            statusMap = gitStatusMap,
          }
          updateMiniWithGit(buf_id, gitStatusMap)
        end)
      end
    end

    ---@return nil
    local function clearCache()
      gitStatusCache = {}
    end

    local function augroup(name)
      return vim.api.nvim_create_augroup("MiniFiles_" .. name, { clear = true })
    end

    autocmd("User", {
      group = augroup("start"),
      pattern = "MiniFilesExplorerOpen",
      -- pattern = { "minifiles" },
      callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        updateGitStatus(bufnr)
      end,
    })

    autocmd("User", {
      group = augroup("close"),
      pattern = "MiniFilesExplorerClose",
      callback = function()
        clearCache()
      end,
    })

    autocmd("User", {
      group = augroup("update"),
      pattern = "MiniFilesBufferUpdate",
      callback = function(sii)
        local bufnr = sii.data.buf_id
        local cwd = vim.fn.expand("%:p:h")
        if gitStatusCache[cwd] then
          updateMiniWithGit(bufnr, gitStatusCache[cwd].statusMap)
        end
      end,
    })
  end,
}
