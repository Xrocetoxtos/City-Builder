local BC = {}

    local Types = BuildingTypeDatabase
    local Buildings = BuildingDatabase

    BC.builders = {}
    BC.pendingBuildings = {}

    BC.buildings = {}

    BC.currentBuildingType = nil
    BC.currentBuilding = nil

    function BC.getBuildingsByType(type)
        BC.buildings = {}
        for index, building in ipairs(Buildings) do
            if building.type == type then
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
            BC.currentBuilding = building
        end
        return BC.currentBuilding == building
    end

    function BC.getBuilderByUnit(builder)
        local i = -1
        local record = nil
        for index, unit in ipairs(BC.builders) do
            if unit.unit == builder then
                i=index
                record=unit
            end
        end
        return record, i
    end

    function BC.getBuilderByBuilding(building)
        local i = -1
        local record = nil
        for index, unit in ipairs(BC.builders) do
            if unit.building == building then
                i=index
                record=unit
            end
        end
        return record, i
    end

    function BC.getIdleBuilderUnits()
        local idle = {}
        for index, builder in ipairs(BC.builders) do
            if builder.building == nil then
                table.insert(idle, builder.unit)
            end
        end
        return idle
    end

    function BC.addPendingBuilding(building)
        --check of building al pending is
        -- zo niet, toevoegen
    end

    --TODO: verwijderen buildings en units
    -- TODO: loskoppelen en weer idle/pending maken
    -- TODO: dichtstbijzijnd doel kiezen.


    function BC.addBuilder(builder, building)
        if builder == nil then              -- mag best geen buiulding hebben. dan is het gewoon een builder zonder taak.
            error("Builder is nil")
            return 
        end
        local record, index = BC.getBuilderByUnit(builder)
        if index ~= -1 then
            table.remove(BC.builders, index)
        end
        local newRecord = {
            unit = builder, 
            building = building
        }
        table.insert(BC.builders, newRecord)
    end


return BC