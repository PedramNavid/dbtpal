local log = require "dbtpal.log"
local config = require "dbtpal.config"

local M = {}

M.build_path_args = function(cmd, args)
    log.trace("dbtpal config: " .. vim.inspect(config.options))
    local dbt_path = config.options.path_to_dbt
    local dbt_project = config.options.path_to_dbt_project
    local dbt_profile = config.options.path_to_dbt_profiles_dir

    local cmd_args = {}

    -- TODO: make this configurable
    local pre_cmd_args = config.options.pre_cmd_args or {}

    local post_cmd_args = {
        "--profiles-dir",
        dbt_profile,
        "--project-dir",
        dbt_project,
    }

    vim.list_extend(cmd_args, pre_cmd_args)
    vim.list_extend(cmd_args, { cmd })

    if type(args) == "string" then args = vim.split(args, " ") end

    if args ~= nil then vim.list_extend(cmd_args, args) end

    vim.list_extend(cmd_args, post_cmd_args)

    log.debug("Building dbt command: " .. dbt_path .. " " .. table.concat(cmd_args, " "))

    return dbt_path, cmd_args
end

return M
