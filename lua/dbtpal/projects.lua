local log = require "dbtpal.log"
local config = require "dbtpal.config"

local M = {}

local _find_project_dir = function(fpath)
  if fpath == nil then fpath = vim.fn.expand "%:p:h" end
  log.debug("Searching for dbt project dir in " .. fpath)
  local path = vim.fn.expand(vim.fn.fnamemodify(fpath, ":p"))
  local dbt_project = vim.fn.findfile("dbt_project.yml", path .. ";")
  if dbt_project == "" then
    log.warn("No dbt project found in " .. path)
    return nil
  end
  return vim.fn.fnamemodify(dbt_project, ":p:h")
end

M.find_project_dir = function(bpath)
  log.debug "path_to_dbt is not set, attempting to autofind."
  local found = _find_project_dir(bpath)
  if found ~= nil then
    config.options.path_to_dbt_project = found
  else
    log.error(
      "Could not find dbt project in path: "
        .. bpath
        .. "."
        .. "and path not explicitly set. Try setting path_to_dbt_project in your "
        .. "config. See :help dbtpal-config"
    )
    return
  end
end

M._get_package_name = function()
  local name = vim.fn.system [[grep -E 'name: \S+' ~/projects/clients/causal/internal_dbt/dbt_project.yml]]
  return string.match(name, [[name:%s+['"]([%w_]+)]])
end

return M
