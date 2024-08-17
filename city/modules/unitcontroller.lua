local UC = {}

    function UC.load()
        UC.units = {}
        UC.selectedUnits = {}
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

    function UC.select()
        if not love.keyboard.isDown(Keybinding.select.multi[1]) and not love.keyboard.isDown(Keybinding.select.multi[2]) then
            UC.deselectAll()
        end
        local unit = UC.getUnitOnCoordinate(MousePointer.mouseGridPosition)
        if unit then
            unit.toggleSelected()
        end    
    end

    function UC.deselectAll()
        for index, unit in ipairs(UC.selectedUnits) do
            unit.toggleSelected()
        end
    end

    function UC.moveSelected()
        for index, unit in ipairs(UC.selectedUnits) do
            unit.setPath(MousePointer.mouseGridPosition)
        end        
    end

return UC