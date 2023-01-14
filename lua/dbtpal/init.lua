--[[ this module exposes the interface of lua functions:
define here the lua functions that activate the plugin ]]

local main = require("dbtpal.main")
local config = require("dbtpal.config")

local M = {}

M.setup = config.setup
M.config = config

M.run = main.run
M.test = main.test
M.compile = main.compile
M.build = main.build
M.run_command = main.run_command

return M
