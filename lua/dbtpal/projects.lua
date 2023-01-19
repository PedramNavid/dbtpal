local log = require("dbtpal.log")

local M = {}
M.find_project_dir = function(fpath)
    if fpath == nil then fpath = vim.fn.expand("%:p:h") end
    log.debug("Searching for dbt project dir in " .. fpath)
    local path = vim.fn.expand(vim.fn.fnamemodify(fpath, ":p"))
    local dbt_project = vim.fn.findfile("dbt_project.yml", path .. ";")
    if dbt_project == "" then
        log.warn("No dbt project found in " .. path)
        return nil
    end
    vim.notify("Found dbt project in " .. dbt_project)
    return vim.fn.fnamemodify(dbt_project, ":p:h")
end
return M
