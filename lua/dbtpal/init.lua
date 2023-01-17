--[[ this module exposes the interface of lua functions:
define here the lua functions that activate the plugin ]]

local main = require("dbtpal.main")
local config = require("dbtpal.config")

local M = {}

M.setup = config.setup
M.config = config

M.run = main.run
M.debug = main.debug
M.test = main.test
M.compile = main.compile
M.build = main.build
M.run_command = main.run_command

-- Debug keybindings to run dbt
vim.api.nvim_set_keymap(
	"n",
	"<leader>dbr",
	":lua require('dbtpal').run()<CR>",
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>dbd",
	":lua require('dbtpal').debug()<CR>",
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>dbt",
	":lua require('dbtpal').test()<CR>",
	{ noremap = true, silent = true }
)

return M
