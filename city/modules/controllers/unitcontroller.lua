local UC = {}

    function UC.load()
        UC.units = {}
        UC.init()
        UnitSelector.load()
        UnitOrders.load()
    end

    function UC.init()
        UC.addUnit(Vector(10,10), 10)
    end

    function UC.addUnit(coordinate, hp)
        local unit = Unit.new(coordinate, hp)
        table.insert(UC.units, unit)
        if DEBUG then
            unit.select()
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