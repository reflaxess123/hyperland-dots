---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "aylin",
  transparency = true,

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
}

-- M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
--}
M.plugins = "plugins"           -- подключает твой lua/plugins/init.lua
M.mappings = require "mappings" -- подключает lua/mappings.lua
return M
