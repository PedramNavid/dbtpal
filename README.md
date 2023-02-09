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

use {'pdrmnvd/dbtpal',
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
          protect_compiled_target_files = true

        }

        -- Setup key mappings

        vim.keymap.set('n', '<leader>drf', dbt.run)
        vim.keymap.set('n', '<leader>drp', dbt.run_all)
        vim.keymap.set('n', '<leader>dtf', dbt.test)
        vim.keymap.set('n', '<leader>dm', require('dbtpal.telescope').dbt_picker)

        -- Enable Telescope Extension
        require'telescope'.load_extension('dbt_pal')
        end,
    requires = { { 'nvim-lua/plenary.nvim' }, {'nvim-telescope/telescope.nvim'} }
    }

```
## 🙈 Usage

dbtpal has sensible defaults and can auto-detect project directories based
on the currently open buffer when first run.

Log level can be set with `vim.g.dbtpal_log_level` (must be **before** `setup()`)

Your typical dbt commands are supported in three modes: current model, all models,
and user-specified models. See the sample setup above for some common mappings.

```lua

-- In Lua
require('dbtpal').run()
require('dbtpal').run_all()
require('dbtpal').run_model('+my_second_dbt_model')

require('dbtpal').test()
require('dbtpal').test_all()
require('dbtpal').test_model('+my_second_dbt_model')

require('dbtpal').compile()
require('dbtpal').build()


require('dbtpal').run_command('ls')

```

###  Configuration

You can override default configuration options by passing a table to `setup({})`

```
require("dbtpal").setup({ ... })
```

The following settings are available. Override these in the setup function
above.

```lua
global_settings = {
    path_to_dbt = "dbt",
    path_to_dbt_project = "", -- auto-detects by default
    path_to_dbt_profiles_dir = "~/.dbt/",
}
```

### 📚Commands

```lua
local dbt = require("dbtpal")

dbt.run() -- run the currently open file as a model
dbt.run_model("my_model") -- run an arbitrary model
dbt.run_model("+my_model tag:nightly") -- run an arbitrary model using selectors
dbt.run_all()

dbt.test()
dbt.test_model("my_model")

dbt.compile() -- compiles the model and opens a scratch buffer with the results
dbt.compile_model("my_model")

dbt.build() -- unlike run and test, this builds the entire project
dbt.build_model("my_model") -- builds a specific model

dbt.run_command("seed") -- runs an arbitrary dbt command
```
