local log = require "dbtpal.log"
local M = {}

M.defaults = {
    path_to_dbt = "dbt",
    path_to_dbt_project = "",
    path_to_dbt_profiles_dir = vim.fn.expand "~/.dbt",

    custom_dbt_syntax_enabled = true,
    extended_path_search = true,
    protect_compiled_files = true,

    pre_cmd_args = {
        "--printer-width=10",
    },

    env = {
        ["DBT_LOG_LEVEL"] = "NONE",
    },
}

M.options = {}

function M.setup(options)
    if options ~= nil then
        log.debug("dbtpal initial setup with supplied config: " .. vim.inspect(options))
        if options.path_to_dbt_project ~= "" then
            options.path_to_dbt_project = vim.fn.expand(options.path_to_dbt_project)
        end
        if options.path_to_dbt_profiles_dir ~= "" then
            options.path_to_dbt_profiles_dir = vim.fn.expand(options.path_to_dbt_profiles_dir)
        end
    end

    M.options = vim.tbl_deep_extend("force", M.defaults, options or {})
    require "dbtpal.files"
end

return M
