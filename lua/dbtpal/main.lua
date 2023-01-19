local config = require("dbtpal.config")
local projects = require("dbtpal.projects")
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

local _run = function(selector, args)
    return _cmd_select_args("run", selector, args)
end

local _test = function(selector, args)
    return _cmd_select_args("test", selector, args)
end

local _compile = function(selector, args)
    return _cmd_select_args("compile", selector, args)
end

local _build = function(selector, args)
    return _cmd_select_args("build", selector, args)
end

M.run_all = function(args) return _run(nil, args) end

M.run_model = function(selector, args) return _run(selector, args) end

M.run = function() return _run(vim.fn.expand("%:t:r")) end

M.test_all = function(args) return _test(nil, args) end

M.test_model = function(selector, args) return _test(selector, args) end

M.test = function() return _run(vim.fn.expand("%:t:r")) end

M.compile = function(selector, args) return _compile(selector, args) end

M.build = function(selector, args) return _build(selector, args) end

M.debug = function() return M.run_command("debug") end

M.run_command = function(cmd, args)
    if config.options.path_to_project == "" then
        log.debug("path_to_dbt is not set, attempting to autofind.")
        local bpath = vim.fn.expand("%:p:h")
        local found = projects.find_project_dir(bpath)
        if found ~= nil then
            config.options.path_to_project = found
        else
            log.error(
                "Could not find dbt project in path: "
                    .. bpath
                    .. "."
                    .. "and path not explicitly set. Try setting path_to_project in your "
                    .. "config. See :help dbtpal-config"
            )
            return
        end
    end

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

    log.debug(
        "Running dbt command: "
            .. dbt_path
            .. " "
            .. table.concat(cmd_args, " ")
    )

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
