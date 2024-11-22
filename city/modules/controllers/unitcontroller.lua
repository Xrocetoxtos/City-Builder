local UC = {}

    function UC.load()
        UC.units = {}
        UC.idleUnits= {}
        UC.init()
        UnitSelector.load()
        UnitOrders.load()
    end

    function UC.init()
        -- UC.addUnit(Vector(10,10), 10)
        -- UC.addUnit(Vector(11,10), 10)
        -- UC.addUnit(Vector(12,10), 10)
        UC.addUnit(Vector(10,11), 10)
    end

    function UC.addUnit(coordinate, hp)
        print("created")
        local unit = Unit.new(coordinate, hp)
        table.insert(UC.units, unit)
        -- if DEBUG then
        --     unit.select()
        -- end
        return unit
    end

    function UC.isIdle(unit)
        for index, value in ipairs(UC.idleUnits) do
            if value == unit then
                return index
            end
        end
        return -1
    end

    function UC.setIdle(unit, idle)
        local index = UC.isIdle(unit)
        if index ~= -1 and idle == false then
            table.remove(UC.idleUnits, index)
        end
        if idle == true and index == -1 then
            table.insert(UC.idleUnits, unit)
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

    function UC.update()
        for index, unit in ipairs(UC.units) do
           if unit.delete == true then
                table.remove(UC.units, unit)
           else
                unit.update()
           end
        end
    end

    function UC.draw()
        for index, unit in ipairs(UC.units) do
            unit.draw()
         end
    end
    
    function UC.recruitUnit(coordinate)
        print("unit created")
        local node = UC.findNodeAround(coordinate)
        print(node)
        if node == nil then return false end
        local unit = UC.addUnit(node,10)
        UnitOrders.setTarget(unit, node)
        return true
    end


    function UC.findNodeAround(coordinate)
        local options = {}
        UC.addAvailableNode(options, Vector(coordinate.x-1, coordinate.y-1))
        UC.addAvailableNode(options, Vector(coordinate.x, coordinate.y-1))
        UC.addAvailableNode(options, Vector(coordinate.x+1, coordinate.y-1))
        UC.addAvailableNode(options, Vector(coordinate.x-1, coordinate.y))
        UC.addAvailableNode(options, Vector(coordinate.x+1, coordinate.y))
        UC.addAvailableNode(options, Vector(coordinate.x-1, coordinate.y+1))
        UC.addAvailableNode(options, Vector(coordinate.x, coordinate.y+1))
        UC.addAvailableNode(options, Vector(coordinate.x+1, coordinate.y+1))

        if #options == 0 then 
            UC.addAvailableNode(options, Vector(coordinate.x-2, coordinate.y-2))
            UC.addAvailableNode(options, Vector(coordinate.x-1, coordinate.y-2))
            UC.addAvailableNode(options, Vector(coordinate.x, coordinate.y-2))
            UC.addAvailableNode(options, Vector(coordinate.x+1, coordinate.y-2))
            UC.addAvailableNode(options, Vector(coordinate.x+2, coordinate.y-2))
            UC.addAvailableNode(options, Vector(coordinate.x-2, coordinate.y-1))
            UC.addAvailableNode(options, Vector(coordinate.x+2, coordinate.y-1))
            UC.addAvailableNode(options, Vector(coordinate.x-2, coordinate.y))
            UC.addAvailableNode(options, Vector(coordinate.x+2, coordinate.y))
            UC.addAvailableNode(options, Vector(coordinate.x-2, coordinate.y+1))
            UC.addAvailableNode(options, Vector(coordinate.x+2, coordinate.y+1))

            UC.addAvailableNode(options, Vector(coordinate.x-2, coordinate.y+2))
            UC.addAvailableNode(options, Vector(coordinate.x-1, coordinate.y+2))
            UC.addAvailableNode(options, Vector(coordinate.x, coordinate.y+2))
            UC.addAvailableNode(options, Vector(coordinate.x+1, coordinate.y+2))
            UC.addAvailableNode(options, Vector(coordinate.x+2, coordinate.y+2))
        end
        if #options == 0 then return nil end
        if #options == 1 then return options[1] end

        local ind = love.math.random(#options)
        return options[ind]
    end

    function UC.addAvailableNode(targetTable, coordinate)
        local node = Map.isNodeWalkable(coordinate)
        if node ~=nil then
            if UC.nodeAvailable(coordinate) == true then
                table.insert(targetTable, node)
            end
        end
        return targetTable
    end

    function UC.nodeAvailable(coordinate, unit)
        for index, unitTarget in ipairs(UnitOrders.targets) do
            if unitTarget.target.x == coordinate.x and unitTarget.target.y == coordinate.y and unitTarget.unit ~= nil then
                return false
            end
        end
        return true
    end

return UC