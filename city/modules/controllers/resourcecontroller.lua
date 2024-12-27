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
    RC.allResourcesOnMap = {}

    function RC.load()
        -- RC.addResource(Vector(20,18), ResourceDatabase.stone)       
        -- RC.addResource(Vector(21,18), ResourceDatabase.stone)
        -- RC.addResource(Vector(22,18), ResourceDatabase.stone)
        RC.addResource(Vector(18,18), ResourceDatabase.cow_meat)
        -- RC.addResource(Vector(17,18), ResourceDatabase.berry_bush)
        -- RC.addResource(Vector(25,18), ResourceDatabase.apple)
        -- RC.addResource(Vector(25,17), ResourceDatabase.apple)
        -- RC.addResource(Vector(15,15), ResourceDatabase.apple_tree)
    end

    function RC.addResource(vector, data)
        local resource = Resource.new(vector, data)
        local tab= RC.getResourcesTypeTable(data.type)
        if tab ~= nil then
            table.insert(tab, resource)
        end
        table.insert(RC.allResourcesOnMap, resource)
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
        for index, value in ipairs(RC.allResourcesOnMap) do
            if value == r then
                table.remove(RC.allResourcesOnMap,index)
            end
        end
    end

    function RC.findDropLocation(coordinate)
        local options = {}
        RC.addAvailableNode(options, Vector(coordinate.x-1, coordinate.y-1))
        RC.addAvailableNode(options, Vector(coordinate.x, coordinate.y-1))
        RC.addAvailableNode(options, Vector(coordinate.x+1, coordinate.y-1))
        RC.addAvailableNode(options, Vector(coordinate.x-1, coordinate.y))
        RC.addAvailableNode(options, Vector(coordinate.x+1, coordinate.y))
        RC.addAvailableNode(options, Vector(coordinate.x-1, coordinate.y+1))
        RC.addAvailableNode(options, Vector(coordinate.x, coordinate.y+1))
        RC.addAvailableNode(options, Vector(coordinate.x+1, coordinate.y+1))

        if #options < 1 then return nil end

        local rnd = math.random(1, #options)
        return options[rnd]
    end
    
    function RC.addAvailableNode(options, coordinate)
        local node = RC.getResourceOnCoordinate(coordinate)
        if node == nil then
            table.insert(options, coordinate)
        end
        return options
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

    function RC.update()
        for index, resource in ipairs(RC.allResourcesOnMap) do
            resource.update()
        end
        print("xx")
        print(RC.resourcesOnMap.food[1].position)
        -- print(#RC.allResourcesOnMap)
        -- print("------")
        -- for index, value in ipairs(RC.resourcesOnMap.food) do
        --     print(value.data.name)
        --     print(value.coordinate)
        -- end
    end


    function RC.draw()  -- TODO misschien bepaalde types pas tonen als iets uitgevonden is?
        for index, resource in ipairs(RC.allResourcesOnMap) do
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
        position = Map.getGridCoordinate(position)
        if type == nil then return nil end
        print("find " .. type.type)
        if type.type ~= ResourceType.FOOD then
            return RC.findNearestNonFood(type, position, maxDistance)
        end
        return RC.findNearestFood(type, position, maxDistance)
    end

    function RC.findNearestFood(type, position, maxDistance)
        -- print("----")
        -- print("food " ..#RC.resourcesOnMap.food)
        -- print(position)
        if #RC.resourcesOnMap.food <=0 then return nil end

        local distance = maxDistance or 99999999
        local resource = nil
        -- local debugPos = nil
        for index, value in ipairs(RC.resourcesOnMap.food) do

            -- hier wordt de position van resources soms verschoven, mestal y, soms x
            if type == value.data then
                local pos = Vector(value.coordinate.x, value.coordinate.y)
                -- print(value.position)
                -- print("..")
                local dist = pos:dist(position)
                -- print(value.data.name)
                -- print(value.coordinate)
                -- print(value.position)
                -- print(dist)
                if dist < distance then
                    distance = dist
                    resource = value
                    -- debugPos = value.position
                end
            end
        end

        -- print ("--- "..distance)
        -- debug.debug()
        return resource
    end
    
    function RC.findNearestNonFood(type, position, maxDistance)
        local list = RC.getResourcesTypeTable(type.type)
        if list == nil or #list <= 0 then return nil end

        local distance = maxDistance or 99999999
        local resource = nil
        for index, value in ipairs(list) do
            -- local pos = Vector(value.x, value.y)
            -- local dist = pos:dist(position)
            local dist = value.coordinate:dist(position)

            if dist < distance then
                distance = dist
                resource = value
            end
        end
        return resource
    end

    function RC.getResourceOnCoordinate(coordinate)
        if coordinate == nil then return nil end
        for index, resource in ipairs(RC.allResourcesOnMap) do
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
