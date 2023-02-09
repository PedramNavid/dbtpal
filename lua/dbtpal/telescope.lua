local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local main = require "dbtpal.main"
local themes = require "telescope.themes"

local config = require "dbtpal.config"
local log = require "dbtpal.log"
local Path = require "plenary.path"

M = {}

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

          return {
            value = res.unique_id,
            display = res.name,
            ordinal = res.unique_id,
            path = Path:new({
              config.options.path_to_dbt_project .. res.original_file_path,
            }):absolute(),
          }
        end,
      },

      sorter = conf.file_sorter(),
    })
    :find()
end

M.dbt_picker = function(opts)
  local res = main.telescope_models("ls", {
    "--resource-type=model",
    "--output=json",
  })
  return dbt_models(res, opts)
end

return M
