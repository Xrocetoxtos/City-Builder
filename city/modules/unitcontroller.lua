local UC = {}

    function UC.load()
        UC.units = {}
        -- local position = Map.getGridPosition(Vector(10,10))
        -- UC.addUnit(position + Map.halfTile)
        -- local position = Map.getGridPosition(Vector(13,11))
        -- UC.addUnit(position + Map.halfTile)
        UC.addUnit(Vector(10,10))
        UC.addUnit(Vector(13,11))
    end

    
    function UC.addUnit(coordinate)
        local unit = Unit.new(coordinate)
        table.insert(UC.units, unit)
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

        print( "------")
        print(coordinate.x.. ":"..coordinate.y)
        for index, unit in ipairs(UC.units) do
            if unit.coordinate == coordinate then
                print("found one")
                return unit
            end 
         end
    end

return UC