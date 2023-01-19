## dbtpal

![image](https://raw.githubusercontent.com/PedramNavid/dbtpal/main/assets/dbt%20model%20run.gif)

-----

### ALERT: This is a work in progress. It is not ready for ANY use.

I do welcome requests and use-cases, so feel free to reach out
on Twitter ([@pdrmnvd](https://twitter.com/pdrmnvd)) or by creating and issue.

-----

dbtpal is the friend you've always wanted when developing
dbt projects.

## ✨Features

- Run dbt commands against the currently open buffer
- Run dbt commands for the entire project
- ??? more to come ???

## ⚡️ Requirements

- Neovim >=0.5.0
- [dbt](https://docs.getdbt.com/dbt-cli/installation) >=1.0.0
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)

## ⚙ Installation

Please do not install this.

Install using your favorite plugin manager:

```vim
Plug 'pdrmnvd/dbtpal'
```
## 🙈 Usage

dbtpal has sensible defaults and can auto-detect project directories based
on the currently open buffer when first run.

Your typical dbt commands are supported in three modes: current model, all models,
and user-specified models.


```vim
dbtpal#run() -- run the model open in the current buffer

dbtpal#run_all() -- run all models in the projects

dbtpal#run_models(selector) -- run the models specified by selector, e.g. "model:my_model"
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
