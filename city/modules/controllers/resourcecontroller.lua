function getPopulation()
    local pop = 0
    for i = 1, #BuildingController.buildings do
        pop = pop + BuildingController.builders[i].buildingData.population
    end
    return pop
end

local RC = {}

    RC.wood = 100
    RC.gold = 100
    RC.stone = 100
    RC.food = 100

    RC.populationMax = getPopulation()
    RC.population = function() return RC.populationMax - #UnitSelector.selectedUnits end

    RC.resourcesOnMap = {
        wood = {},
        stone = {},
        food = {},
        gold = {}
    }

    function RC.load()
        RC.addResource(Vector(20,18), ResourceDatabase.stone)       
        RC.addResource(Vector(21,18), ResourceDatabase.stone)
        RC.addResource(Vector(22,18), ResourceDatabase.stone)
        RC.addResource(Vector(18,18), ResourceDatabase.cow_meat)
        RC.addResource(Vector(17,18), ResourceDatabase.berry_bush)
        RC.addResource(Vector(25,18), ResourceDatabase.apple)
        RC.addResource(Vector(25,17), ResourceDatabase.apple)
    end

    function RC.addResource(vector, data)
        local resource = Resource.new(vector, data)
        local tab= RC.getResourcesTypeTable(data.type)
        if tab ~= nil then
            table.insert(tab, resource)
        end
    end

    function RC.removeResource(r)
        local t = RC.getResourcesTypeTable(r.data.type)
        if t ~= nil then
            for index, value in ipairs(t) do
                if value == r then
                    table.remove(t,index)
                    Map.pathfindingMap[r.coordinate.y][r.coordinate.x] = 0
                end
            end
        end
    end

    function RC.getResourcesTypeTable(type)
        if type == ResourceType.FOOD then
            return RC.resourcesOnMap.food
            elseif type == ResourceType.GOLD then
                return RC.resourcesOnMap.gold
                elseif type ==ResourceType.STONE then
                    return RC.resourcesOnMap.stone
                    elseif  type == ResourceType.WOOD then
                        return RC.resourcesOnMap.wood
        end
        return nil
    end

    function RC.draw()  -- TODO misschien bepaalde types pas tonen als iets uitgevonden is?
        RC.drawFood()
        RC.drawWood()
        RC.drawStone()
        RC.drawGold()
    end

    function RC.drawFood()
        for index, resource in ipairs(RC.resourcesOnMap.food) do
            resource.draw()
        end
    end

    function RC.drawWood()
        for index, resource in ipairs(RC.resourcesOnMap.wood) do
            resource.draw()
        end
    end

    function RC.drawStone()
        for index, resource in ipairs(RC.resourcesOnMap.stone) do
            resource.draw()
        end
    end

    function RC.drawGold()
        for index, resource in ipairs(RC.resourcesOnMap.gold) do
            resource.draw()
        end
    end

    function RC.getResource(r)
        if r == nil then return nil, -1 end
        local t = RC.getResourcesTypeTable(r.data.type)
        for index, resource in ipairs(t) do
            if resource.id == r.id then
                return resource, index
            end
        end
        return nil, -1
    end

    function RC.findNearestResource(type, position, maxDistance)
        if type == nil then return nil end
        print("find " .. type.type)
        if type.type ~= ResourceType.FOOD then
            return RC.findNearestNonFood(type, position, maxDistance)
        end
        return RC.findNearestFood(type, position, maxDistance)
    end

    function RC.findNearestFood(type, position, maxDistance)
        print("food " ..#RC.resourcesOnMap.food)
        if #RC.resourcesOnMap.food <=0 then return nil end

        local distance = maxDistance or 99999999
        local resource = nil
        for index, value in ipairs(RC.resourcesOnMap.food) do
            -- CHECK OF DIT OVEREEN KOMT.. DIT MOET ZORGEN DAT JE ALTIJD NAAR HETZELFDE TYPE FOOD TERUGKEERT
            if type == value.data then
                local pos = Vector(value.x, value.y)
                local dist = pos:dist(position)
                if dist < distance then
                    distance = dist
                    resource = value
                end
            end
        end
        return resource
    end
    
    function RC.findNearestNonFood(type, position, maxDistance)
        local list = RC.getResourcesTypeTable(type.type)
        if list == nil or #list <= 0 then return nil end

        local distance = maxDistance or 99999999
        local resource = nil
        for index, value in ipairs(list) do
            local pos = Vector(value.x, value.y)
            local dist = pos:dist(position)
            if dist < distance then
                distance = dist
                resource = value
            end
        end
        return resource
    end

    function RC.getResourceOnCoordinate(coordinate)
        if coordinate == nil then return nil end
        for index, resource in ipairs(RC.resourcesOnMap.wood) do
            if resource.coordinate.x == coordinate.x and resource.coordinate.y ==  coordinate.y then
                return resource
            end
        end     

        for index, resource in ipairs(RC.resourcesOnMap.food) do
            if resource.coordinate.x == coordinate.x and resource.coordinate.y ==  coordinate.y then
                return resource
            end
        end     

        for index, resource in ipairs(RC.resourcesOnMap.stone) do
            if resource.coordinate.x == coordinate.x and resource.coordinate.y ==  coordinate.y then
                return resource
            end
        end     

        for index, resource in ipairs(RC.resourcesOnMap.gold) do
            if resource.coordinate.x == coordinate.x and resource.coordinate.y ==  coordinate.y then
                return resource
            end
        end  
        return nil
    end

    function RC.putResourcesOnList(resource)
        local tbl = RC.getResourcesTypeTable(resource.data.type)
        if tbl ~=nil then
            table.insert(tbl.resource)
        end
    end

    function RC.hasResources(resource)
        if resource.wood ~= nil then
            if resource.wood > RC.wood then return false end
        end
        if resource.gold ~= nil then
            if resource.gold > RC.gold then return false end
        end
        if resource.stone ~= nil then
            if resource.stone > RC.stone then return false end
        end
        if resource.food ~= nil then
            if resource.food > RC.food then return false end
        end
        if resource.population ~= nil then
            if resource.population > RC.population() then return false end
        end
        return true
    end

    function RC.hasPopulationSpace(amount)
        print(RC.populationMax.."--" ..amount.. " ".. #UnitController.units)
        return RC.populationMax - amount - #UnitController.units >= 0
    end

    function RC.payResources(resource)
        if not RC.hasResources(resource) then return false end

        RC.wood = RC.wood - resource.wood
        RC.gold = RC.gold - resource.gold
        RC.stone = RC.stone - resource.stone
        RC.food = RC.food - resource.food
        return true
    end

    function RC.addResources(resource)

        if resource == nil then return end 
    
        if resource.wood ~= nil then 
            RC.wood = RC.wood + resource.wood
        end    
        if resource.gold ~= nil then
            RC.gold = RC.gold + resource.gold
        end    
        if resource.stone ~= nil then
            RC.stone = RC.stone + resource.stone
        end    
        if resource.food ~= nil then
            RC.food = RC.food + resource.food
        end
    end


return RC
