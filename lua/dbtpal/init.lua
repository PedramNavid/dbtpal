--[[ this module exposes the interface of lua functions:
define here the lua functions that activate the plugin ]]

local main = require "dbtpal.main"
local config = require "dbtpal.config"
local dbt_picker = require("dbtpal.telescope").dbt_picker

-- TODO: Set option to selectively load this
require "dbtpal.files"

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

M.run_command = main.telescope_models
M.debug = main.debug

-- Debug keybindings to run dbt
vim.api.nvim_set_keymap("n", "<leader>dr", ":lua require('dbtpal').run()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>dt", ":lua require('dbtpal').test()<CR>", { noremap = true, silent = true })

-- TODO: delete these
vim.api.nvim_set_keymap("n", "<leader>\\", ":set syntax=sql<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>]", ":set syntax=dbt<CR>", { noremap = true, silent = true })

M.dbt_picker = dbt_picker
return M
