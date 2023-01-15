## dbtpal

dbtpal is the friend you've always wanted when developing
dbt projects.

ALERT ALERT ALERT

# THIS PROJECT IS IN PROGRESS AND DOESNT WORK

ALERT ALERT ALERT

## Installation

--- instructions go here ---

## Usage

### Configuration


```
require("dbtpal").setup({ ... })
```

### Settings

```lua
global_settings = {
    path_to_dbt = "dbt",
    path_to_dbt_project = ".",
    path_to_dbt_profiles = "~/.dbt/profiles.yml",
}
```

### Commands

```lua
local dbt = require("dbtpal")

dbt.run() -- run the currently open file as a model
dbt.run("my_model") -- run an arbitrary model

dbt.test()
dbt.test("my_model")

dbt.compile() -- compiles the model and opens a scratch buffer with the results
dbt.compile("my_model")

-- You can also use dbt selectors
dbt.run_model("+my_model+")

dbt.build() -- unlike run and test, this builds the entire project
dbt.build("my_model") -- builds a specific model

dbt.run_command("seed") -- runs an arbitrary dbt command
```

### Telescope Extensions

