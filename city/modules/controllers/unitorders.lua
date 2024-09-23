local UO = {}

    function UO.load()
        UO.targets = {} -- houdt bij waar welke unit naartoe loopt
        --UO.options = {} -- houdt bij welke mogelijke plekken er beschikbaar zijn voor lopen
    end

    function UO.interactWithTile(tile)
        if tile == nil then return end

        if tile.walkable then
            UO.moveUnitsToTile(tile)
            return
        end

        if tile.newBuilding ~= nil then
            UO.setBuildingTargetToTile(tile)
            return
        end
    end

    function UO.moveUnitsToTile(tile)
        for index, unit in ipairs(UnitSelector.selectedUnits) do
            local availableNode = UO.nodeAvailable(tile.coordinate, unit)
            if availableNode ==true then
                UO.setTarget(unit, tile.coordinate)
                unit.setPath(tile.coordinate)
            else
                local destination = UO.findNodeAround(tile.coordinate, unit)
                if destination ~=nil then
                    UO.setTarget(unit, destination)
                    unit.tree = unit.idleTree
                    unit.setPath(destination)
                end
            end
        end  
    end

    function UO.setBuildingTargetToTile(tile)
        for index, unit in ipairs(UnitSelector.selectedUnits) do
            local destination = UO.findNodeAround(tile.coordinate, unit)
            if destination ~=nil then
                UO.setTarget(unit, destination)
                unit.tree = BTDatabase.Builder.new(unit)
                unit.setPath(destination)
            end
        end
    end

    function UO.setTarget(unit, target)
        for index, unitTarget in ipairs(UO.targets) do
            if unitTarget.unit == unit then
                table.remove(UO.targets, index)
                break
            end

            if unitTarget.target.x == target.x and unitTarget.target.y == target.y then
                print("Targeted unitTarget.target is already a targeted target! Target another target or target the targeted target for target practise!")
                unit.cancelPath()
                return false
            end
        end
        table.insert(UO.targets, {unit=unit, target=target})
        return true
    end

    function UO.reconsiderPaths()           -- TODO: kijken of mogelijk is om alleen units die voorbij bepaald punt komen mee te nemen.
        for index, unit in ipairs(UnitController.units) do
            if unit.pathTarget ~=nil then
                unit.setPath(unit.pathTarget)
            end
        end
    end

    function UO.nodeAvailable(coordinate, unit)
        for index, unitTarget in ipairs(UO.targets) do
            if unitTarget.target.x == coordinate.x and unitTarget.target.y == coordinate.y and unitTarget.unit ~= unit then
                print("Targeted unitTarget.target is already a targeted target! Target another target or target the targeted target for target practise!")
                return false
            end
        end
        return true
    end

    function UO.findNodeAround(coordinate, unit)
        local options = {}
        UO.addNodeToTable(options, Vector(coordinate.x-1, coordinate.y-1), unit)
        UO.addNodeToTable(options, Vector(coordinate.x, coordinate.y-1), unit)
        UO.addNodeToTable(options, Vector(coordinate.x+1, coordinate.y-1), unit)
        UO.addNodeToTable(options, Vector(coordinate.x-1, coordinate.y), unit)
        UO.addNodeToTable(options, Vector(coordinate.x+1, coordinate.y), unit)
        UO.addNodeToTable(options, Vector(coordinate.x-1, coordinate.y+1), unit)
        UO.addNodeToTable(options, Vector(coordinate.x, coordinate.y+1), unit)
        UO.addNodeToTable(options, Vector(coordinate.x+1, coordinate.y+1), unit)

        if #options == 0 then return nil end

        -- for index, value in ipairs(options) do
        --     print (value.x..":"..value.y)
        -- end

        return options[1]   -- TODO: bepalen hoe bepaald wordt welke destination hij dan kiest. Nu gewoon de eerste
    end

    function UO.addNodeToTable(targetTable, coordinate, unit)
        local node = Map.isNodeWalkable(coordinate)
        if node ~=nil then
            if UO.nodeAvailable(coordinate, unit) == true then
                table.insert(targetTable, node)
            end
        end
        return targetTable
    end

return UO