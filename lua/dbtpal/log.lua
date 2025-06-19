local M = {}
local log_level = vim.env.DBTPAL_LOG_LEVEL or vim.g.dbtpal_log_level
-- Most of this code borrowed from Lazy.nvim
-- https://github.com/folke/lazy.nvim/
---@alias DbtNotifyOpts {lang?:string, title?:string, level?:number}

---@param msg string|string[]
--@param opts? DbtNotifyOpts
function M.notify(msg, opts)
    if vim.in_fast_event() then
        return vim.schedule(function() M.notify(msg, opts) end)
    end

    opts = opts or {}
    opts.log_level = log_level
    if type(msg) == "table" then
        msg = table.concat(vim.tbl_filter(function(line) return line or false end, msg), "\n")
    end

    local lang = opts.lang or "markdown"
    vim.notify(msg, opts.level or vim.log.levels.INFO, {
        on_open = function(win)
            local buf = vim.api.nvim_win_get_buf(win)
            vim.bo[buf].filetype = lang
            vim.bo[buf].syntax = lang
        end,
        title = opts.title or "dbtpal",
    })
end

---@param msg string|string[]
---@param opts? DbtNotifyOpts
function M.error(msg, opts)
    opts = opts or {}
    opts.level = vim.log.levels.ERROR
    M.notify(msg, opts)
end

---@param msg string|string[]
---@param opts? DbtNotifyOpts
function M.info(msg, opts)
    opts = opts or {}
    opts.level = vim.log.levels.INFO
    M.notify(msg, opts)
end

---@param msg string|string[]
---@param opts? DbtNotifyOpts
function M.warn(msg, opts)
    opts = opts or {}
    opts.level = vim.log.levels.WARN
    M.notify(msg, opts)
end

---@param msg string|string[]
---@param opts? DbtNotifyOpts
function M.debug(msg, opts)
    if log_level ~= "debug" then return end
    opts = opts or {}
    opts.level = vim.log.levels.DEBUG
    M.notify(msg, opts)
end

---@param msg string|table
---@param opts? DbtNotifyOpts
function M.trace(msg, opts)
    if not (log_level == "debug" or log_level == "trace") then return end
    opts = opts or {}
    opts.level = vim.log.levels.TRACE
    if opts.title then opts.title = "dbtpal" .. opts.title end
    if type(msg) == "string" then
        M.notify(msg, opts)
    else
        opts.lang = "lua"
        M.notify(vim.inspect(msg), opts)
    end
end

return M
