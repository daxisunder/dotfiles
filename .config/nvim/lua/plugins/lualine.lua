return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    if not vim.g.trouble_lualine then
      table.insert(opts.sections.lualine_c, { "navic", color_correction = "dynamic" })
    end
    local x = opts.sections.lualine_x
    for _, comp in ipairs(x) do
      if comp[1] == "diff" then
        comp.source = function()
          local summary = vim.b.minidiff_summary
          return summary
            and {
              added = summary.add,
              modified = summary.change,
              removed = summary.delete,
            }
        end
        break
      end
    end
  end,
}
