## Contributing

To work on this project, you will want to fork and clone this repo locally,
and then update your Neovim package manager to reference the local install.

In Packer, it looks like this
```
use({
    "~/projects/dbtpal",
    requires = { { "nvim-lua/plenary.nvim" }, { "nvim-telescope/telescope.nvim" } },
})
```

You may also want to bind a hotkey to fast reload the dbt module:

```
nnoremap { 'rr', function() require('plenary.reload').reload_module('dbtpal') end }
```

Note: even with reloading, sometimes you will need to restart Neovim to see
changes.

## Dbt Test Project

A test dbt project is included in the `tests/` folder. Copy the contents from
the `profiles.yml` file to your `~/.dbt/profiles.yml` file. It uses the duckdb
adapter, so make sure that is installed as well

```
pip install dbt-core dbt-duckdb
```

Finally make sure you can compile and run the dbt project

```
dbt compile
dbt run
```

## Running Neovim

You may wish to increase the log level before opening Neovim

```
DBTPAL_LOG_LEVEL=debug nvim
```

## Testing in a blank environment

Use `vim-plug` 
nvim -U init.lua -c PlugInstall -c qa --headless
