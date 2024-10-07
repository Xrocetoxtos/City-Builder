local BCD = {}

    function BCD.load()
        BCD.typeSize = 64
        BCD.typeMargin = 16
        BCD.buildingSize = 32
        BCD.buildingMargin = 8

        BCD.elements = {}
        -- BCD.setElements()
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
        local x = SCREEN_WIDTH * 0.5 - (BCD.typeMargin + BCD.typeSize) * 0.5 * #BuildingTypeDatabase + BCD.typeMargin * 0.5
        local y = SCREEN_HEIGHT - BCD.typeSize - BCD.typeMargin * 2
        if #BuildingController.buildings < 1 then

            for index, bt in ipairs(BuildingTypeDatabase) do
                local element = GuiController.addElement(bt.name, "BT", x, y, BCD.typeSize, BCD.typeSize, BCD.clickBuildingType, bt, Sprites.ui.building_types.image, bt.quad) -- TODO ook iets om een actief element aan te tonen bij het renderen
                x = x + BCD.typeSize + BCD.typeMargin
                table.insert(BCD.elements, element)
            end
        else
            -- y = y - BCD.typeMargin - BCD.buildingSize
            x = SCREEN_WIDTH * 0.5 - (BCD.buildingMargin + BCD.buildingSize) * 0.5 * #BuildingController.buildings + BCD.buildingMargin * 0.5
            for index, building in ipairs(BuildingController.buildings) do
                local hasResources = ResourceController.hasResources(building.resource)
                local element = GuiController.addElement(building.name, "B", x, y, BCD.buildingSize, BCD.buildingSize, BCD.clickBuilding, building) -- TODO ook iets om een actief element aan te tonen bij het renderen
                x= x + BCD.buildingSize + BCD.buildingMargin
                table.insert(BCD.elements, element)
    
            end
        end
    end

    function BCD.update(dt)


    end

    function BCD.draw()

    end

return BCD