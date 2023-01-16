function P(...)
    local objects = {}
    for i = 1, select('#', ...) do
        local v = select(i, ...)
        table.insert(objects, vim.inspect(v))
    end

    print(table.concat(objects, '\n'))
    return ...
end


describe("dbtpal", function()
    it('can be required', function()
        require('dbtpal')
    end)

    it('can run dbt', function()
        local dbt = require('dbtpal')
        local result = dbt.run()
        P(result)
        assert.are.equal(result.command, "dbt")
        assert.are.equal(result.args[3], "run")
    end)

    it('can run standard dbt commands', function()
        local dbt = require('dbtpal')
        commands = {'run', 'test', 'compile', 'build', 'debug'}
        for _, cmd in ipairs(commands) do
            local result = dbt.run_command(cmd)
            assert.are.equal(result.command, "dbt")
            assert.are.equal(result.args[3], cmd)
        end
    end)

    it('can arbitrary commands', function()
        local dbt = require('dbtpal')
        local result = dbt.run_command("compile", "--models my_model")
        assert.are.equal(result.command, "dbt")
        assert.are.equal(result.args[3], "compile")
        assert.are.equal(result.args[4], "--models")
        assert.are.equal(result.args[5], "my_model")
    end)

end)
