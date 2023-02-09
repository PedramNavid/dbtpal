return require("telescope").register_extension {
  setup = function(ext_config, config)
    local config = require "dbtpal.config"
    config.setup {
      path_to_dbt_project = "/Users/pedram/projects/clients/causal/internal_dbt/",
    }
  end,
  exports = {
    dbtpal = require("dbtpal").dbt_picker,
  },
}
