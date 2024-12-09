local SC = {}

    SC.storages = {}

    function SC.hasStorage(storage)
        for index, value in ipairs(SC.storages) do
            if value == storage then
                return index
            end
        end    
        return -1
    end

    function SC.addStorage(storage)
        local has = SC.hasStorage(storage)
        if has == -1 then
            table.insert(SC.storages, storage)
        end
    end

    function SC.removeStorage(storage)
        local has = SC.hasStorage(storage)
        if has ~= -1 then
            table.remove(SC.storages,has)
        end
    end

    function SC.findNearestStorage(type, position, maxDistance)
        if type == nil then return nil end
        if SC.storages == nil or #SC.storages <= 0 then return nil end
        local distance = maxDistance or 99999999
        local storage = nil
        print (distance)
        for index, value in ipairs(SC.storages) do
            print(index)
            if value.data.storageType == ResourceType.ALL or value.data.storageType ==  type then
                local pos = Vector(value.x, value.y)
                local dist = pos:dist(position)
                print (dist)
                if dist < distance then
                    distance = dist
                    storage = value
                end
            end
        end
        print(storage)
        return storage
    end

return SC
