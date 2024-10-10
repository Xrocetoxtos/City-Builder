local S = {}


    S.elements = {}

    function S.clickObject(obj)
        print ("clicked: ")
    end

    function S.clickAction(args)
        print("clicked: "..args[2].name)
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
        local element = GuiController.addElement(name, "S", GuiController.selectedX, y, GuiController.objectSize, GuiController.objectSize, S.clickObject, obj, nil, nil)
        table.insert(S.elements, element)

        local x = GuiController.actionsX
        if obj.actions == nil then return end
        for index, action in ipairs(obj.actions) do
            local element = GuiController.addElement(action.name, "A", x, y, GuiController.objectSize, GuiController.objectSize, S.clickAction, {obj, action}, action.icon, nil)
            table.insert(S.elements, element)
              
            x = x + GuiController.objectSize + GuiController.objectMargin
        end
    end

    function S.clear()
        for index, elm in ipairs(S.elements) do
            GuiController.removeElement(elm)
        end
        S.elements = {}
    end

return S