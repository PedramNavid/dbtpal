local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local themes = require "telescope.themes"

local config = require "dbtpal.config"
local commands = require "dbtpal.commands"
local projects = require "dbtpal.projects"
local log = require "dbtpal.log"
local J = require "plenary.job"
local display = require "dbtpal.display"

local M = {}

M.dbt_models = function(tbl, opts)
    opts = opts or themes.get_dropdown {}

    pickers
        .new(opts, {
            prompt_title = "dbt",
            finder = finders.new_table {

                results = tbl,
                entry_maker = function(entry)
                    local res = vim.fn.json_decode(entry)

                    if res == nil then return {} end

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

-- commands arguments like dbt `--select` require relative path to model from dbt project directory
local _model_relative_path_to_dbt = function()
    local b_full = vim.fn.expand "%:p"
    local b_relative = b_full:sub(#config.options.path_to_dbt_project + 1)
    if b_relative:sub(1, 1) == "/" then b_relative = b_relative:sub(2) end
    return b_relative
end

local _picker = function(opts, additional_args)
    additional_args = additional_args or {}

    local cmd = "ls"
    local args = { "--resource-type=model", "--output=json", "--quiet" }
    args = vim.tbl_extend("force", args, additional_args)

    if config.options.path_to_dbt_project == "" then
        local bpath = vim.fn.expand "%:p:h"
        if projects.detect_dbt_project_dir(bpath) == false then
            log.error "Couldn't detect a dbt project from this buffer. Try setting the dbt project directory manually"
            return
        end
    end

    local dbt_path, cmd_args = commands.build_path_args(cmd, args)

    local response = {}
    J:new({
        command = dbt_path,
        args = cmd_args,
        on_exit = function(j, code)
            if code == 0 then
                response = j:result()
                log.trace(response)
                vim.schedule(function() M.dbt_models(response, opts) end)
            else
                table.insert(response, "Failed to run dbt command. Exit Code: " .. code .. "\n")
                table.insert(response, config.options.path_to_dbt_project)
                local a = table.concat(cmd_args, " ") or ""
                local err = string.format("dbt command failed: %s %s\n\n", dbt_path, a)
                table.insert(response, "------------\n")
                table.insert(response, err)
                vim.list_extend(response, j:stderr_result())
                vim.list_extend(response, j:result())
                vim.schedule(function() display.popup(response) end)
            end
        end,
    }):start()
end

M.dbt_picker = function(opts) _picker(opts) end

M.dbt_picker_downstream = function(opts)
    local b_relative = _model_relative_path_to_dbt()
    local additional_args = { "--select=" .. b_relative .. "+" }
    _picker(opts, additional_args)
end

M.dbt_picker_upstream = function(opts)
    local b_relative = _model_relative_path_to_dbt()
    local additional_args = { "--select=+" .. b_relative }
    _picker(opts, additional_args)
end

return M
