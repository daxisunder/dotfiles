return {
  "rhysd/git-messenger.vim",
  setup = function()
    require("git-messenger").setup()
    vim.g.git_messenger_no_default_mappings = 0
    vim.g.git_messenger_include_diff = 1
    vim.g.git_messenger_always_into_popup = 1
    vim.g.git_messenger_popup_max_width = 80
    vim.g.git_messenger_popup_executable = "fzf"
    vim.g.git_messenger_popup_content_margins = "true"
    vim.g.git_messenger_floating_win_opts = {
      border = "rounded",
      highlights = {
        border = "FloatBorder",
      },
    }
  end,
  vim.api.nvim_set_keymap("n", "<leader>gm", ":GitMessenger<CR>", { noremap = true, silent = true }),
}
