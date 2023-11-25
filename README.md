## dbtpal.nvim

![image](https://raw.githubusercontent.com/PedramNavid/dbtpal/main/assets/dbt%20model%20run.gif)

A Neovim plugin for dbt model editing. The little helper I wish I always had.

# ✨Features

- Run / test open model, the entire project, or arbitrary selectors
- Async jobs with pop-up command outputs
- Custom dbt filetype with better syntax highlighting
- Disables accidentally modifying sql files in the target folders
- Jump to any `ref` or `source` model using `gf` (go-to-file)
- Telescope Extension to fuzzy-find models
- Automatically detect dbt project folder

I do welcome requests and use-cases, so feel free to reach out
on Twitter ([@pdrmnvd](https://twitter.com/pdrmnvd)) or by creating an issue.

## ⚡️ Requirements

- Neovim >=0.5.0
- [dbt](https://docs.getdbt.com/dbt-cli/installation) >=1.0.0
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)

## ⚙ Installation

Install using your favorite plugin manager:

**Using Packer**

```lua

use {'PedramNavid/dbtpal',
    config = function()
        local dbt = require('dbtpal')
        dbt.setup {
          -- Path to the dbt executable
          path_to_dbt = "dbt",

          -- Path to the dbt project, if blank, will auto-detect
          -- using currently open buffer for all sql,yml, and md files
          path_to_dbt_project = "",

          -- Path to dbt profiles directory
          path_to_dbt_profiles_dir = vim.fn.expand "~/.dbt",

          -- Search for ref/source files in macros and models folders
          extended_path_search = true,

          -- Prevent modifying sql files in target/(compiled|run) folders
          protect_compiled_files = true

        }

        -- Setup key mappings

        vim.keymap.set('n', '<leader>drf', dbt.run)
        vim.keymap.set('n', '<leader>drp', dbt.run_all)
        vim.keymap.set('n', '<leader>dtf', dbt.test)
        vim.keymap.set('n', '<leader>dm', require('dbtpal.telescope').dbt_picker)

        -- Enable Telescope Extension
        require'telescope'.load_extension('dbtpal')
        end,
    requires = { { 'nvim-lua/plenary.nvim' }, {'nvim-telescope/telescope.nvim'} }
    }

```
## 🙈 Commands

dbtpal has sensible defaults and can auto-detect project directories based
on the currently open buffer when first run.


Your typical dbt commands are supported in three modes: current model, all models,
and user-specified models. See the sample setup above for some common mappings.

Commands can be either invoked as vim user-commands or through lua. Lua calls
provide more flexibility if additional arguments are required, but user-commands
work well if all you need is the default behavior, with a single model selector
argument.

#### DbtRun

In Lua: `require('dbtpal').run()`

Run the current model


#### DbtRunAll

In Lua: `require('dbtpal').run_all()`

Run all models in the project

#### DbtRunModel

In Lua: `require('dbtpal').run_model('+my_second_dbt_model')`

Run a specific model or selector. Requires a model selector argument.

Example: `DbtRunModel +my_second_dbt_model`

#### DbtTest

In Lua: `require('dbtpal').test()`

Test the current model

#### DbtTestAll

In Lua: `require('dbtpal').test_all()`

Test all models in the project

#### DbtTestModel

In Lua: `require('dbtpal').test_model('+my_second_dbt_model')`

Test a specific model or selector. Requires a model selector argument.

Example: `DbtTestModel +my_second_dbt_model`

#### DbtCompile

In Lua: `require('dbtpal').compile()`

Compile the current model

#### DbtBuild

In Lua: `require('dbtpal').build()`

Build the current model


### Additional Lua Only Functions

These commands are only available as Lua-only commands. You can map them to
specific key-bindings if you wish.

`require('dbtpal').run_children()`: equivalent to `dbt run -s model+`

`require('dbtpal').run_parents()`: equivalent to `dbt run -s +model`

`require('dbtpal').run_family()`: equivalent to `dbt run -s +model+`

###  Configuration

You can override default configuration options by passing a table to `setup({})`.
See the Installation section for an example

```
require("dbtpal").setup({ ... })
```

The following options are available:

| Option                   | Description                                              | Default                            |
| ------                   | -----------                                              | -------                            |
| path_to_dbt              | Path to the dbt executable                               | `dbt` (i.e. dbt in the local path) |
| path_to_dbt_project      | Path to the dbt project                                  | `""` (auto-detect)                 |
| path_to_dbt_profiles_dir | Path to dbt profiles directory                           | `"~/.dbt"`                         |
| extended_path_search     | Search for ref/source files in macros and models folders | `true`                             |
| protect_compiled_files   | Prevent modifying sql files in target/(compiled\|run) folders | `true`                    |


### Misc

Log level can be set with `vim.g.dbtpal_log_level` (must be **before** `setup()`)
or on the command line: `DBTPAL_LOG_LEVEL=info nvim myfile.sql`
