return {
  "sschleemilch/slimline.nvim",
  dependencies = {
    { "nvim-mini/mini.diff", opts = {} },
    { "nvim-mini/mini.icons" },
  },
  opts = {
    bold = false, -- makes primary parts bold

    -- Global style. Can be overwritten using `configs.<component>.style`
    style = "bg", -- or "fg"

    -- Component placement
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
        "progress",
      },
    },
    -- Always split the middle section, even if it's empty
    always_split_middle = true,

    -- Inactive components
    components_inactive = {},

    -- Component configuration
    configs = {
      mode = {
        verbose = true, -- Selects the `verbose` format
        hl = {
          normal = "Type",
          visual = "Constructor",
          insert = "Character",
          replace = "Statement",
          command = "String",
          other = "Function",
        },
        format = {
          ["n"] = { verbose = "NORMAL", short = "N" },
          ["v"] = { verbose = "VISUAL", short = "V" },
          ["V"] = { verbose = "V-LINE", short = "V-L" },
          ["\22"] = { verbose = "V-BLOCK", short = "V-B" },
          ["s"] = { verbose = "SELECT", short = "S" },
          ["S"] = { verbose = "S-LINE", short = "S-L" },
          ["\19"] = { verbose = "S-BLOCK", short = "S-B" },
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
        directory = true, -- Whether to show the directory
        -- truncates the directory path. Can be disabled by setting `truncate = false`
        truncate = {
          chars = 1, -- number of characters for each path component
          full_dirs = 2, -- how many path components to keep unshortened
        },
        icons = {
          folder = " ",
          modified = "",
          read_only = "",
        },
      },
      git = {
        hl = {
          secondary = "Function",
        },
        trunc_width = 120,
        icons = {
          branch = "",
          added = " ",
          modified = " ",
          removed = " ",
        },
      },
      diagnostics = {
        trunc_width = 75,
        workspace = false, -- Whether diagnostics should show workspace diagnostics instead of current buffer
        icons = {
          ERROR = " ",
          WARN = " ",
          INFO = " ",
          HINT = " ",
        },
        severity = {
          -- vim.diagnostic.SeverityFilter options
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
        -- Map lsp client names to custom names or ignore them by setting to `false`
        -- E.g. { ['tsserver'] = 'TS', ['pyright'] = 'Python', ['GitHub Copilot'] = false }
        map_lsps = {},
        lsp_sep = ",", -- separator between attached LSPs
      },
      selectioncount = {
        hl = {
          primary = "Special",
        },
        icon = "󰈈 ",
      },
      searchcount = {
        hl = {
          primary = "Special",
        },
        icon = " ",
        -- Options to be passed to vim.fn.searchcount, see :h searchcount
        options = {
          recompute = true,
        },
      },
      progress = {
        follow = "mode",
        column = false, -- Enables a secondary section with the cursor column
        icon = " ",
      },
      recording = {
        icon = " ",
        hl = {
          primary = "Special",
        },
      },
    },

    -- Spacing configuration
    spaces = {
      components = "─",
      left = "─",
      right = "─",
    },

    -- Seperator configuartion
    sep = {
      hide = {
        first = false, -- hides the first separator of the line
        last = false, -- hides the last separator of the line
      },
      left = "", -- left separator of components
      right = "", -- right separator of components
    },

    -- Global highlights
    hl = {
      base = "Normal", -- highlight of the background
      base_inactive = "Normal", -- highlight of the background when inactive
      primary = "Normal", -- highlight of primary parts (e.g. filename)
      secondary = "Comment", -- highlight of secondary parts (e.g. filepath)
    },

    -- Hide statusline on filetypes
    disabled_filetypes = {},
  },
}
