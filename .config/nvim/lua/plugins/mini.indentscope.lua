return {
  "echasnovski/mini.indentscope",
  version = false,
  config = function()
    require("mini.indentscope").setup({
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        -- Textobjects
        objeict_scope = "",
        object_scope_with_border = "",

        -- Motions (jump to respective border line; if not present - body line)
        goto_top = "[i",
        goto_bottom = "]i",
      },
    })
  end,
}
