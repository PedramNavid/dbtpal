describe("dbtpal", function()
    before_each(
        function()
            require("dbtpal").setup {
                path_to_dbt_project = "./tests/dbt_project/",
                path_to_dbt_profiles_dir = "./tests/dbt_project/",
            }
        end
    )

    it("can be required", function() require "dbtpal" end)

    it("can run dbt", function()
        local dbt = require "dbtpal"
        local result = dbt.run_all()
        assert.are.equal(result.command, "dbt")
        assert.True(table.concat(result.args, " "):find "run" ~= nil)
    end)

    it("can run standard dbt commands", function()
        local dbt = require "dbtpal"
        local commands = { "run", "test", "compile", "build", "debug" }
        for _, cmd in ipairs(commands) do
            local result = dbt.run_command(cmd)
            assert.are.equal(result.command, "dbt")
            assert.True(table.concat(result.args, " "):find(cmd) ~= nil)
        end
    end)

    it("can run arbitrary commands with string args", function()
        local dbt = require "dbtpal"

        local result = dbt.run_command("compile", "--models my_model")
        assert.are.equal(result.command, "dbt")

        for _, cmd in ipairs { "compile", "--models", "my_model" } do
            assert.True(table.concat(result.args, " "):find(cmd) ~= nil)
        end
    end)

    it("can run arbitrary commands with table args", function()
        local dbt = require "dbtpal"
        local result = dbt.run_command("compile", { "--models", "my_model" })
        assert.are.equal(result.command, "dbt")
        for _, cmd in ipairs { "compile", "--models", "my_model" } do
            assert.True(table.concat(result.args, " "):find(cmd) ~= nil)
        end
    end)

    it("can run dbt with a model selector", function()
        local dbt = require "dbtpal"
        local result = dbt.run_model "my_model"
        assert.are.equal(result.command, "dbt")

        for _, cmd in ipairs { "run", "--select", "my_model" } do
            assert.True(table.concat(result.args, " "):find(cmd) ~= nil)
        end
    end)

    it("can run dbt with all models", function()
        local dbt = require "dbtpal"
        local result = dbt.run()
        -- TODO: how to set buf name for test?
        assert.are.equal(result.command, "dbt")
        assert.True(table.concat(result.args, " "):find "run" ~= nil)
    end)

    it("can run dbt with multiple model selectors", function()
        local dbt = require "dbtpal"
        local result = dbt.run_model "tag:nightly my_model finance.base.*"
        assert.are.equal(result.command, "dbt")
        for _, cmd in ipairs {
            "run",
            "--select",
            "tag:nightly my_model finance.base.*",
        } do
            assert.True(table.concat(result.args, " "):find(cmd) ~= nil)
        end
    end)

    it("can run dbt with multiple model selectors in a table", function()
        local dbt = require "dbtpal"
        local result = dbt.run_model { "tag:nightly", "my_model", "finance.base.*" }
        for _, cmd in ipairs {
            "run",
            "--select",
            "tag:nightly my_model finance.base.*",
        } do
            assert.True(table.concat(result.args, " "):find(cmd) ~= nil)
        end
    end)

    it("can run dbt with multiple model selectors and args", function()
        local dbt = require "dbtpal"
        local result = dbt.run_model(
            { "tag:nightly", "my_model", "finance.base.*" },
            { "--full-refresh", "--threads 4" }
        )

        for _, cmd in ipairs {
            "run",
            "--select",
            "tag:nightly",
            "my_model",
            "finance.base.*",
            "--full%-refresh",
            "--threads 4",
        } do
            assert.True(table.concat(result.args, " "):find(cmd) ~= nil)
        end
        assert.are.equal(result.command, "dbt")
    end)

    it("can find the dbt project directory", function()
        local dbt = require "dbtpal.projects"
        local path = "tests/dbt_project/models/example"
        local result = dbt.detect_dbt_project_dir(path)
        assert(result)
        local expect = vim.fn.getcwd() .. "/tests/dbt_project"
        assert.are.equal(require("dbtpal.config").options.path_to_dbt_project, expect)
    end)
end)
