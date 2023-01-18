local config = require("dbtpal.config")
local log = require("dbtpal.log")
local display = require("dbtpal.display")

local M = {}

local function scheduled_error(err)
    vim.schedule(function() log.error(err) end)
end

local _cmd_select_args = function(cmd, selector, args)
    if not selector then return M.run_command(cmd, args) end

    if type(selector) == "string" then
        return M.run_command(
            cmd,
            vim.list_extend({ "--select", selector }, args or {})
        )
    end

    if type(selector) == "table" then
        return M.run_command(
            cmd,
            vim.list_extend(
                { "--select", table.concat(selector, " ") },
                args or {}
            )
        )
    end
end

M.run = function(selector, args) return _cmd_select_args("run", selector, args) end

M.test = function(selector, args)
    return _cmd_select_args("test", selector, args)
end

M.compile = function(selector, args)
    return _cmd_select_args("compile", selector, args)
end

M.build = function(selector, args)
    return _cmd_select_args("build", selector, args)
end

M.debug = function() return M.run_command("debug") end

M.run_command = function(cmd, args)
    -- cmd is a dbt command, e.g. "run", "test", "compile", "build", "debug"
    -- args is a table of additional arguments to pass to dbt
    --
    -- in reality, both cmd and args are arguments since the
    -- actual command to run is `dbt`

    local Job = require("plenary.job")
    local on_exit = function(data)
        log.info(data)
        display.popup("dbt " .. cmd, data)
    end

    local dbt_path = config.options.path_to_dbt
    local dbt_project = config.options.path_to_project
    local dbt_profile = config.options.path_to_profiles_dir

    local cmd_args = {}
    local pre_cmd_args = {
        "--debug",
        "--no-use-colors",
    }

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

    local job = Job:new({
        command = dbt_path,
        args = cmd_args,
        on_exit = function(j, code)
            if code ~= 0 then
                scheduled_error("dbt command failed with code " .. code)
            end
            vim.schedule(function() on_exit(j:result()) end)
        end,
    })

    job:start()

    return job
end

return M
