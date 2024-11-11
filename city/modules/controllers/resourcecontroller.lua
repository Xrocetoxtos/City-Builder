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

    RC.resources = {}

    function RC.load()
        RC.addResource(Vector(20,18), ResourceDatabase.wood)
    end

    function RC.addResource(vector, data)
        local resource = Resource.new(vector, data)
        table.insert(RC.resources, resource)
    end

    function RC.draw()
        for index, resource in ipairs(RC.resources) do
            resource.draw()
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
