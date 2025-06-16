vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- Конфигурация ТОЛЬКО для VSCode
if vim.g.vscode then
  vim.opt.clipboard = "unnamedplus"

  local vscode = require('vscode')

  vim.keymap.set("n", "<leader>x", function()
    vscode.action("workbench.action.closeActiveEditor")
  end)
  vim.keymap.set("n", "<leader>e", function()
    vscode.action("workbench.view.explorer")
  end)
  vim.keymap.set("n", "<leader>fg", function()
    vscode.action("workbench.action.quickOpen")
  end)
  vim.keymap.set("n", "<leader>ff", function()
    vscode.action("workbench.action.findInFiles")
  end)
  vim.keymap.set("n", "<leader>g", function()
    vscode.action("workbench.view.scm")
  end)
  vim.keymap.set("n", "<leader>sv", function()
    vscode.action("workbench.action.splitEditorRight")
  end)
-- Основной Neovim-конфиг — не запускается внутри VSCode
else
  -- bootstrap lazy and all plugins
  local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

  if not vim.uv.fs_stat(lazypath) then
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
  end

  vim.opt.rtp:prepend(lazypath)

  local lazy_config = require "configs.lazy"

  require("lazy").setup({
    {
      "NvChad/NvChad",
      lazy = false,
      branch = "v2.5",
      import = "nvchad.plugins",
    },
    { import = "plugins" },
  }, lazy_config)

  -- load theme
  dofile(vim.g.base46_cache .. "defaults")
  dofile(vim.g.base46_cache .. "statusline")

  require "options"
  require "autocmds"

  vim.schedule(function()
    require "mappings"
  end)
end
