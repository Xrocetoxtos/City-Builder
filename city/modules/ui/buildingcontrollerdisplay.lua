local BCD = {}

    function BCD.load()
        BCD.setElements()
    end

    function BCD.clickBuildingType(type)
        print("----")
        print(type.name)
    end

    function BCD.setElements()
        local x = 400   -- TODO uitrekenen
        for index, bt in ipairs(BuildingTypeDatabase) do
            GuiController.addElement(bt.name, x, 500, 64, 64, BCD.clickBuildingType, bt)
            x=x+80
        end
    end

    function BCD.update(dt)

    end

    function BCD.draw()

    end

return BCD