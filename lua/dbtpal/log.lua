local log_level = vim.env.DBTPAL_LOG_LEVEL or vim.g.dbtpal_log_level

return require("plenary.log").new {
    plugin = "dbtpal",
    level = log_level or "info",
}
