local US = {}

    function US.load()
        US.selectedUnits = {}

        -- US.targets = {} -- houdt bij waar welke unit naartoe loopt
        -- US.options = {} -- houdt bij welke mogelijke plekken er beschikbaar zijn voor lopen
    end

    -- function US.setTarget(unit, target)
    --     for index, unitTarget in ipairs(US.targets) do
    --         if unitTarget.unit == unit then
    --             table.remove(US.targets, index)
    --             break
    --         end

    --         if unitTarget.target.x == target.x and unitTarget.target.y == target.y then
    --             print("Targeted unitTarget.target is already a targeted target! Target another target or target the targeted target for target practise!")
    --             --unit.cancelPath()
    --             return false
    --         end
    --     end
    --     table.insert(US.targets, {unit=unit, target=target})
    --     return true
    -- end
 
    function US.select()
        local unit = UnitController.getUnitOnCoordinate(MousePointer.mouseGridPosition)
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

    -- function US.nodeAvailable(coordinate, unit)
    --     for index, unitTarget in ipairs(US.targets) do
    --         if unitTarget.target.x == coordinate.x and unitTarget.target.y == coordinate.y and unitTarget.unit ~= unit then
    --             print("Targeted unitTarget.target is already a targeted target! Target another target or target the targeted target for target practise!")
    --             return false
    --         end
    --     end
    --     return true
    -- end

    -- function US.reconsiderPaths()           -- TODO: kijken of mogelijk is om alleen units die voorbij bepaald punt komen mee te nemen.
    --     for index, unit in ipairs(US.units) do
    --         if unit.pathTarget ~=nil then
    --             unit.setPath(unit.pathTarget)
    --         end
    --     end
    -- end

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

return US