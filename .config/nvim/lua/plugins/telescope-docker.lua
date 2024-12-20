return {
  "krisajenkins/telescope-docker.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("telescope").load_extension("telescope_docker")
    require("telescope_docker").setup({})
  end,

  -- Example keybindings. Adjust these to suit your preferences or remove
  --   them entirely:
  keys = {
    {
      "<Leader>dv",
      ":Telescope telescope_docker docker_volumes<CR>",
      desc = "[D]ocker [V]olumes",
    },
    {
      "<Leader>di",
      ":Telescope telescope_docker docker_images<CR>",
      desc = "[D]ocker [I]mages",
    },
    {
      "<Leader>ds",
      ":Telescope telescope_docker docker_ps<CR>",
      desc = "[D]ocker Processe[s]",
    },
  },
}
