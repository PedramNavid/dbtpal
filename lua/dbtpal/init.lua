--[[ this module exposes the interface of lua functions:
define here the lua functions that activate the plugin ]]

local main = require "dbtpal.main"
local config = require "dbtpal.config"

local M = {}

M.config = config
M.setup = config.setup

M.run = main.run
M.run_all = main.run_all
M.run_model = main.run_model
M.run_children = main.run_children
M.run_parents = main.run_parents
M.run_family = main.run_family

M.test = main.test
M.test_all = main.test_all
M.test_model = main.test_model

M.compile = main.compile
M.build = main.build

M.run_command = main.run_command
M.debug = main.debug

-- Commands
vim.api.nvim_create_user_command("DbtRun", function() main.run() end, { nargs = 0 })

vim.api.nvim_create_user_command("DbtRunAll", function(cmd) main.run_all(cmd.args) end, { nargs = "?" })

vim.api.nvim_create_user_command("DbtRunModel", function(cmd) main.run_model(cmd.args) end, { nargs = 1 })

vim.api.nvim_create_user_command("DbtTest", function() main.test() end, { nargs = 0 })

vim.api.nvim_create_user_command("DbtTestAll", function(cmd) main.test_all(cmd.args) end, { nargs = "?" })

vim.api.nvim_create_user_command("DbtTestModel", function(cmd) main.test_model(cmd.args) end, { nargs = 1 })

vim.api.nvim_create_user_command("DbtCompile", function() main.compile() end, { nargs = 0 })

vim.api.nvim_create_user_command("DbtBuild", function() main.build() end, { nargs = 0 })

local ok, _ = pcall(require, "telescope")
if ok then M.dbt_picker = require("dbtpal.telescope").dbt_picker end
return M
