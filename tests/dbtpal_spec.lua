describe("dbtpal", function()
    it('can be required', function()
        require('dbtpal')
    end)

    it('can run dbt', function()
        local dbt = require('dbtpal')
        local result = dbt.run()
        assert.are.equal(result.command, "dbt")
        assert.are.equal(result.args[3], "run")
    end)

    it('can run standard dbt commands', function()
        local dbt = require('dbtpal')
        commands = { 'run', 'test', 'compile', 'build', 'debug' }
        for _, cmd in ipairs(commands) do
            local result = dbt.run_command(cmd)
            assert.are.equal(result.command, "dbt")
            assert.are.equal(result.args[3], cmd)
        end
    end)

    it('can arbitrary commands with string args', function()
        local dbt = require('dbtpal')

        local result = dbt.run_command("compile", "--models my_model")
        assert.are.equal(result.command, "dbt")
        assert.are.equal(result.args[3], "compile")
        assert.are.equal(result.args[4], "--models")
        assert.are.equal(result.args[5], "my_model")
    end)


    it('can arbitrary commands with table args', function()
        local dbt = require('dbtpal')
        local result = dbt.run_command("compile", { "--models", "my_model" })
        assert.are.equal(result.command, "dbt")
        assert.are.equal(result.args[3], "compile")
        assert.are.equal(result.args[4], "--models")
        assert.are.equal(result.args[5], "my_model")


    end)

end)
