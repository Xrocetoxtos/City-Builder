local health = {}

    health.new = function(hp, parent)
        local  h  = {}
        h.current = hp
        h.max = hp
        h.parent = parent

        h.getHealth = function()
            return h.current
        end

        h.getHealthRatio = function()
            return h.current/h.max
        end

        h.damage = function(amount)
            h.current = h.current - amount
            if h.current <=0 then
                h.current=0
                h.die()
            end
        end

        h.heal = function (amount)
            h.current = h.current+amount
            if h.current > h.max then
                h.current=h.max
            end
        end

        h.die =function()
            --kill parent
        end

        return h
    end

return health