local S = {}


    S.elements = {}

    function S.clickObject(obj)
        print ("clicked: ")
    end

    function S.clickAction(args)
        print(args[1].data.name)
        print("clicked: "..args[2].name)
        
        args[1].addRunningAction(args[2])
        args[1].activateRunningActions()
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
        print (element.title.. "  "..element.x.. ":".. element.y.. "   "..element.width..":"..element.height)

        local x = GuiController.actionsX
        print(#obj.data.actions)
        if obj.data.actions == nil then return end
        for index, action in ipairs(obj.data.actions) do
            local element = GuiController.addElement(action.name, "A", x, y, GuiController.objectSize, GuiController.objectSize, S.clickAction, {obj, action}, action.icon, nil)
            table.insert(S.elements, element)
            print (element.title.. "  "..element.x.. ":".. element.y.. "   "..element.width..":"..element.height)
    
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