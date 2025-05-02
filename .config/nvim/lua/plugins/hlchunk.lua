return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("hlchunk").setup({
      chunk = {
        enable = true,
        style = {
          "#1a1b26",
          "#ff899d",
        },
        chars = {
          right_arrow = "",
        },
        use_treesitter = true,
        error_sign = true,
      },
      line_num = {
        enable = false,
      },

      indent = {
        enable = false,
      },
      blank = {
        enable = false,
      },
    })
  end,
}
