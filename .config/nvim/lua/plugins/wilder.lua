return {
  -- a more adventurous wildmenu
  "gelguy/wilder.nvim",
  dependencies = {
    { "romgrk/fzy-lua-native" },
    { "kyazdani42/nvim-web-devicons" },
  },
  config = function()
    local wilder = require("wilder")
    wilder.setup({ modes = { ":", "/", "?" } })
    -- Disable Python remote plugin
    wilder.set_option("use_python_remote_plugin", 0)
    wilder.set_option("pipeline", {
      wilder.branch(
        wilder.cmdline_pipeline({
          fuzzy = 1,
          fuzzy_filter = wilder.lua_fzy_filter(),
        }),
        wilder.vim_search_pipeline()
      ),
    })
    wilder.set_option(
      "renderer",
      wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
        highlights = {
          border = "FloatBorder",
          accent = wilder.make_hl("WilderAccent", "Pmenu", { { a = 1 }, { a = 1 }, { foreground = "#069494" } }),
        },
        -- stylua: ignore
        border = "rounded",
        title = "Wilder",
        title_pos = "center",
        style = "minimal",
        empty_message = wilder.popupmenu_empty_message_with_spinner(),
        highlighter = {
          wilder.lua_pcre2_highlighter(), -- requires `luarocks install pcre2`
          wilder.lua_fzy_highlighter(), -- requires fzy-lua-native vim plugin found
        },
        left = {
          " ",
          wilder.popupmenu_devicons(),
          wilder.popupmenu_buffer_flags({
            flags = " a + ",
            icons = { ["+"] = "", a = "", h = "" },
          }),
        },
        right = { " ", wilder.popupmenu_scrollbar() },
      }))
    )
  end,
}
