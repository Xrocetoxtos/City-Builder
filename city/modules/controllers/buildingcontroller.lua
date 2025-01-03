local BC = {}

    BC.builders = {}
    BC.pendingBuildings = {}
    BC.activeBuildings = {}

    BC.buildings = {}
    -- BC.storages = {}

    BC.currentBuildingType = nil
    BC.currentBuilding = nil

    BC.ghostPosition = Vector(0,0)

    function BC.load()
        BC.addBuilding(Vector(96,160), BuildingDatabase[1], true)
        BC.addBuilding(Vector(160,160), BuildingDatabase[1], true)
    end

    function BC.update()
        BC.updateExisting()
        if #UnitSelector.selectedUnits < 1 then return end

        if BC.currentBuilding ~=nil then
            BC.ghostPosition = MousePointer.pointerPosition
        end
    end

    function BC.updateExisting()
        for index, building in ipairs(BC.activeBuildings) do
            building.update()
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

    function BC.addBuilding(position, data, finished)
        finished = finished or false
        if data == nil or position==nil then return nil end

        local building = Building.new(position, data)
        table.insert(BC.activeBuildings, building)
        if finished == true then
            building.build(9999)
        else
            BC.addPendingBuilding(building)
        end
        return building
    end

    function BC.placeCurrentBuilding()
        if BC.currentBuilding == nil then return end
        if ResourceController.hasResources(BC.currentBuilding.resource) then
            local building = BC.addBuilding(MousePointer.pointerPosition, BC.currentBuilding)
            local tile = Map.getTileInfo(building.coordinate)
            UnitOrders.interactWithTile(tile)
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
                print("tech")
                print(#building.requiredTech)
                local discovered = TechController.tableDiscovered(building.requiredTech)
                if discovered == true then
                    table.insert(BC.buildings, building)
                end
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

        for index, building in ipairs(BC.activeBuildings) do
            if building.coordinate.x == coordinate.x and building.coordinate.y ==  coordinate.y then
                return building
            end
        end

        return nil
    end

    function BC.getPendingBuildingOnCoordinate(coordinate)
        if coordinate == nil then return nil end

        for index, building in ipairs(BC.pendingBuildings) do
            if building.coordinate.x == coordinate.x and building.coordinate.y ==  coordinate.y then
                return building
            end
        end     
        return nil
    end

    function BC.getPendingBuilding(b)
        if b == nil then return nil, -1 end
        for index, building in ipairs(BC.pendingBuildings) do
            if building.id == b.id then
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

    function BC.removePendingBuilding(building)                                           -- TODO. dit gaat nog niet goed, somehow. building is nil?!
        local b, i = BC.getPendingBuilding(building)
        if b~=nil then
            table.remove(BC.pendingBuildings, i)
        end
    end

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
            local pos = Vector(value.x, value.y)
            local dist = pos:dist(position)
            if dist < distance then
                distance = dist
                pBuilding = value
            end
        end
        return pBuilding
    end

    function BC.findNearestStorage(position, maxDistance, storageType)
        if #BC.storages <= 0 then 
            return nil 
        end
        if #BC.storages == 1 and (BC.storages[1].data.storageType == ResourceType.ALL or BC.storages[1].data.storageType == storageType) then
            return BC.pendingBuildings[1]
        end

        local distance = maxDistance or 99999999
        local storage = nil
        for index, value in ipairs(BC.pendingBuildings) do
            if value.data.storageType == ResourceType.ALL or value.data.storageType == storageType then
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

return BC