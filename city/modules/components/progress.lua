local Progress = {}

    function Progress.new(parent, max, func)        -- TODO: signal voor als het gedaan is
        local p = {}

        p.parent = parent
        p.current = 0
        p.max = max
        p.func = func

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
            print(p.func)
            if p.func ~= nil then
                p.func()
            end
        end

        return p
    end

return Progress