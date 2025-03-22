return {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    { "zbirenbaum/copilot.lua" }, -- or "github/copilot.vim"
    { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
  },
  build = "make tiktoken", -- Only on MacOS or Linux
  opts = {
    config = function()
      require("copilotchat").setup({
        -- default window options
        window = {
          layout = "float", -- 'vertical', 'horizontal', 'float', 'replace'
          width = 0.5, -- fractional width of parent, or absolute width in columns when > 1
          height = 0.5, -- fractional height of parent, or absolute height in rows when > 1
          -- Options below only apply to floating windows
          relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
          border = "rounded", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
          border_color = "f4bb44", -- border color
          row = nil, -- row position of the window, default is centered
          col = nil, -- column position of the window, default is centered
          title = "Copilot Chat", -- title of chat window
          footer = nil, -- footer of chat window
          zindex = 1, -- determines if window is on top or below other floating windows
        },
      })
    end,
  },
}
