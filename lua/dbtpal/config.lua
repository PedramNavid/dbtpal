local log = require "dbtpal.log"
local M = {}

M.defaults = {
    path_to_dbt = "dbt",
    path_to_dbt_project = "",
    path_to_dbt_profiles_dir = vim.fn.expand "~/.dbt",

    custom_dbt_syntax_enabled = true,
    extended_path_search = true,
    protect_compiled_target_files = true,

    pre_cmd_args = {
        "--use-colors",
        "--printer-width=10",
    },
}

M.options = {}

function M.setup(options) M.options = vim.tbl_deep_extend("force", M.defaults, options or {}) end

M.setup()

log.trace(M.options)

return M
