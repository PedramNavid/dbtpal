local p_debug = vim.fn.getenv("DEBUG_DBTPAL")

-- luacheck: ignore
if p_debug == vim.NIL then p_debug = false end

return require("plenary.log").new({
    plugin = "dbtpal",
    level = p_debug and "trace" or "info",
})
