-- selecteer een building. rechtermuisknop: plaatsen
-- als dan een unit geselecteerd is, maak er een builder van en verwijs hem naar dit gebouw. 
-- anders moet de BT van builders dit zelf oppakken

-- dit script mag veel korter tzt.

local BC = {}

    BC.builders = {}
    BC.pendingBuildings = {}
    BC.activeBuildings = {}

    BC.buildings = {}

    BC.currentBuildingType = nil
    BC.currentBuilding = nil

    BC.ghostPosition = Vector(0,0)

    function BC.load()

    end

    function BC.update(dt)
        if BC.currentBuilding ~=nil then
            BC.ghostPosition = MousePointer.pointerPosition
        end
        for index, building in ipairs(BC.activeBuildings) do
            building.update(dt)
        end
    end

    function BC.draw()
        if BC.currentBuilding ~=nil then
            Utils.drawRect("fill", BC.ghostPosition, Vector(Map.cellSize, Map.cellSize))
        end
        for index, building in ipairs(BC.activeBuildings) do
            building.draw()
        end
    end

    function BC.placeCurrentBuilding()
        if BC.currentBuilding == nil then return end
        if ResourceController.hasResources(BC.currentBuilding.resource) then
            local building = Building.new(MousePointer.pointerPosition, BC.currentBuilding)
            table.insert(BC.activeBuildings, building)
        else
            GuiController.setMessage("Not enough resources to build " ..BC.currentBuilding.name..".")
        end
        if not love.keyboard.isDown(Settings.building.multi[1]) 
        and not love.keyboard.isDown(Settings.building.multi[2])  then
            BC.selectBuilding(nil)
        end
    end

    function BC.getBuildingsByType(type)
        BC.buildings = {}
        for index, building in ipairs(BuildingDatabase) do
            if building.type == type.name then
                table.insert(BC.buildings, building)
            end
        end
    end

    function BC.selectBuildingType(type)
        if BC.currentBuildingType == type then
            BC.currentBuildingType = nil
        else
            BC.currentBuildingType = type
            BC.buildings = BC.getBuildingsByType(type)
        end
        return BC.currentBuildingType == type
    end

    function BC.selectBuilding(building)
        if BC.currentBuilding == building then
            BC.currentBuilding = nil
        else
            if building ~=nil then
                if not ResourceController.hasResources(building.resource) then
                    BC.currentBuilding=nil
                    GuiController.setMessage("Not enough resources to build " ..building.name..".")
                    return
                end
            end
            BC.currentBuilding = building
        end
        return BC.currentBuilding == building
    end

    function BC.getBuildingOnCoordinate(coordinate)
        if coordinate == nil then return nil end

        for index, building in ipairs(BC.pendingBuildings) do
            if building.coordinate.x == coordinate.x and building.coordinate.y ==  coordinate.y then
                return building
            end
        end

        for index, building in ipairs(BC.activeBuildings) do
            if building.coordinate.x == coordinate.x and building.coordinate.y ==  coordinate.y then
                return building
            end
        end

        return nil
    end

    -- function BC.getBuilderByUnit(builder)
    --     for index, unit in ipairs(BC.builders) do
    --         if unit.unit == builder then
    --             return unit, index
    --         end
    --     end
    --     return nil, -1
    -- end

    -- function BC.getBuilderByBuilding(building)
    --     for index, unit in ipairs(BC.builders) do
    --         if unit.building == building then
    --             return unit, index
    --         end
    --     end
    --     return -1, nil
    -- end

    -- function BC.getIdleBuilderUnits()
    --     local idle = {}
    --     for index, builder in ipairs(BC.builders) do
    --         if builder.building == nil then
    --             table.insert(idle, builder.unit)
    --         end
    --     end
    --     return idle
    -- end

    function BC.getPendingBuilding(building)
        for index, building in ipairs(BC.pendingBuildings) do
            if building == building then
                return building, index
            end
        end
        return nil, -1
    end

    function BC.addPendingBuilding(building)
        local pending, i = BC.getPendingBuilding(building)
        if pending == nil then
            table.insert(BC.pendingBuildings, building)
        end
    end

    function BC.removePendingBuilding(building)
        local b, i = BC.getPendingBuilding(building)
        if b~=nil then
            table.remove(BC.pendingBuildings, i)
        end
    end

    -- function BC.addBuilder(builder, building)
    --     if builder == nil then              -- mag best geen building hebben. dan is het gewoon een builder zonder taak.
    --         error("Builder is nil")
    --         return 
    --     end
    --     BC.removeBuilder(builder)

    --     local newRecord = {
    --         unit = builder, 
    --         building = building
    --     }
    --     table.insert(BC.builders, newRecord)
    -- end

    -- function BC.removeBuilder (builder)
    --     local record, index = BC.getBuilderByUnit(builder)
    --     if index ~= -1 then
    --         table.remove(BC.builders, index)
    --     end
    -- end

    -- function BC.detachBuilder(builder)
    --     local attachment, index = BC.getBuilderByUnit(builder)
    --     if attachment ~= nil then
    --         attachment.building = nil
    --         table.insert(BC.pendingBuildings, attachment.building)
    --     end
    -- end

    -- function BC.findNearestIdleUnit(position, maxDistance)
    --     local units = BC.getIdleBuilderUnits()
    --     if #units <= 0 then 
    --         return nil 
    --     end
    --     if #units == 1 then
    --         return units[1]
    --     end

    --     local distance = maxDistance or 99999999
    --     local unit = nil

    --     for index, value in ipairs(units) do
    --         local dist = value.unit.position:dist(position)
    --         if dist < distance then
    --             distance=dist
    --             unit = value.unit
    --         end
    --     end
    --     return unit
    -- end

    function BC.findNearestPendingBuilding(position, maxDistance)
        if #BC.pendingBuildings <= 0 then 
            return nil 
        end
        if #BC.pendingBuildings == 1 then
            return BC.pendingBuildings[1]
        end

        local distance = maxDistance or 99999999
        local pBuilding = nil

        for index, value in ipairs(BC.pendingBuildings) do
            local dist = value.position:dist(position)
            if dist < distance then
                distance=dist
                pBuilding = value
            end
        end
        return pBuilding
    end

return BC