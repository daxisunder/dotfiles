return {
  "Mirsmog/real-icons.nvim",
  enabled = false,
  event = "UIEnter",
  build = ":RealIconsInstallPack material",
  opts = {
    pack = "material",
    integrations = {
      mini_files = true,
      snacks_picker = true,
      bufferline = true,
    },
  },
}
