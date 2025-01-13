return {
  "nvim-telescope/telescope.nvim",
  config = function()
    require("telescope").setup({
      defaults = {
        layout_config = {
          horizontal = {
            preview_width = 0.55,
          },
        },
      },
    })
  end,
  keys = {
    -- add a keymap to browse plugin files
    -- stylua: ignore
    {
      "<leader>fp",
      function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
      desc = "Find Plugin File",
    },
  },
}
