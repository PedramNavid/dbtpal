return require("telescope").register_extension {
    setup = function(_ext_config, _config) end,
    exports = {
        dbtpal = require("dbtpal").dbt_picker,
    },
}
