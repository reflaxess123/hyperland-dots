require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")-- LSP keymaps
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to Definition" })
map("n", "gr", "<cmd>Telescope lsp_references<CR>", { desc = "References" })
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { desc = "Go to Implementation" })
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Hover Docs" })
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename Symbol" })
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Code Action" })
map("n", "<leader>f", "<cmd>lua vim.lsp.buf.format()<CR>", { desc = "Format buffer" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Horizontal split" })
-- Навигация по сплитам с помощью стрелок
map("n", "<C-Left>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-Down>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-Up>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-Right>", "<C-w>l", { desc = "Move to right window" })
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Prev buffer" })
