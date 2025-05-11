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
      translator = {
        engine = {
          {
            name = "translate-shell",
            ---@param source string
            ---@param target string
            ---@param original string[]
            ---@param callback fun(translation: string[])
            translate = function(source, target, original, callback)
              -- 1. Optional: Do you need to convert the command line input language to the language supported by the translator?
              source = "en"
              target = "fr"
              -- 2. Add your custom processing logic
              vim.system(
                {
                  "trans",
                  "-b",
                  ("%s:%s"):format(source, target),
                  table.concat(original, "\n"),
                },
                { text = true },
                ---@param completed vim.SystemCompleted
                vim.schedule_wrap(function(completed)
                  -- 3. Call callback for rendering processing, the translation needs to return string[]
                  callback(vim.split(completed.stdout, "\n", { trimempty = false }))
                end)
              )
            end,
          },
        },
        handle = {
          {
            name = "echo",
            ---@param translator SmartTranslate.Translator
            render = function(translator)
              vim.print(translator.translation)
            end,
          },
        },
      },
    })
  end,
}
