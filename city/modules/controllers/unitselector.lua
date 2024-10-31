local US = {}

    function US.load()
        US.selectedUnits = {}
        US.idleIndex = 1
        US.controlGroups={
            {},
            {},
            {},
            {},
            {},
            {},
            {},
            {},
            {},
            {}
        }
        US.updateUI = false
    end

    function US.update()
        if US.updateUI == true then
            ControlGroupDisplay.update()
            US.updateUI = false
        end
    end

    function US.select(unit)
        -- local unit = UnitController.getUnitOnCoordinate(MousePointer.mouseGridPosition)
        if unit == nil  then
            US.deselectAll()
            return
        end
        if not love.keyboard.isDown(Settings.select.multi[1]) and not love.keyboard.isDown(Settings.select.multi[2]) then
            US.deselectAll()
            unit.select()  
        else
            if unit.selected then
                unit.deselect()
            else
                unit.select()
            end
        end
    end

    function US.deselectAll()
        while #US.selectedUnits>0 do
            US.selectedUnits[1].selected=false
            table.remove(US.selectedUnits, 1)
        end
        BuildingControllerDisplay.clearElements()
        --SelectedObjectDisplay.clear()
    end

    function US.findNodeAround(coordinate, unit)
        local options = {}
        US.addNodeToTable(options, Vector(coordinate.x-1, coordinate.y-1), unit)
        US.addNodeToTable(options, Vector(coordinate.x, coordinate.y-1), unit)
        US.addNodeToTable(options, Vector(coordinate.x+1, coordinate.y-1), unit)
        US.addNodeToTable(options, Vector(coordinate.x-1, coordinate.y), unit)
        US.addNodeToTable(options, Vector(coordinate.x+1, coordinate.y), unit)
        US.addNodeToTable(options, Vector(coordinate.x-1, coordinate.y+1), unit)
        US.addNodeToTable(options, Vector(coordinate.x, coordinate.y+1), unit)
        US.addNodeToTable(options, Vector(coordinate.x+1, coordinate.y+1), unit)

        if #options == 0 then return nil end

        -- for index, value in ipairs(options) do
        --     print (value.x..":"..value.y)
        -- end

        return options[1]   -- TODO: bepalen hoe bepaald wordt welke destination hij dan kiest. Nu gewoon de eerste
    end

    function US.addNodeToTable(targetTable, coordinate, unit)
        local node = Map.isNodeWalkable(coordinate)
        if node ~=nil then
            if US.nodeAvailable(coordinate, unit) == true then
                table.insert(targetTable, node)
            end
        end
        return targetTable
    end

    function US.moveSelected(coordinate)
        if #US.selectedUnits <=0 then return end
        -- if BuildingController.currentBuilding ~= nil then return end
        local tile = Map.getTileInfo(coordinate)
        if tile == nil then return end

        if #US.selectedUnits > 1 or BuildingController.currentBuilding ~= nil or tile.walkable == false then 
            US.getNeighbours(coordinate)
        end

        if BuildingController.currentBuilding ~= nil then
            US.setBuildingTarget(tile)
            return
        end

        -- for index, unit in ipairs(US.selectedUnits) do
        --     local availableNode = US.nodeAvailable(coordinate, unit)
        --     if availableNode ==true then
        --         US.setTarget(unit, coordinate)
        --         unit.setPath(coordinate)
        --     else
        --         local destination = US.findNodeAround(coordinate, unit)
        --         if destination ~=nil then
        --             US.setTarget(unit, destination)
        --             unit.tree = unit.idleTree
        --             unit.setPath(destination)
        --         end
        --     end
        -- end        
    end

    function US.getNeighbours(coordinate)
        US.options = {}
        table.insert(US.options, Vector(coordinate.x-1, coordinate.y-1))
        table.insert(US.options, Vector(coordinate.x, coordinate.y-1))
        table.insert(US.options, Vector(coordinate.x+1, coordinate.y-1))
        table.insert(US.options, Vector(coordinate.x-1, coordinate.y))
        table.insert(US.options, Vector(coordinate.x+1, coordinate.y))
        table.insert(US.options, Vector(coordinate.x-1, coordinate.y+1))
        table.insert(US.options, Vector(coordinate.x, coordinate.y+1))
        table.insert(US.options, Vector(coordinate.x+1, coordinate.y+1))
    end

    function US.setBuildingTarget(tile)
        for index, unit in ipairs(US.selectedUnits) do
            unit.setTree(BTDatabase.Builder)
            unit.tree.setTarget(tile.newBuilding)
            unit.setTarget(tile.newBuilding)
            local destination = US.findNodeAround(tile.coordinate, unit)
            if destination ~=nil then
                US.setTarget(unit, destination)
                unit.setPath(destination)
            end
        end
    end

    function US.nextIdle()
        US.deselectAll()
        if #UnitController.idleUnits  >= 1 then
            if #UnitController.idleUnits == 1 then
                US.idleIndex = 1
            else
                US.idleIndex =  US.idleIndex + 1
                if US.idleIndex > #UnitController.idleUnits then
                    US.idleIndex = 1
                end
            end
            UnitController.idleUnits[US.idleIndex].select()
            return
        end
        GuiController.setMessage("No idle villager available.")
    end

    function US.controlGroup(key)
        local n = tonumber(key)
        if n == 0 then n= 10 end
        
        if not love.keyboard.isDown(Settings.select.controlGroupSelect[1]) and not love.keyboard.isDown(Settings.select.controlGroupSelect[2]) then
            US.deselectAll()
            for i = 1, #US.controlGroups[n] do
                US.controlGroups[n][i].select()
            end
        else
            US.controlGroups[n] = {}
            for i = 1, #US.selectedUnits do
                table.insert(US.controlGroups[n], US.selectedUnits[i])
            end
            US.updateUI=true
        end
    end

return US