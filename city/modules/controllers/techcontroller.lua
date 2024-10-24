local T = {}

    T.discovered = {}
    T.researching = {}

    function T.research(tech)
        local d = T.isResearching(tech)
        if d == true then return end

        table.insert(T.researching, tech)
    end

    function T.stopResearching(tech)
        local r = -1
        for index, value in ipairs(T.researching) do
            if value == tech then r=index end
        end
        if r ~= -1 then
            table.remove(T.researching, r)
        end
    end

    function T.isResearching(tech)
        for index, value in ipairs(T.researching) do
            if value == tech then return true end
        end
        return false
    end

    function T.discover(tech)
        local d = T.isDiscovered(tech)
        if d == true then return end

        table.insert(T.discovered, tech)
    end

    function T.isDiscovered(tech)
        for index, value in ipairs(T.discovered) do
            if value == tech then return true end
        end
        return false
    end

    function T.tableDiscovered(t)
        for index, value in ipairs(t) do
            local discovered = T.isDiscovered(value)
            if discovered == false then return false end
        end
        return true
    end

return T
