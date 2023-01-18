local M = {}

M.defaults = {
    path_to_dbt = "dbt",
    path_to_project = vim.fn.expand("./tests/dbt_project"),
    path_to_profiles_dir = vim.fn.expand("./tests/dbt_project"),
}

M.options = {}

function M.setup(options)
    M.options = vim.tbl_deep_extend("force", M.defaults, options or {})
end

M.setup()

return M
