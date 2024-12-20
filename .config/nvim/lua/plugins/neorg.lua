return {
  "nvim-neorg/neorg",
  lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
  version = "*", -- Pin Neorg to the latest stable release
  config = true,
  keys = {
    { "v", "<localleader><", "<Plug>(neorg.promo.demote.range)", desc = "demote objects in range" },
    { "v", "<localleader>>", "<Plug>(neorg.promo.promote.range)", desc = "promote objects in range" },
  },
  opts = {
    load = {
      ["core.defaults"] = {},
      ["core.concealer"] = {
        config = { -- We added a `config` table!
          icon_preset = "varied", -- And we set our option here.
        },
      },
      ["core.keybinds"] = {
        config = {
          default_keybinds = true,
        },
      },
      ["core.dirman"] = {
        config = {
          workspaces = {
            notes = "~/notes",
          },
        },
      },
    },
  },
}
