local Progress = {}

    function Progress.new(parent, max, func, arg)        -- TODO: signal voor als het gedaan is
        local p = {}

        p.parent = parent
        p.current = 0
        p.max = max
        p.func = func or nil
        p.args =  arg

        -- print("-----")
        -- print (arg)
        -- print("-----")

        p.reset =function()
            p.current = 0
        end

        p.progress = function (amount)
            p.current = p.current + amount
            if p.current >= p.max then
                p.finish()
            end
        end

        p.finish = function ()                      -- TODO: signal naar parent
            if p.func ~= nil then
                p.func(p.args)
            end
        end

        p.procent = function()
            return p.current/p.max
        end

        return p
    end

return Progress