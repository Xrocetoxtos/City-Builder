local SC = {}

    SC.storages = {}

    function SC.addStorage(storage)

    end

    function SC.removeStorage(storage)

    end

    function SC.findNearestStorage(type, position, maxDistance)
        if type == nil then return nil end

        if SC.storages == nil or #SC.storages <= 0 then return nil end

        local distance = maxDistance or 99999999
        local storage = nil
        for index, value in ipairs(SC.storages) do
            if value.data.storageType == ResourceType.ALL or value.data.storageType ==  type then
                local pos = Vector(value.x, value.y)
                local dist = pos:dist(position)
                if dist < distance then
                    distance = dist
                    storage = value
                end
            end
        end
        return storage
    end

return SC

-- TODO. NOG TOEVOEGEN AAN LIJST