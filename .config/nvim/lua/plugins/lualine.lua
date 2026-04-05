-- https://gitlab.com/taken-personal/neovim-config/-/blob/main/lua/taken/plugins/lualine.lua?ref_type=heads
return {
  "nvim-lualine/lualine.nvim",
  version = false,
  event = "VeryLazy",
  dependencies = {
    "nvim-mini/mini.icons",
    "AndreM222/copilot-lualine",
    "letieu/harpoon-lualine",
    "pnx/lualine-lsp-status",
  },
  config = function()
    local lualine = require("lualine")
    local colors = {
      bg = "#1a1b26",
      fg = "#c0caf5",
      yellow = "#fff192",
      cyan = "#a4daff",
      blue = "#8db0ff",
      darkblue = "#7aa2f7",
      green = "#9fe044",
      orange = "#e0af68",
      violet = "#bb9af7",
      magenta = "#c7a9ff",
      red = "#f7768e",
    }

    vim.api.nvim_set_hl(0, "lualine_c_normal", { fg = colors.fg, bg = colors.bg })

    local conditions = {
      hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end,
      alpha = function()
        local ft = vim.bo.filetype
        if ft ~= "alpha" and ft ~= "snacks_dashboard" then
          return true
        end
      end,
    }

    local mode_color = {
      n = colors.darkblue,
      i = colors.green,
      v = colors.red,
      [""] = colors.red,
      V = colors.red,
      c = colors.magenta,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      [""] = colors.orange,
      ic = colors.yellow,
      R = colors.violet,
      Rv = colors.violet,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ["r?"] = colors.cyan,
      ["!"] = colors.red,
      t = colors.red,
    }

    local function mason_updates()
      local registry = require("mason-registry")
      registry.refresh()
      local installed_packages = registry.get_installed_package_names()
      local packages_outdated = 0
      for _, pkg in pairs(installed_packages) do
        local p = registry.get_package(pkg)
        local version = p.get_installed_version(p)
        local latest = p.get_latest_version(p)
        if version ~= latest then
          packages_outdated = packages_outdated + 1
        end
      end
      return packages_outdated
    end

    local function show_macro_recording()
      local recording_register = vim.fn.reg_recording()
      if recording_register == "" then
        return ""
      else
        return "󰑋 " .. recording_register
      end
    end

    local function get_buffers()
      local bufs = vim.api.nvim_list_bufs()
      local bufNumb = 0
      local function buffer_is_valid(buf_id, buf_name)
        return 1 == vim.fn.buflisted(buf_id) and buf_name ~= ""
      end
      for idx = 1, #bufs do
        local buf_id = bufs[idx]
        local buf_name = vim.api.nvim_buf_get_name(buf_id)
        if buffer_is_valid(buf_id, buf_name) then
          bufNumb = bufNumb + 1
        end
      end
      return "[" .. bufNumb .. "] "
    end

    local mode = {
      "mode",
      separator = { left = " ", right = " " },
      right_padding = 2,
      color = function()
        return { bg = mode_color[vim.fn.mode()], fg = colors.bg }
      end,
    }
    local filename = {
      "filename",
      color = { fg = colors.magenta, bg = colors.bg, gui = "bold" },
      cond = conditions.alpha,
    }
    local alpha = {
      function()
        return "Dashboard"
      end,
      color = { fg = colors.magenta, bg = colors.bg, gui = "bold" },
      cond = function()
        local ft = vim.bo.filetype
        if ft == "alpha" or ft == "snacks_dashboard" then
          return true
        end
      end,
    }
    local branch = {
      "branch",
      icon = "",
      color = { fg = colors.yellow, bg = colors.bg, gui = "bold" },
      on_click = function()
        vim.cmd("LazyGit")
      end,
    }
    local lsp_status = {
      "lsp-status",
      color = { fg = colors.green, bg = colors.bg, gui = "bold" },
      on_click = function()
        vim.cmd("LspInfo")
      end,
      cond = conditions.alpha,
    }
    local diagnostics = {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      -- FIX: use explicit icon strings, not relying on mini.icons override
      symbols = {
        error = " ",
        warn = " ",
        info = " ",
        hint = " ",
      },
      diagnostics_color = {
        color_error = { fg = colors.red, bg = colors.bg, gui = "bold" },
        color_warn = { fg = colors.yellow, bg = colors.bg, gui = "bold" },
        color_info = { fg = colors.cyan, bg = colors.bg, gui = "bold" },
        color_hint = { fg = colors.green, bg = colors.bg, gui = "bold" },
      },
      -- FIX: prevent mini.icons from hijacking the component's icon rendering
      icon = "",
    }
    local macro_recording = {
      show_macro_recording,
      color = { fg = "#000000", bg = "#ff6666" },
      separator = { left = "", right = "" },
    }
    local harpoon = {
      "harpoon2",
      icon = "󰦾 ",
      indicators = { "1", "2", "3", "4", "5", "6", "7", "8" },
      active_indicators = { "[1]", "[2]", "[3]", "[4]", "[5]", "[6]", "[7]", "[8]" },
      _separator = " ",
      separator = { left = "", right = "" },
      color = function()
        return { bg = mode_color[vim.fn.mode()], fg = "#000000", gui = "bold" }
      end,
      cond = conditions.alpha,
    }
    local copilot = {
      "copilot",
      symbols = {
        status = {
          hl = {
            enabled = colors.green,
            sleep = colors.yellow,
            disabled = colors.bg,
            warning = colors.orange,
            unknown = colors.red,
          },
        },
      },
      show_colors = true,
      color = { bg = colors.bg, gui = "bold" },
      cond = conditions.alpha,
    }
    local diff = {
      "diff",
      -- FIX: explicit nerd font glyphs so mini.icons doesn't suppress them
      symbols = {
        added = " ",
        modified = " ",
        removed = " ",
      },
      diff_color = {
        added = { fg = colors.green, bg = colors.bg },
        modified = { fg = colors.orange, bg = colors.bg },
        removed = { fg = colors.red, bg = colors.bg },
      },
      cond = conditions.hide_in_width,
    }
    local lazy = {
      require("lazy.status").updates,
      cond = require("lazy.status").has_updates,
      color = { fg = colors.violet, bg = colors.bg },
      on_click = function()
        vim.ui.select({ "Yes", "No" }, { prompt = "Update plugins?" }, function(choice)
          if choice == "Yes" then
            vim.cmd("Lazy sync")
          else
            vim.notify("Update cancelled", vim.log.levels.INFO, { title = "Lazy" })
          end
        end)
      end,
    }
    local mason = {
      function()
        return mason_updates() .. ""
      end,
      color = { fg = colors.green, bg = colors.bg },
      cond = function()
        return mason_updates() > 0
      end,
      icon = "",
      on_click = function()
        vim.cmd("Mason")
      end,
    }
    local buffers = {
      function()
        return get_buffers()
      end,
      color = { fg = colors.darkblue, bg = colors.bg },
      cond = conditions.alpha,
      on_click = function()
        if package.loaded["snacks"] then
          require("snacks").picker.buffers()
        else
          vim.cmd("ls")
        end
      end,
    }
    local filetype = {
      "filetype",
      color = { fg = colors.darkblue, bg = colors.bg },
    }
    local progress = {
      "progress",
      color = { fg = colors.magenta, bg = colors.bg },
    }
    local location = {
      "location",
      separator = { left = "", right = "" },
      left_padding = 2,
      color = function()
        return { bg = mode_color[vim.fn.mode()], fg = colors.bg }
      end,
    }
    local sep = {
      "%=",
      color = { fg = colors.bg, bg = colors.bg },
    }

    lualine.setup({
      options = {
        theme = {
          normal = {
            a = { bg = colors.bg, fg = colors.fg },
            b = { bg = colors.bg, fg = colors.fg },
            c = { bg = colors.bg, fg = colors.fg },
          },
          insert = {
            a = { bg = colors.bg, fg = colors.fg },
            b = { bg = colors.bg, fg = colors.fg },
            c = { bg = colors.bg, fg = colors.fg },
          },
          visual = {
            a = { bg = colors.bg, fg = colors.fg },
            b = { bg = colors.bg, fg = colors.fg },
            c = { bg = colors.bg, fg = colors.fg },
          },
          replace = {
            a = { bg = colors.bg, fg = colors.fg },
            b = { bg = colors.bg, fg = colors.fg },
            c = { bg = colors.bg, fg = colors.fg },
          },
          command = {
            a = { bg = colors.bg, fg = colors.fg },
            b = { bg = colors.bg, fg = colors.fg },
            c = { bg = colors.bg, fg = colors.fg },
          },
          inactive = {
            a = { bg = colors.bg, fg = colors.fg },
            b = { bg = colors.bg, fg = colors.fg },
            c = { bg = colors.bg, fg = colors.fg },
          },
        },
        component_separators = "",
        section_separators = { left = "", right = "" },
        always_divide_middle = true,
        globalstatus = true,
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { filename, alpha, buffers, branch, lsp_status },
        lualine_c = { diagnostics, sep, macro_recording, harpoon },
        lualine_x = { copilot, diff, filetype },
        lualine_y = { mason, lazy, progress },
        lualine_z = { location },
      },
      inactive_sections = {
        lualine_a = { filename },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { location },
      },
      tabline = {},
      extensions = {},
    })

    vim.api.nvim_create_autocmd("RecordingEnter", {
      callback = function()
        lualine.refresh()
      end,
    })

    vim.api.nvim_create_autocmd("RecordingLeave", {
      callback = function()
        local timer = vim.loop.new_timer()
        if timer then
          timer:start(
            50,
            0,
            vim.schedule_wrap(function()
              lualine.refresh()
              if not timer:is_closing() then
                timer:close()
              end
            end)
          )
        end
      end,
    })
  end,
}
