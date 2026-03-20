local Snacks = require("snacks")
local LazyVim = require("lazyvim.util")

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    dashboard = {
      width = 90,
      row = nil, -- dashboard position. nil for center
      col = nil, -- dashboard position. nil for center
      pane_gap = 4, -- empty columns between vertical panes
      autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
      -- These settings are used by some built-in sections
      preset = {
        -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
        ---@type fun(cmd:string, opts:table)|nil
        pick = nil,
        keys = {
          { icon = "󰻭", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = "󱀲", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = "󱀵", key = "p", desc = "Project Files", action = ":lua Snacks.dashboard.pick('projects')" },
          {
            icon = "",
            key = "c",
            desc = "Config Files",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = "󰱽", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = "󱩾", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = "󰒳", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = "󰛉", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          { icon = "", key = "m", desc = "Mason", action = ":Mason" },
          { icon = "󰬳", key = "s", desc = "Restore Session", section = "session" },
          { icon = "", key = "q", desc = "Quit", action = ":qa" },
        },
        -- Used by the `header` section
        header = [[
	⠀⠀⠀⠀⠀⠀ ⠀⠀⠀⠀⠀⠀⣀⣤⣴⣶⣾⣿⣿⣿⣶⣶⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣶⣶⣿⣿⣿⣿⣶⣶⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣶⣶⣿⣿⣿⣷⣶⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
	⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
	⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
	⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀
	⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀
	⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⢿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⡿⠿⠛⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⠛⠿⢿⣿⣿⣿⡇⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀
	⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣻⣿⣿⣿⡟⠁⠀⠀⠀⠈⢻⣿⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⣿⠏⣠⣤⡄⣠⣤⡌⢿⣿⣿⣿⣿⡿⢁⣤⣄⢀⣤⣄⠹⣿⣿⡇⠀⠀⠀⠀⠀⢺⣿⣿⡿⠋⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠛⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀
	⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⠛⠛⠛⠛⠛⠛⢛⣿⣮⣿⣿⣿⠀⠀⠀⠀⠀⠀⢈⣿⣿⡟⠀⠀⠀⠀⠀⠀⠸⣿⣿⠀⢿⣿⣿⣿⣿⡟⢸⣿⣿⣿⣿⡇⠸⣿⣿⣿⣿⡿⠀⣿⣿⠇⠀⠀⠀⠀⠀⢸⣿⣿⡇⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⠋⠁⠠⢴⣾⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀
	⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣧⡀⠀⠀⠀⢀⣼⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⢀⣼⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⢻⣿⣆⠀⠙⠿⠟⠋⢀⣾⣿⣿⣿⣿⣷⡀⠈⠻⡿⠋⠁⣰⣿⡟⠀⠀⠀⠀⠀⠀⠀⢿⣿⣷⣄⠀⠀⠀⢀⣰⣿⣿⣿⣿⣿⣿⣷⣶⣦⣤⣄⣼⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀
	⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣶⣿⣿⣿⣿⠟⠉⠻⣿⣿⣿⣿⣶⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣶⣶⣶⣾⣿⣿⡿⠋⠙⢿⣿⣿⣷⣶⣶⣶⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣷⣾⣿⣿⣿⡟⢻⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀
	⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⡇⣠⣷⡀⢹⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⢁⣴⣧⡀⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⢀⣼⣆⢘⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀
	⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀
	⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
	⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠋⠛⠋⠛⠙⠛⠙⠛⠙⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠛⠙⠛⠙⠛⠛⠋⠛⠋⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠛⠙⠛⠛⠋⠛⠋⠛⠋⠛⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      },
      -- item field formatters
      formats = {
        icon = function(item)
          if item.file and item.icon == "file" or item.icon == "directory" then
            return { item.icon, hl = item.icon } -- use the icon as the highlight group
          end
          return { item.icon, width = 2, hl = "icon" }
        end,
        footer = { "%s", align = "center" },
        header = { "%s", align = "center" },
        file = function(item, ctx)
          local fname = vim.fn.fnamemodify(item.file, ":~")
          fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
          if #fname > ctx.width then
            local dir = vim.fn.fnamemodify(fname, ":h")
            local file = vim.fn.fnamemodify(fname, ":t")
            if dir and file then
              file = file:sub(-(ctx.width - #dir - 2))
              fname = dir .. "/…" .. file
            end
          end
          local dir, file = fname:match("^(.*)/(.+)$")
          return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
        end,
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
    },
    animate = {
      enabled = true,
      duration = 20, -- ms per step
      easing = "linear",
      fps = 60, -- frames per second. Global setting for all animations
    },
    bigfile = {
      enabled = true,
    },
    dim = {
      enabled = true,
    },
    explorer = {
      enabled = true,
    },
    gh = {
      enabled = true,
    },
    gitbrowse = {
      enabled = true,
    },
    image = {
      enabled = true,
      force = true, -- try displaying the image, even if the terminal does not support it
      doc = {
        inline = false,
        float = true,
      },
    },
    indent = {
      indent = {
        enabled = false,
      },
      scope = {
        enabled = false,
        hl = "SnacksIndentScope",
      },
      chunk = {
        enabled = false,
        hl = "SnacksIndentScope",
        char = {
          horizontal = "─",
          vertical = "│",
          corner_top = "╭",
          corner_bottom = "╰",
          arrow = "",
        },
      },
    },
    input = {
      enabled = true,
    },
    lazygit = {
      enabled = true,
    },
    notifier = {
      enabled = true,
      timeout = 6000,
      style = "minimal", -- compact, fancy, minimal
    },
    picker = {
      ui_select = true, -- replace `vim.ui.select` with the snacks picker
      sources = {
        autocmds = {
          layout = {
            preset = "ivy",
          },
        },
        commands = {
          layout = {
            preset = "vscode",
          },
        },
        command_history = {
          layout = {
            preset = "vscode",
          },
        },
        diagnostics = {
          layout = {
            preset = "ivy",
          },
        },
        diagnostics_buffer = {
          layout = {
            preset = "ivy",
          },
        },
        explorer = {
          hidden = true,
          ignored = true,
          actions = {
            explorer_del = function(picker)
              local _, res = pcall(function()
                return vim.fn.confirm("Do you want to put files into trash?", "&Yes\n&No\n&Cancel", 1, "Question")
              end)
              if res ~= 1 then
                return
              end
              for _, item in ipairs(picker:selected({ fallback = true })) do
                vim.fn.jobstart("trash " .. item.file, {
                  detach = true,
                  on_exit = function()
                    picker:update()
                  end,
                })
              end
            end,
          },
        },
        gh_issue = {
          layout = {
            preset = "ivy",
          },
        },
        gh_pr = {
          layout = {
            preset = "ivy",
          },
        },
        git_diff = {
          layout = {
            preset = "ivy",
          },
        },
        git_log = {
          layout = {
            preset = "ivy",
          },
        },
        git_log_file = {
          layout = {
            preset = "ivy",
          },
        },
        git_log_line = {
          layout = {
            preset = "ivy",
          },
        },
        git_stash = {
          layout = {
            preset = "ivy",
          },
        },
        git_status = {
          layout = {
            preset = "ivy",
          },
        },
        help = {
          layout = {
            preset = "ivy",
          },
        },
        highlights = {
          layout = {
            preset = "ivy",
          },
        },
        jumps = {
          layout = {
            preset = "ivy",
          },
        },
        keymaps = {
          layout = {
            preset = "ivy",
          },
        },
        loclist = {
          layout = {
            preset = "ivy",
          },
        },
        lsp_symbols = {
          layout = {
            preset = "ivy",
          },
        },
        lsp_workspace_symbols = {
          layout = {
            preset = "ivy",
          },
        },
        man = {
          layout = {
            preset = "ivy",
          },
        },
        marks = {
          layout = {
            preset = "ivy",
          },
        },
        noice = {
          layout = {
            preset = "ivy",
          },
        },
        notifications = {
          layout = {
            preset = "vscode",
          },
        },
        projects = {
          layout = {
            preset = "vscode",
          },
        },
        qflist = {
          layout = {
            preset = "ivy",
          },
        },
        registers = {
          layout = {
            preset = "vscode",
          },
        },
        rename = {
          layout = {
            preset = "ivy",
          },
        },
        search_history = {
          layout = {
            preset = "vscode",
          },
        },
        snippets = {
          layout = {
            preset = "ivy",
          },
          supports_live = false,
          preview = "preview",
          format = function(item, picker)
            local name = Snacks.picker.util.align(item.name, picker.align_1 + 5)
            return {
              { name, item.ft == "" and "Conceal" or "DiagnosticWarn" },
              { item.description },
            }
          end,
          finder = function(_, ctx)
            local snippets = {}
            for _, snip in ipairs(require("luasnip").get_snippets().all) do
              snip.ft = ""
              table.insert(snippets, snip)
            end
            for _, snip in ipairs(require("luasnip").get_snippets(vim.bo.ft)) do
              snip.ft = vim.bo.ft
              table.insert(snippets, snip)
            end
            local align_1 = 0
            for _, snip in pairs(snippets) do
              align_1 = math.max(align_1, #snip.name)
            end
            ctx.picker.align_1 = align_1
            local items = {}
            for _, snip in pairs(snippets) do
              local docstring = snip:get_docstring()
              if type(docstring) == "table" then
                docstring = table.concat(docstring)
              end
              local name = snip.name
              local description = table.concat(snip.description)
              description = name == description and "" or description
              table.insert(items, {
                text = name .. " " .. description, -- search string
                name = name,
                description = description,
                trigger = snip.trigger,
                ft = snip.ft,
                preview = {
                  ft = snip.ft,
                  text = docstring,
                },
              })
            end
            return items
          end,
          confirm = function(picker, item)
            picker:close()
            local expand = {}
            require("luasnip").available(function(snippet)
              if snippet.trigger == item.trigger then
                table.insert(expand, snippet)
              end
              return snippet
            end)
            if #expand > 0 then
              vim.cmd(":startinsert!")
              vim.defer_fn(function()
                require("luasnip").snip_expand(expand[1])
              end, 50)
            else
              Snacks.notify.warn("No snippet to expand")
            end
          end,
        },
        todo_comments = {
          layout = {
            preset = "ivy",
          },
        },
        undo = {
          layout = {
            preset = "ivy",
          },
        },
      },
      layouts = {
        vscode = {
          layout = {
            border = "rounded",
          },
        },
        ivy = {
          layout = {
            border = "rounded",
          },
        },
      },
    },
    project = {
      enabled = true,
    },
    profiler = {
      enabled = true,
    },
    quickfile = {
      enabled = true,
    },
    scope = {
      enabled = true,
      keys = {
        textobject = {
          ii = {
            min_size = 2, -- minimum size of the scope
            edge = false, -- inner scope
            cursor = false,
            treesitter = { blocks = { enabled = false } },
            desc = "inner scope",
          },
          ai = {
            cursor = false,
            min_size = 2, -- minimum size of the scope
            treesitter = { blocks = { enabled = false } },
            desc = "full scope",
          },
        },
        jump = {
          ["[i"] = {
            min_size = 1, -- allow single line scopes
            bottom = false,
            cursor = false,
            edge = true,
            treesitter = { blocks = { enabled = false } },
            desc = "Jump to top edge of scope",
          },
          ["]i"] = {
            min_size = 1, -- allow single line scopes
            bottom = true,
            cursor = false,
            edge = true,
            treesitter = { blocks = { enabled = false } },
            desc = "Jump to bottom edge of scope",
          },
        },
      },
    },
    scratch = {
      enabled = true,
    },
    scroll = {
      enabled = true,
    },
    statuscolumn = {
      enabled = true,
      left = { "mark", "sign" }, -- priority of signs on the left (high to low)
      right = { "fold", "git" }, -- priority of signs on the right (high to low)
      folds = {
        open = true, -- show open fold icons
        git_hl = false, -- use Git Signs hl for fold icons
      },
      git = {
        -- patterns to match Git signs
        patterns = { "GitSign", "MiniDiffSign" },
      },
      refresh = 50, -- refresh at most every 50ms
    },
    styles = {
      blame_line = {},
      input = {
        relative = "editor",
        col = 1,
        row = -1,
        b = {
          completion = true,
        },
      },
      notification = {
        border = "rounded",
        zindex = 100,
        ft = "markdown",
        wo = {
          winblend = 5,
          wrap = true,
          conceallevel = 2,
          colorcolumn = "",
        },
        bo = { filetype = "snacks_notif" },
      },
      snacks_image = {
        relative = "editor",
        border = true,
        focusable = false,
        backdrop = false,
        row = 1,
        col = -1,
        -- width/height are automatically set by the image size unless specified below
        width = 80,
      },
      zen = {
        enter = true,
        fixbuf = false,
        minimal = false,
        width = 120,
        height = 0,
        backdrop = { transparent = false, blend = 40 },
        keys = { q = false },
        zindex = 40,
        wo = {
          winhighlight = "NormalFloat:Normal",
        },
        w = {
          snacks_main = true,
        },
      },
    },
    terminal = {
      win = {
        relative = "editor",
        position = "bottom",
        style = "terminal",
      },
    },
    toggle = {
      map = LazyVim.safe_keymap_set,
    },
    words = {
      enabled = true,
    },
    zen = {
      enabled = true,
    },
  },
  keys = {
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.4,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command
      end,
    })
  end,
}
