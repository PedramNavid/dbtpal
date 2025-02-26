local config = require "dbtpal.config"
local projects = require "dbtpal.projects"
local commands = require "dbtpal.commands"
local log = require "dbtpal.log"
local J = require "plenary.job"
local display = require "dbtpal.display"

local M = {}

local _cmd_select_args = function(cmd, selector, args)
    if selector == nil then return M._create_job(cmd, args) end

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

local _list = function(selector, args) return _cmd_select_args("list", selector, args) end

local _docs_generate = function(selector, args) return _cmd_select_args("docs generate", selector, args) end

local _docs_serve = function(selector, args) return _cmd_select_args("docs serve", selector, args) end

local _run_operation = function(selector, args) return _cmd_select_args("run operation", selector, args) end

local _seed = function(selector, args) return _cmd_select_args("seed", selector, args) end

local _show = function(selector, args) return _cmd_select_args("show", selector, args) end

local _snapshot = function(selector, args) return _cmd_select_args("snapshot", selector, args) end

local _source_freshness = function(args) return _cmd_select_args("source freshness", nil, args) end
-- dbt commands not requiring selectors

local _parse = function(args) return _cmd_select_args("parse", nil, args) end

local _clean = function(args) return _cmd_select_args("clean", nil, args) end

local _debug = function(args) return _cmd_select_args("debug", nil, args) end

local _deps = function(args) return _cmd_select_args("deps", nil, args) end

local _retry = function(args) return _cmd_select_args("retry", nil, args) end

M.run_all = function(args) return _run(nil, args) end

M.run_model = function(selector, args) return _run(selector, args) end

M.run = function() return _run(vim.fn.expand "%:t:r") end

M.run_children = function() return _run(vim.fn.expand "%:t:r" .. "+") end
M.run_parents = function() return _run("+" .. vim.fn.expand "%:t:r") end
M.run_family = function() return _run("+" .. vim.fn.expand "%:t:r" .. "+") end

M.test_all = function(args) return _test(nil, args) end

M.test_model = function(selector, args) return _test(selector, args) end

M.test = function() return _run(vim.fn.expand "%:t:r") end

M.compile = function(selector, args) return _compile(selector, args) end

M.build = function(selector, args) return _build(selector, args) end

M.list = function(selector, args) return _list(selector, args) end

M.docs_generate = function(selector, args) return _docs_generate(selector, args) end

M.docs_serve = function(selector, args) return _docs_serve(selector, args) end

M.run_operation = function(selector, args) return _run_operation(selector, args) end

M.seed = function(selector, args) return _seed(selector, args) end

M.show = function(selector, args) return _show(selector, args) end

M.snapshot = function(selector, args) return _snapshot(selector, args) end

-- dbt commands not requiring selectors

M.clean = function(args) return _clean(args) end

M.debug = function(args) return _debug(args) end

M.deps = function(args) return _deps(args) end

M.retry = function(args) return _retry(args) end

M.parse = function(args) return _parse(args) end

M.run_command = function(cmd, args) return _cmd_select_args(cmd, args) end

M._create_job = function(cmd, args)
    log.info("dbt " .. cmd .. " queued")
    if config.options.path_to_dbt_project == "" then
        local bpath = vim.fn.expand "%:p:h"
        if projects.detect_dbt_project_dir(bpath) == false then
            log.warn(
                "Could not detect dbt project dir, try setting it manually "
                .. "or make sure this file is in a dbt project folder"
            )
            return
        end
    end

    local onexit = function(data) display.popup(data) end
    if args == "" then args = nil end
    local dbt_path, cmd_args = commands.build_path_args(cmd, args)
    local response = {}
    local job = J:new {
        command = dbt_path,
        args = cmd_args,
        on_exit = function(j, code)
            if code == 1 then
                vim.list_extend(response, j:result())
                log.warn "dbt command encounted a handled error, see popup for details"
            elseif code >= 2 then
                table.insert(response, "Failed to run dbt command. Exit Code: " .. code .. "\n")
                local a = table.concat(cmd_args, " ") or ""
                local err = string.format("dbt command failed: %s %s\n\n", dbt_path, a)
                table.insert(response, "------------\n")
                table.insert(response, err)
                log.debug(j)
                vim.list_extend(response, j:result())
                vim.list_extend(response, j:stderr_result())
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
