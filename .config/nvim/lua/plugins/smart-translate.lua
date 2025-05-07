return {
  "askfiy/smart-translate.nvim",
  cmd = { "Translate" },
  dependencies = {
    "askfiy/http.nvim", -- a wrapper implementation of the Python aiohttp library that uses CURL to send requests.
  },
  config = function()
    require("smart-translate").setup({
      default = {
        cmds = {
          source = "auto",
          target = "fr-FR",
          handle = "float",
          engine = "google",
        },
        cache = true,
      },
      engine = {
        deepl = {
          --Support SHELL variables, or fill in directly
          api_key = "$DEEPL_API_KEY",
          base_url = "https://api-free.deepl.com/v2/translate",
        },
      },
      hooks = {
        ---@param opts SmartTranslate.Config.Hooks.BeforeCallOpts
        ---@return string[]
        before_translate = function(opts)
          return opts.original
        end,
        ---@param opts SmartTranslate.Config.Hooks.AfterCallOpts
        ---@return string[]
        after_translate = function(opts)
          return opts.translation
        end,
      },
    })
  end,
}
