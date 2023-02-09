-- This prevents accidentally writing to compiled files in dbt target folders
-- TODO: Make optional
vim.opt_local.buftype = "nowrite"
vim.opt_local.swapfile = "no"
