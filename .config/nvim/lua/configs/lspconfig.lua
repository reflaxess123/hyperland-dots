local on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities
local lspconfig = require("lspconfig")

-- HTML
lspconfig.html.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- CSS
lspconfig.cssls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- TypeScript / React
lspconfig.ts_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Python
lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})
