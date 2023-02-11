local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local themes = require "telescope.themes"

local config = require "dbtpal.config"
local commands = require "dbtpal.commands"
local projects = require "dbtpal.projects"
local log = require "dbtpal.log"
local J = require "plenary.Job"

local M = {}

local dbt_models = function(tbl, opts)
    opts = opts or themes.get_dropdown {}

    pickers
        .new(opts, {
            prompt_title = "dbt",
            finder = finders.new_table {

                results = tbl,
                entry_maker = function(entry)
                    local res = vim.fn.json_decode(entry)

                    if res == nil then return {} end
                    log.fmt_trace("Value: %s. Display: %s. Path: %s", res.unique_id, res.name, res.original_file_path)

                    return {
                        value = res.unique_id,
                        display = res.name,
                        ordinal = res.unique_id,
                        path = config.options.path_to_dbt_project .. "/" .. res.original_file_path,
                    }
                end,
            },

            sorter = conf.file_sorter(),
        })
        :find()
end

M.dbt_picker = function(opts)
    local cmd = "ls"
    local args = { "--resource-type=model", "--output=json" }

    if config.options.path_to_dbt_project == "" then
        local bpath = vim.fn.expand "%:p:h"
        if projects.detect_dbt_project_dir(bpath) == false then
            log.error "Couldn't detect a dbt project from this buffer. Try setting the dbt project directory manually"
            return
        end
    end

    local dbt_path, cmd_args = commands.build_path_args(cmd, args)
    local response = {}
    J
        :new({
            command = dbt_path,
            args = cmd_args,
            on_exit = function(j, code)
                if code ~= 0 then log.fmt_error("Exit Code: %s. Stderr=%s", code, vim.inspect(j:stderr_result())) end
                response = j:result()
                vim.schedule(function() dbt_models(response, opts) end)
            end,
        })
        :start()
end

return M
