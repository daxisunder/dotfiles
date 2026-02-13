return {
  "polacekpavel/prompt-yank.nvim",
  event = "VeryLazy",
  cmd = { "PromptYank" },
  keys = {
    { "<Leader>yp", mode = { "n", "v" }, desc = "PromptYank: file/selection" },
    { "<Leader>ym", mode = "n", desc = "PromptYank: multi-file" },
    { "<Leader>yd", mode = { "n", "v" }, desc = "PromptYank: diff" },
    { "<Leader>yb", mode = { "n", "v" }, desc = "PromptYank: blame" },
    { "<Leader>ye", mode = "v", desc = "PromptYank: diagnostics" },
    { "<Leader>yt", mode = { "n", "v" }, desc = "PromptYank: tree" },
    { "<Leader>yr", mode = { "n", "v" }, desc = "PromptYank: remote URL" },
    { "<Leader>yf", mode = "n", desc = "PromptYank: function" },
    { "<Leader>yl", mode = "v", desc = "PromptYank: selection + definitions" },
    { "<Leader>yL", mode = "v", desc = "PromptYank: selection + deep definitions" },
    { "<Leader>yR", mode = "n", desc = "PromptYank: related files" },
  },
  opts = {},
  config = function(_, opts)
    require("prompt-yank").setup(opts)
  end,
}
