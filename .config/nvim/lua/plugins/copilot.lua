return {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    { "github/copilot.vim" }, -- или zbirenbaum/copilot.lua
    { "nvim-lua/plenary.nvim", branch = "master" },
  },
  build = "make tiktoken", -- Только для macOS или Linux
  opts = {
    -- конфигурация CopilotChat
  },
  keys = {
    { "<leader>zc", ":CopilotChat<CR>",        mode = "n", desc = "Chat with Copilot" },
    { "<leader>ze", ":CopilotChatExplain<CR>", mode = "v", desc = "Explain Code" },
    { "<leader>zn", ":CopilotChatReview<CR>",  mode = "v", desc = "Review Code" },
    { "<leader>zf", ":CopilotChatFix<CR>",     mode = "v", desc = "Fix Code Issues" },
    { "<leader>zo", ":CopilotChatOptimize<CR>",mode = "v", desc = "Optimize Code" },
    { "<leader>zd", ":CopilotChatDocs<CR>",    mode = "v", desc = "Generate Docs" },
    { "<leader>zt", ":CopilotChatTests<CR>",   mode = "v", desc = "Generate Tests" },
    { "<leader>zm", ":CopilotChatCommit<CR>",  mode = "n", desc = "Generate Commit Message" },
    { "<leader>zs", ":CopilotChatCommit<CR>",  mode = "v", desc = "Generate Commit for Selection" },
  },
}