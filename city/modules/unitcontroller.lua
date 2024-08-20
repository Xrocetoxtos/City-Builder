local UC = {}

    function UC.load()
        UC.units = {}
        UC.selectedUnits = {}
        UC.addUnit(Vector(10,10))
        UC.addUnit(Vector(13,11))

        UC.targets = {} -- houdt bij waar welke unit naartoe loopt
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
        if not love.keyboard.isDown(Keybinding.select.multi[1]) and not love.keyboard.isDown(Keybinding.select.multi[2]) then
            UC.deselectAll()
        end
        unit.select()  
    end

    function UC.deselectAll()
        while #UC.selectedUnits>0 do
            UC.selectedUnits[1].selected=false
            print("removing - id ".. UC.selectedUnits[1].id)
            table.remove(UC.selectedUnits, 1)
        end
    end

    function UC.findNodeAround(node)
        return nil
        --TODO. een node in 1 kring rondom target.
        -- - bestaat die node?
        -- - zit daar iemand
        -- - is het walkable
    end

    function UC.moveSelected()
        for index, unit in ipairs(UC.selectedUnits) do
            local availableNode = UC.setTarget(unit, MousePointer.mouseGridPosition)
            if availableNode ==true then
                unit.setPath(MousePointer.mouseGridPosition)
            else
                local destination = UC.findNodeAround(MousePointer.mouseGridPosition)
                if destination ~=nil then
                    unit.setPath(destination)

                end
            end
        end        
    end

return UC