local UC = {}

    function UC.load()
        UC.units = {}
        UC.idleUnits= {}
        UC.init()
        UnitSelector.load()
        UnitOrders.load()
    end

    function UC.init()
        UC.addUnit(Vector(10,10), 10)
        UC.addUnit(Vector(11,10), 10)
        UC.addUnit(Vector(12,10), 10)
        UC.addUnit(Vector(10,11), 10)
    end

    function UC.addUnit(coordinate, hp)
        local unit = Unit.new(coordinate, hp)
        table.insert(UC.units, unit)
        if DEBUG then
            unit.select()
        end
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
        print (index)
        if index ~= -1 and idle == false then
            table.remove(UC.idleUnits, index)
        end
        if idle == true and index == -1 then
            print("set idle")
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

return UC