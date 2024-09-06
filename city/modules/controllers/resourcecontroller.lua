local RC = {}

    RC.wood = 100
    RC.gold = 100
    RC.stone = 100
    RC.food = 100

    function RC.hasResources(resource)
        if resource.wood > RC.wood then return false end
        if resource.gold > RC.gold then return false end
        if resource.stone > RC.stone then return false end
        if resource.food > RC.food then return false end
        return true
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