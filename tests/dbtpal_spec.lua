describe("dbtpal", function()
    before_each(
        function()
            require("dbtpal").setup({
                path_to_project = "./tests/dbt_project/",
                path_to_profiles_dir = "./tests/dbt_project/",
            })
        end
    )

    it("can be required", function() require("dbtpal") end)

    it("can run dbt", function()
        local dbt = require("dbtpal")
        local result = dbt.run_all()
        assert.are.equal(result.command, "dbt")
        assert.are.equal(result.args[2], "run")
    end)

    it("can run standard dbt commands", function()
        local dbt = require("dbtpal")
        local commands = { "run", "test", "compile", "build", "debug" }
        for _, cmd in ipairs(commands) do
            local result = dbt.run_command(cmd)
            assert.are.equal(result.command, "dbt")
            assert.are.equal(result.args[2], cmd)
        end
    end)

    it("can run arbitrary commands with string args", function()
        local dbt = require("dbtpal")

        local result = dbt.run_command("compile", "--models my_model")
        assert.are.equal(result.command, "dbt")
        assert.are.equal(result.args[2], "compile")
        assert.are.equal(result.args[3], "--models")
        assert.are.equal(result.args[4], "my_model")
    end)

    it("can run arbitrary commands with table args", function()
        local dbt = require("dbtpal")
        local result = dbt.run_command("compile", { "--models", "my_model" })
        assert.are.equal(result.command, "dbt")
        assert.are.equal(result.args[2], "compile")
        assert.are.equal(result.args[3], "--models")
        assert.are.equal(result.args[4], "my_model")
    end)

    it("can run dbt with a model selector", function()
        local dbt = require("dbtpal")
        local result = dbt.run_model("my_model")
        assert.are.equal(result.command, "dbt")
        assert.are.equal(result.args[2], "run")
        assert.are.equal(result.args[3], "--select")
        assert.are.equal(result.args[4], "my_model")
    end)

    it("can run dbt with all models", function()
        local dbt = require("dbtpal")
        local result = dbt.run()
        -- TODO: how to set buf name for test?
        assert.are.equal(result.command, "dbt")
        assert.are.equal(result.args[2], "run")
        assert.are.equal(result.args[3], "--select")
        assert.are.equal(result.args[4], "")
    end)

    it("can run dbt with multiple model selectors", function()
        local dbt = require("dbtpal")
        local result = dbt.run_model("tag:nightly my_model finance.base.*")
        assert.are.equal(result.command, "dbt")
        assert.are.equal(result.args[2], "run")
        assert.are.equal(result.args[3], "--select")
        assert.are.equal(result.args[4], "tag:nightly my_model finance.base.*")
    end)

    it("can run dbt with multiple model selectors in a table", function()
        local dbt = require("dbtpal")
        local result =
            dbt.run_model({ "tag:nightly", "my_model", "finance.base.*" })
        assert.are.equal(result.command, "dbt")
        assert.are.equal(result.args[2], "run")
        assert.are.equal(result.args[3], "--select")
        assert.are.equal(result.args[4], "tag:nightly my_model finance.base.*")
    end)

    it("can run dbt with multiple model selectors and args", function()
        local dbt = require("dbtpal")
        local result = dbt.run_model(
            { "tag:nightly", "my_model", "finance.base.*" },
            { "--full-refresh", "--threads 4" }
        )
        assert.are.equal(result.command, "dbt")
        assert.are.equal(result.args[2], "run")
        assert.are.equal(result.args[3], "--select")
        assert.are.equal(result.args[4], "tag:nightly my_model finance.base.*")
        assert.are.equal(result.args[5], "--full-refresh")
        assert.are.equal(result.args[6], "--threads 4")
    end)

    it("can find the dbt project directory", function()
        local dbt = require("dbtpal.projects")
        local path = "tests/dbt_project/models/example"
        local result = dbt.find_project_dir(path)
        local expect = vim.fn.getcwd() .. "/tests/dbt_project"
        assert.are.equal(result, expect)
    end)
end)
