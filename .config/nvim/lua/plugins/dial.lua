return {
  "monaqa/dial.nvim",
  version = false,
  event = "VeryLazy",
  opts = function(_, opts)
    local augend = require("dial.augend")

    -- add yes/no to global default groupp
    table.insert(
      opts.groups.default,
      augend.constant.new({
        elements = { "yes", "no" },
        word = true,
        cyclic = true,
      })
    )
    -- optional: also add to every filetype-specific group
    for name, group in pairs(opts.groups) do
      if name ~= "default" then
        table.insert(
          group,
          augend.constant.new({
            elements = { "yes", "no" },
            word = true,
            cyclic = true,
          })
        )
      end
    end

    --add on/off to global default group
    table.insert(
      opts.groups.default,
      augend.constant.new({
        elements = { "on", "off" },
        word = true,
        cyclic = true,
      })
    )
    -- optional: also add to every filetype-specific group
    for name, group in pairs(opts.groups) do
      if name ~= "default" then
        table.insert(
          group,
          augend.constant.new({
            elements = { "on", "off" },
            word = true,
            cyclic = true,
          })
        )
      end
    end

    return opts
  end,
}
