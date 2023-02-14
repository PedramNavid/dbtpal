local config = require "dbtpal.config"
local projects = require "dbtpal.projects"
local commands = require "dbtpal.commands"
local log = require "dbtpal.log"
local J = require "plenary.job"
local display = require "dbtpal.display"

local M = {}

local _cmd_select_args = function(cmd, selector, args)
    if not selector then return M._create_job(cmd, args) end

    if type(selector) == "string" then
        return M._create_job(cmd, vim.list_extend({ "--select", selector }, args or {}))
    end

    if type(selector) == "table" then
        return M._create_job(cmd, vim.list_extend({ "--select", table.concat(selector, " ") }, args or {}))
    end
end

local _run = function(selector, args) return _cmd_select_args("run", selector, args) end

local _test = function(selector, args) return _cmd_select_args("test", selector, args) end

local _compile = function(selector, args) return _cmd_select_args("compile", selector, args) end

local _build = function(selector, args) return _cmd_select_args("build", selector, args) end

M.run_all = function(args) return _run(nil, args) end

M.run_model = function(selector, args) return _run(selector, args) end

M.run = function() return _run(vim.fn.expand "%:t:r") end

M.test_all = function(args) return _test(nil, args) end

M.test_model = function(selector, args) return _test(selector, args) end

M.test = function() return _run(vim.fn.expand "%:t:r") end

M.compile = function(selector, args) return _compile(selector, args) end

M.build = function(selector, args) return _build(selector, args) end

M.run_command = function(cmd, args) return _cmd_select_args(cmd, args) end

M._create_job = function(cmd, args)
    if config.options.path_to_dbt_project == "" then
        local bpath = vim.fn.expand "%:p:h"
        if projects.detect_dbt_project_dir(bpath) == false then
            log.warn(
                "Could not detect dbt project dir, try setting it manually "
                    .. "log or make sure this file is in a dbt project folder"
            )
            return
        end
    end

    local onexit = function(data) display.popup("dbt " .. cmd, data) end
    local dbt_path, cmd_args = commands.build_path_args(cmd, args)
    local response = {}
    local job = J:new {
        command = dbt_path,
        args = cmd_args,
        on_exit = function(j, code)
            if code ~= 0 then
                table.insert(response, "Failed to run dbt command. Exit Code: " .. code .. "\n")
                local a = table.concat(cmd_args, " ") or ""
                local err = string.format("dbt command %s failed.\n\n", a)
                table.insert(response, err)
                vim.list_extend(response, j:result())
            else
                response = j:result()
            end
            vim.schedule(function() onexit(response) end)
        end,
    }
    job:start()
    return job
end

return M
