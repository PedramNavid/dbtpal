local config = require("dbtpal.config")
local log = require("dbtpal.log")

local M = {}

M.run = function(opts)
    return M.run_command("run")
end

M.test = function(opts)
    print("Testing dbt with opts", opts)
end

M.compile = function(opts)
    print("Compiling dbt with opts", opts)
end

M.build = function(opts)
    print("Building dbt with opts", opts)
end

M.debug = function(opts)
    return M.run_command("debug")
end

M.run_command = function(cmd)

    local Job = require("plenary.job")
    local dbt_path = config.options.path_to_dbt
    local dbt_project = config.options.path_to_project
    local dbt_profile = config.options.path_to_profiles_dir

    log.debug("dbt_path: " .. dbt_path)
    log.debug("dbt_project: " .. dbt_project)
    log.debug("dbt_profile: " .. dbt_profile)

    local command = dbt_path
    local args = {"--debug", "--no-use-colors", cmd, "--project-dir", dbt_project, "--profiles-dir", dbt_profile}

    log.debug("Running dbt command: ".. command .. " " .. table.concat(args, " "))


    local stderr = {}
    local stdout, ret = Job:new({
        command = command,
        args = args,
        on_stderr = function(_, data)
            table.insert(stderr, data)
        end,

    }):sync()

    if not vim.tbl_isempty(stderr) then
        log.fmt_error("Error running dbt command: %s ", stderr)
    end

    if not vim.tbl_isempty(stdout) then
        log.fmt_debug("Output from dbt command: %s", stdout)
    end

    return ret, stdout, stderr
end

--[[
--debug mode
--]]
config.setup {
    path_to_project = "~/projects/clients/causal/internal_dbt/"
}

M.debug()

return M
