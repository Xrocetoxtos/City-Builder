local UC = {}

    function UC.load()
        UC.units = {}
        UC.selectedUnits = {}
        UC.addUnit(Vector(10,10), 10)
        -- UC.addUnit(Vector(13,11), 10)
        
        -- UC.addUnit(Vector(14,11), 10)
        -- UC.addUnit(Vector(15,11), 10)
        -- UC.addUnit(Vector(18,11), 10)

        UC.targets = {} -- houdt bij waar welke unit naartoe loopt
        UC.options = {} -- houdt bij welke mogelijke plekken er beschikbaar zijn voor lopen
    end

    function UC.setTarget(unit, target)
        for index, unitTarget in ipairs(UC.targets) do
            if unitTarget.unit == unit then
                table.remove(UC.targets, index)
                break
            end

            if unitTarget.target.x == target.x and unitTarget.target.y == target.y then
                print("Targeted unitTarget.target is already a targeted target! Target another target or target the targeted target for target practise!")
                unit.cancelPath()
                return false
            end
        end
        table.insert(UC.targets, {unit=unit, target=target})
        return true
    end
    
    function UC.addUnit(coordinate, hp)
        local unit = Unit.new(coordinate, hp)
        table.insert(UC.units, unit)
        if DEBUG then
            unit.select()
        end
    end

    function UC.update(dt)
        for index, unit in ipairs(UC.units) do
           if unit.delete == true then
            table.remove(UC.units, unit)
           else
            unit.update(dt)
           end
        end
    end

    function UC.draw()
        for index, unit in ipairs(UC.units) do
            unit.draw()
         end
    end

    function UC.getUnitOnCoordinate(coordinate)
        if coordinate ==nil then return nil end

        for index, unit in ipairs(UC.units) do
            if unit.coordinate == coordinate then
                return unit
            end 
         end
    end

    function UC.select()
        local unit = UC.getUnitOnCoordinate(MousePointer.mouseGridPosition)
        if unit == nil  then
            UC.deselectAll()
            return
        end
        if not love.keyboard.isDown(Settings.select.multi[1]) and not love.keyboard.isDown(Settings.select.multi[2]) then
            UC.deselectAll()
            unit.select()  
        else
            if unit.selected then
                unit.deselect()
            else
                unit.select()
            end
        end
    end

    function UC.deselectAll()
        while #UC.selectedUnits>0 do
            UC.selectedUnits[1].selected=false
            table.remove(UC.selectedUnits, 1)
        end
    end

    function UC.findNodeAround(coordinate, unit)
        local options = {}
        UC.addNodeToTable(options, Vector(coordinate.x-1, coordinate.y-1), unit)
        UC.addNodeToTable(options, Vector(coordinate.x, coordinate.y-1), unit)
        UC.addNodeToTable(options, Vector(coordinate.x+1, coordinate.y-1), unit)
        UC.addNodeToTable(options, Vector(coordinate.x-1, coordinate.y), unit)
        UC.addNodeToTable(options, Vector(coordinate.x+1, coordinate.y), unit)
        UC.addNodeToTable(options, Vector(coordinate.x-1, coordinate.y+1), unit)
        UC.addNodeToTable(options, Vector(coordinate.x, coordinate.y+1), unit)
        UC.addNodeToTable(options, Vector(coordinate.x+1, coordinate.y+1), unit)

        if #options == 0 then return nil end

        -- for index, value in ipairs(options) do
        --     print (value.x..":"..value.y)
        -- end

        return options[1]   -- TODO: bepalen hoe bepaald wordt welke destination hij dan kiest. Nu gewoon de eerste
    end

    function UC.addNodeToTable(targetTable, coordinate, unit)
        local node = Map.isNodeWalkable(coordinate)
        if node ~=nil then
            if UC.nodeAvailable(coordinate, unit) == true then
                table.insert(targetTable, node)
            end
        end
        return targetTable
    end

    function UC.nodeAvailable(coordinate, unit)
        for index, unitTarget in ipairs(UC.targets) do
            if unitTarget.target.x == coordinate.x and unitTarget.target.y == coordinate.y and unitTarget.unit ~= unit then
                print("Targeted unitTarget.target is already a targeted target! Target another target or target the targeted target for target practise!")
                return false
            end
        end
        return true
    end

    function UC.reconsiderPaths()           -- TODO: kijken of mogelijk is om alleen units die voorbij bepaald punt komen mee te nemen.
        for index, unit in ipairs(UC.units) do
            if unit.pathTarget ~=nil then
                unit.UnitController.reconsiderPaths(unit.pathTarget)
            end
        end
    end

    function UC.moveSelected(coordinate)
        if #UC.selectedUnits <=0 then return end
        -- if BuildingController.currentBuilding ~= nil then return end
        local tile = Map.getTileInfo(coordinate)
        if tile == nil then return end

        if #UC.selectedUnits > 1 or BuildingController.currentBuilding ~= nil or tile.walkable == false then 
            UC.getNeighbours(coordinate)
            print("XXX")
        end

        if BuildingController.currentBuilding ~= nil then
            UC.setBuildingTarget(tile)
        end

        for index, unit in ipairs(UC.selectedUnits) do
            local availableNode = UC.nodeAvailable(coordinate, unit)
            if availableNode ==true then
                UC.setTarget(unit, coordinate)
                unit.setPath(coordinate)
            else
                local destination = UC.findNodeAround(MousePointer.mouseGridPosition, unit)
                if destination ~=nil then
                    UC.setTarget(unit, destination)
                    unit.tree = nil
                    unit.setPath(destination)
                end
            end
        end        
    end

    function UC.getNeighbours(coordinate)
        UC.options = {}
        table.insert(UC.options, Vector(coordinate.x-1, coordinate.y-1))
        table.insert(UC.options, Vector(coordinate.x, coordinate.y-1))
        table.insert(UC.options, Vector(coordinate.x+1, coordinate.y-1))
        table.insert(UC.options, Vector(coordinate.x-1, coordinate.y))
        table.insert(UC.options, Vector(coordinate.x+1, coordinate.y))
        table.insert(UC.options, Vector(coordinate.x-1, coordinate.y+1))
        table.insert(UC.options, Vector(coordinate.x, coordinate.y+1))
        table.insert(UC.options, Vector(coordinate.x+1, coordinate.y+1))
    end

    function UC.setBuildingTarget(tile)
        for index, unit in ipairs(UC.selectedUnits) do
            print("test")
            unit.setTree(BTDatabase.Builder)
            unit.tree.target = tile.newBuilding
            debug.debug()
            
        end
    end

return UC