local UO = {}

    function UO.load()
        UO.targets = {} 
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
        if tile.resource~=nil then
            UO.setResourceTargetToTile(tile)
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
            local destination = UO.findNodeAround(tile.coordinate, unit, 1)
            if destination ~=nil then
                UO.setTarget(unit, destination)
                local tree = BTDatabase.Builder.new({unit})
                unit.setTree(tree)
                unit.setPath(destination)
            end
        end
    end

    function UO.setResourceTargetToTile(tile)
        for index, unit in ipairs(UnitSelector.selectedUnits) do
            local destination = UO.findNodeAround(tile.coordinate, unit, 1)
            if destination ~=nil then
                -- local tree = BTDatabase.Gatherer.new({unit, tile.resource.data.type, tile.resource})
                local tree = BTDatabase.Gatherer.new({unit, tile.resource.data, tile.resource})
                unit.setTree(tree)
                UO.setTarget(unit, tile.resource)
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

    function UO.findNodeAround(coordinate, unit, rings)
        local options = {}
        UO.addNodeToTable(options, Vector(coordinate.x-1, coordinate.y-1), unit)
        UO.addNodeToTable(options, Vector(coordinate.x, coordinate.y-1), unit)
        UO.addNodeToTable(options, Vector(coordinate.x+1, coordinate.y-1), unit)
        UO.addNodeToTable(options, Vector(coordinate.x-1, coordinate.y), unit)
        UO.addNodeToTable(options, Vector(coordinate.x+1, coordinate.y), unit)
        UO.addNodeToTable(options, Vector(coordinate.x-1, coordinate.y+1), unit)
        UO.addNodeToTable(options, Vector(coordinate.x, coordinate.y+1), unit)
        UO.addNodeToTable(options, Vector(coordinate.x+1, coordinate.y+1), unit)

        if rings == 1 then
            return UO.pickNode(options,unit)
        end
        UO.addNodeToTable(options, Vector(coordinate.x-2, coordinate.y-2), unit)
        UO.addNodeToTable(options, Vector(coordinate.x-1, coordinate.y-2), unit)
        UO.addNodeToTable(options, Vector(coordinate.x, coordinate.y-2), unit)
        UO.addNodeToTable(options, Vector(coordinate.x+1, coordinate.y-2), unit)
        UO.addNodeToTable(options, Vector(coordinate.x+2, coordinate.y-2), unit)
        UO.addNodeToTable(options, Vector(coordinate.x-2, coordinate.y-1), unit)
        UO.addNodeToTable(options, Vector(coordinate.x+2, coordinate.y-1), unit)
        UO.addNodeToTable(options, Vector(coordinate.x-2, coordinate.y), unit)
        UO.addNodeToTable(options, Vector(coordinate.x+2, coordinate.y), unit)
        UO.addNodeToTable(options, Vector(coordinate.x-2, coordinate.y+1), unit)
        UO.addNodeToTable(options, Vector(coordinate.x+2, coordinate.y+1), unit)
        UO.addNodeToTable(options, Vector(coordinate.x-2, coordinate.y+2), unit)
        UO.addNodeToTable(options, Vector(coordinate.x-1, coordinate.y+2), unit)
        UO.addNodeToTable(options, Vector(coordinate.x, coordinate.y+2), unit)
        UO.addNodeToTable(options, Vector(coordinate.x+1, coordinate.y+2), unit)
        UO.addNodeToTable(options, Vector(coordinate.x+2, coordinate.y+2), unit)

        return UO.pickNode(options, unit)
        -- for index, value in ipairs(options) do
        --     print (value.x..":"..value.y)
        -- end

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

    function UO.pickNode(options, unit)
        if #options == 0 then
            return nil
        end
        return UO.nearestNode(unit.coordinate, options)
    end

    function UO.nearestNode(from, options)
        local node = nil
        local distance = 99999999
        for i = 1, #options do
            local x = math.abs(options[i].x - from.x)
            local y = math.abs(options[i].y - from.y)
            local d = math.sqrt(x*x + y*y)
            if d < distance then
                distance = d
                node = options[i]
            end
        end
        return node
    end

return UO