-- Filetype helpers for dbt, many of the ideas for these commands
-- are borrowed from jgillies and his vim-dbt plugin

local projects = require("dbtpal.projects")

vim.api.nvim_create_augroup("dbtPal", {})

-- TODO: this should be configurable by the user
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = "dbtPal",
    pattern = { "*.sql" },
    command = "set filetype=dbt syntax=dbt suffixesadd+=.sql",
    desc = "Enable gf (go to file) under cursor)",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = "dbtPal",
    pattern = { "*.md", "*.yml" },
    command = "set suffixesadd+=.sql",
    desc = "Enable gf (go to file) under cursor)",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = "dbtPal",
    pattern = { "*.sql", "*.yml", "*.md" },
    callback = function(ev)
        local projPath = projects.find_project_dir(ev.file)
        if projPath then
            vim.opt.path:append(projPath .. "/macros/**")
            vim.opt.path:append(projPath .. "/models/**")
        end
    end,
    desc = "Look for files within dbt project folders",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = "dbtPal",
    pattern = { "*/target/run/*.sql", "*/target/compiled/*.sql" },
    command = "setlocal nomodifiable",
    desc = "Look for files within dbt project folders",
})
