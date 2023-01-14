local log = require("dbtpal.log")
local M = {}

M.defaults = {
    path_to_dbt = "dbt",
    path_to_project = ".",
    path_to_profiles_dir = "$HOME/.dbt",
}

M.options = {}

function M.setup(options)
    M.options = vim.tbl_deep_extend("force", M.defaults, options or {})
    log.trace("options", M.options)
end

M.setup()

return M
