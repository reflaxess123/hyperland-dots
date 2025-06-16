local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettierd" },
    html = { "prettierd" },
    javascript = { "prettierd" },
    javascriptreact = { "prettierd" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },
    json = { "prettierd" },
    markdown = { "prettierd" },
  },

  -- Optional: форматировать через LSP, если нет formatters
  -- format_on_save = {
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

return options
