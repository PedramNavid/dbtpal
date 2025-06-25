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

local _current_model_name = function()
    -- `%` represents the current file.
    -- `:t` extracts just the file name (tail), excluding the directory path.
    -- `:r` removes the file extension from the file name.
    return vim.fn.expand "%:t:r"
end

local _picker = function(opts, additional_args)
    local cmd = "ls"
    local args = { "--resource-type=model", "--output=json", "--quiet" }

    additional_args = additional_args or {}
    vim.list_extend(args, additional_args)

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
    local model = _current_model_name()
    local additional_args = { "--select=" .. model .. "+" }
    _picker(opts, additional_args)
end

M.dbt_picker_upstream = function(opts)
    local model = _current_model_name()
    local additional_args = { "--select=+" .. model }
    _picker(opts, additional_args)
end

return M
