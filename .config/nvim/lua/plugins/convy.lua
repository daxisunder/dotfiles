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
      "<leader>C",
      ":Convy<CR>",
      desc = "Convert (interactive selection)",
      mode = { "n", "v" },
      silent = true,
    },
    {
      "<leader>Cd",
      ":Convy auto dec<CR>",
      desc = "Convert to decimal",
      mode = { "n", "v" },
      silent = true,
    },
    {
      "<leader>Ch",
      ":Convy auto hex_color<CR>",
      desc = "Convert to HEX",
      mode = { "n", "v" },
      silent = true,
    },
    {
      "<leader>Cl",
      ":Convy auto hsl<CR>",
      desc = "Convert to HSL",
      mode = { "n", "v" },
      silent = true,
    },
    {
      "<leader>Cr",
      ":Convy auto rgb<CR>",
      desc = "Convert to RGB",
      mode = { "n", "v" },
      silent = true,
    },
    {
      "<leader>Cs",
      ":ConvySeparator<CR>",
      desc = "Set conversion separator (visual selection)",
      mode = { "v" },
      silent = true,
    },
  },
}
