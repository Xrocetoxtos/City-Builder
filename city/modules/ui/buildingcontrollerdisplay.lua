local BCD = {}

    function BCD.load()
        BCD.elements = {}
        BCD.setElements()
    end

    function BCD.clickBuildingType(type)
        BuildingController.selectBuildingType(type)
        BuildingController.getBuildingsByType(type)
        BCD.clearElements()
        BCD.setElements()
    end

    function BCD.clickBuilding(building)
        BuildingController.selectBuilding(building)
    end

    function BCD.clearElements()
        for index, elm in ipairs(BCD.elements) do
            GuiController.removeElement(elm)
        end
        BCD.elements = {}
    end

    function BCD.setElements()

        -- TODO: plek bepalen 
        local x = 400   -- TODO uitrekenen
        for index, bt in ipairs(BuildingTypeDatabase) do
            local element = GuiController.addElement(bt.name, x, 500, 64, 64, BCD.clickBuildingType, bt, bt.image, bt.quad) -- TODO ook iets om een actief element aan te tonen bij het renderen
            x=x+80
            table.insert(BCD.elements, element)
        end
        local x = 400   -- TODO uitrekenen
        for index, building in ipairs(BuildingController.buildings) do
            local element = GuiController.addElement(building.name, x, 400, 32, 32, BCD.clickBuilding, building) -- TODO ook iets om een actief element aan te tonen bij het renderen
            x=x+80
            table.insert(BCD.elements, element)
   
        end
    end

    function BCD.update(dt)


    end

    function BCD.draw()

    end

return BCD