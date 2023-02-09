return require("telescope").register_extension {
    setup = function(ext_config, config) end,
    exports = {
        dbtpal = require("dbtpal").dbt_picker,
    },
}
