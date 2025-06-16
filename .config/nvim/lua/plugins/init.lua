return {
  -- 🔧 Автоформаттер
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- включить форматирование при сохранении
    opts = require "configs.conform",
  },

  -- ⚙️ Настройки LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("configs.lspconfig")
    end,
  },

  -- 🔥 Git интерфейс в Neovim
  {
    "TimUntersberger/neogit",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = "Neogit",
    config = true, -- или можно function() require("neogit").setup() end
  },
}
