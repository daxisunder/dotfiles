return {
  "necrom4/convy.nvim",
  cmd = { "Convy", "ConvySeparator" },
  opts = {
    window = {
      position = "right",
      width = 48,
    },
  },
  keys = {
    -- example keymaps
    {
      "<localleader>c",
      ":Convy<CR>",
      desc = "Convert (interactive selection)",
      mode = { "n", "v" },
      silent = true,
    },
    {
      "<localleader>cd",
      ":Convy auto dec<CR>",
      desc = "Convert to decimal",
      mode = { "n", "v" },
      silent = true,
    },
    {
      "<localleader>cc",
      ":Convy auto hex_color<CR>",
      desc = "Convert to HEX",
      mode = { "n", "v" },
      silent = true,
    },
    {
      "<localleader>cr",
      ":Convy auto hsl<CR>",
      desc = "Convert to HSL",
      mode = { "n", "v" },
      silent = true,
    },
    {
      "<localleader>cr",
      ":Convy auto rgb<CR>",
      desc = "Convert to RGB",
      mode = { "n", "v" },
      silent = true,
    },
    {
      "<localleader>cs",
      ":ConvySeparator<CR>",
      desc = "Set conversion separator (visual selection)",
      mode = { "v" },
      silent = true,
    },
  },
}
