--[[ this module exposes the interface of lua functions:
define here the lua functions that activate the plugin ]]

local main = require "dbtpal.main"
local config = require "dbtpal.config"
local log = require "dbtpal.log"
require "dbtpal.files"

log.trace "dbtpal initialized"
local M = {}

M.setup = config.setup
M.config = config

M.run = main.run
M.run_all = main.run_all
M.run_model = main.run_model

M.test = main.test
M.test_all = main.test_all
M.test_model = main.test_model

M.compile = main.compile
M.build = main.build

M.run_command = main.run_command
M.debug = main.debug

-- Debug keybindings to run dbt
vim.api.nvim_set_keymap("n", "<leader>dr", ":lua require('dbtpal').run()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>dt", ":lua require('dbtpal').test()<CR>", { noremap = true, silent = true })

M.dbt_picker = require("dbtpal.telescope").dbt_picker
return M
