return {
  "sschleemilch/slimline.nvim",
  dependencies = {
    { "nvim-mini/mini.diff", opts = {} },
    { "nvim-mini/mini.icons" },
  },
  opts = function()
    local sep_left = ""
    local sep_right = ""
    local icon = "  "

    local custom_progress = function(active)
      local line = vim.fn.line(".")
      local total = vim.fn.line("$")
      local col = vim.fn.virtcol(".")
      local pct = math.floor(line / total * 100)

      local pos
      if line == 1 then
        pos = "Top"
      elseif line == total then
        pos = "Bot"
      else
        pos = pct .. "%"
      end

      local mode_map = {
        n = "normal",
        v = "visual",
        V = "visual",
        ["\22"] = "visual",
        s = "visual",
        S = "visual",
        ["\19"] = "visual",
        i = "insert",
        R = "replace",
        c = "command",
        r = "other",
        ["!"] = "other",
        t = "other",
      }
      local mode_key = mode_map[vim.fn.mode()] or "other"
      local mhls = Slimline.highlights.hls.components["mode"]
      local hl = {
        primary = mhls[mode_key].primary,
        secondary = mhls.secondary,
      }

      return Slimline.highlights.hl_component({
        primary = icon .. pos .. "%",
        secondary = line .. ":" .. col,
      }, hl, { left = sep_left, right = sep_right }, "left", active, "bg")
    end

    return {
      bold = false,
      style = "bg",

      components = {
        left = {
          "mode",
          "path",
          "git",
        },
        center = {
          "recording",
          "searchcount",
          "selectioncount",
        },
        right = {
          "diagnostics",
          "filetype_lsp",
          custom_progress,
        },
      },

      always_split_middle = true,
      components_inactive = {},

      configs = {
        mode = {
          verbose = true,
          hl = {
            normal = "Type",
            visual = "Statement",
            insert = "Character",
            replace = "Constructor",
            command = "String",
            other = "Function",
          },
          format = {
            ["n"] = { verbose = "NORMAL", short = "N" },
            ["v"] = { verbose = "VISUAL", short = "V" },
            ["V"] = { verbose = "V-LINE", short = "V-L" },
            ["\\22"] = { verbose = "V-BLOCK", short = "V-B" },
            ["s"] = { verbose = "SELECT", short = "S" },
            ["S"] = { verbose = "S-LINE", short = "S-L" },
            ["\\19"] = { verbose = "S-BLOCK", short = "S-B" },
            ["i"] = { verbose = "INSERT", short = "I" },
            ["R"] = { verbose = "REPLACE", short = "R" },
            ["c"] = { verbose = "COMMAND", short = "C" },
            ["r"] = { verbose = "PROMPT", short = "P" },
            ["!"] = { verbose = "SHELL", short = "S" },
            ["t"] = { verbose = "TERMINAL", short = "T" },
            ["U"] = { verbose = "UNKNOWN", short = "U" },
          },
        },
        path = {
          hl = {
            secondary = "Boolean",
          },
          trunc_width = 120,
          directory = true,
          truncate = {
            chars = 1,
            full_dirs = 3,
          },
          icons = {
            folder = " /",
            modified = "",
            read_only = "󰌾",
          },
        },
        git = {
          hl = {
            secondary = "Function",
          },
          trunc_width = 120,
          icons = {
            branch = "",
            added = " ",
            modified = " ",
            removed = " ",
          },
        },
        diagnostics = {
          trunc_width = 75,
          workspace = false,
          icons = {
            ERROR = " ",
            WARN = " ",
            INFO = " ",
            HINT = " ",
          },
          severity = {
            min = vim.diagnostic.severity.HINT,
          },
          hl = {
            error = "DiagnosticError",
            warn = "DiagnosticWarn",
            hint = "DiagnosticHint",
            info = "DiagnosticInfo",
          },
        },
        filetype_lsp = {
          hl = {
            secondary = "Function",
          },
          trunc_width = 95,
          map_lsps = {
            ["lua_ls"] = "Lua",
            ["basics_ls"] = "Basics",
            ["harper_ls"] = "Harper",
            ["copilot"] = "Copilot",
            ["textlsp"] = "Text",
            ["asm_lsp"] = "ASM",
            ["rust-analyzer"] = "Rust",
            ["pyright"] = "Pyright",
            ["ruff"] = "Ruff",
            ["clangd"] = "Clang",
            ["gopls"] = "Go",
            ["hyprls"] = "Hypr",
            ["hyprlang"] = "HyprLang",
            ["rubocop"] = "Ruby",
            ["tsserver"] = "TS",
            ["taplo"] = "TOML",
            ["html"] = "HTML",
            ["cssls"] = "CSS",
            ["tailwindcss"] = "Tailwind",
            ["jsonls"] = "JSON",
            ["yamlls"] = "YAML",
            ["texlab"] = "LaTeX",
            ["julials"] = "Julia",
            ["markdown_oxide"] = "MD",
            ["dockerls"] = "Docker",
            ["bashls"] = "Bash",
            ["qmlls"] = "QML",
          },
          lsp_sep = ":",
        },
        selectioncount = {
          hl = {
            primary = "Special",
          },
          icon = "󱊅 ",
        },
        searchcount = {
          hl = {
            primary = "Special",
          },
          icon = "󱈅 ",
          options = {
            recompute = true,
          },
        },
        recording = {
          icon = " ",
          hl = {
            primary = "Special",
          },
        },
      },

      spaces = {
        components = "─",
        left = "─",
        right = "─",
      },

      sep = {
        hide = {
          first = false,
          last = false,
        },
        left = sep_left,
        right = sep_right,
      },

      hl = {
        base = "Normal",
        base_inactive = "Normal",
        primary = "Normal",
        secondary = "Character",
      },

      disabled_filetypes = {},
    }
  end,
}
