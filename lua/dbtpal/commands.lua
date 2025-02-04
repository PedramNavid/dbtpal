local log = require "dbtpal.log"
local config = require "dbtpal.config"

local M = {}

local get_dbt_version = function()
    local cmd = vim.fn.systemlist "dbt --version | grep -Eo '[0-9]+\\.[0-9]+' | head -n 1"
    local version = cmd[1]
    log.debug("dbt version: " .. version)
    return tonumber(version)
end

M.build_path_args = function(cmd, args)
    log.debug("dbtpal config: " .. vim.inspect(config.options))
    local dbt_path = config.options.path_to_dbt
    local dbt_project = config.options.path_to_dbt_project
    local dbt_profile = config.options.path_to_dbt_profiles_dir
    local include_profiles_dir = config.options.include_profiles_dir
    local include_project_dir = config.options.include_project_dir
    local include_log_level = config.options.include_log_level

    local cmd_args = {}

    -- TODO: make this configurable
    local pre_cmd_args = config.options.pre_cmd_args or {}
    local post_cmd_args = config.options.post_cmd_args or {}

    if include_profiles_dir and dbt_profile ~= "v:null" then
        table.insert(post_cmd_args, "--profiles-dir")
        table.insert(post_cmd_args, dbt_profile)
    end

    if include_project_dir and dbt_project ~= "v:null" then
        table.insert(post_cmd_args, "--project-dir")
        table.insert(post_cmd_args, dbt_project)
    end

    if include_log_level and get_dbt_version() ~= nil and get_dbt_version() >= 1.5 then
        log.debug "dbt version >= 1.5, using --log-level=INFO"
        table.insert(post_cmd_args, "--log-level=INFO")
    end

    vim.list_extend(cmd_args, pre_cmd_args)
    vim.list_extend(cmd_args, { cmd })

    if type(args) == "string" then args = vim.split(args, " ") end

    if args ~= nil then vim.list_extend(cmd_args, args) end

    vim.list_extend(cmd_args, post_cmd_args)

    log.debug("Building dbt command: " .. dbt_path .. " " .. table.concat(cmd_args, " "))

    return dbt_path, cmd_args
end

return M
