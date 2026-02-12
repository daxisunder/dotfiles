return {
  "TKasperczyk/snacks-gallery.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = function()
    require("snacks-gallery").setup({
      -- File extensions to show in the gallery
      extensions = {
        jpg = true,
        jpeg = true,
        png = true,
        gif = true,
        bmp = true,
        webp = true,
        tiff = true,
        heic = true,
        avif = true,
        mp4 = true,
        mkv = true,
        webm = true,
        avi = true,
        mov = true,
      },
      -- Where to store generated thumbnails
      thumb_cache = vim.fn.stdpath("cache") .. "/snacks-gallery-thumbs",
      -- Thumbnail size passed to ImageMagick
      thumb_size = "200x200",
      -- Max concurrent thumbnail generation jobs
      max_workers = 4,
      -- Command to open files externally (Enter key)
      open_cmd = vim.fn.has("mac") == 1 and { "open" } or { "xdg-open" },
      -- Gallery window size as fraction of screen
      win_scale = 0.8,
      -- Preview window size as fraction of screen
      preview_scale = 0.7,
    })
  end,
  keys = {
    {
      "<leader>sI",
      function()
        require("snacks-gallery").open()
      end,
      desc = "Images",
    },
  },
}
