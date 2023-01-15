local config = require("dbtpal.config")
local log = require("dbtpal.log")
local display = require("dbtpal.display")

local M = {}

local function scheduled_error(err)
    vim.schedule(function()
        log.error(err)
    end)
end

M.run = function()
    return M.run_command("run")
end

M.test = function()
    return M.run_command("test")
end

M.compile = function()
    return M.run_command("compile")
end

M.build = function()
    return M.run_command("build")
end

M.debug = function()
    return M.run_command("debug")
end

M.run_command = function(cmd)

    local on_exit = function(data)
        log.info(data)
        display.popup("dbt " .. cmd, data)
    end

    local Job = require("plenary.job")
    local dbt_path = config.options.path_to_dbt
    local dbt_project = config.options.path_to_project
    local dbt_profile = config.options.path_to_profiles_dir

    local command = dbt_path
    local args = { "--no-use-colors", cmd, "--project-dir", dbt_project, "--profiles-dir", dbt_profile }

    Job:new({
        command = command,
        args = args,
        on_exit = function(j, code)
            if code ~= 0 then
                scheduled_error("dbt command failed with code " .. code)
            end
            vim.schedule(function()
                on_exit(j:result())
            end)
        end,
    }):start()

end

return M
