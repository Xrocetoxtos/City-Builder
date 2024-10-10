local S = {}


    S.elements = {}

    function S.clickObject(obj)
        print ("clicked: ")
    end
    
    function S.setup(obj)
        S.clear()
        if obj == nil then return end

        -- object zelf
        local name = "Villager"
        if obj.data ~= nil then
            name = obj.data.name
        end
        local y = SCREEN_HEIGHT - GuiController.objectSize - GuiController.objectMargin * 2
        -- GC.addElement(title, typ, x, y, width, height, func, args, image, quad)


        --FIXME height wordt niet herkend. blijkt nil!
        local element = GuiController.addElement(name, "S", GuiController.selectedX, y, GuiController.objectSize, GuiController.objectSize, S.clickObject, obj, nil, nil) -- TODO ook iets om een actief element aan te tonen bij het renderen
        table.insert(S.elements, element)
    end

    function S.clear()
        for index, elm in ipairs(S.elements) do
            GuiController.removeElement(elm)
        end
        S.elements = {}
    end

return S