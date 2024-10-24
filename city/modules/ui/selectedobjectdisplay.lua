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

    function S.rightClickAction(args)
        args[1].removeRunningAction(args[2])
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
        local element = GuiController.addElement(name, "S", GuiController.selectedX, y, GuiController.objectSize, GuiController.objectSize, S.clickObject, nil, obj, nil, nil)
        table.insert(S.elements, element)

        if obj.data == nil then return end

        local x = GuiController.actionsX
        if obj.data.actions == nil then return end
        for index, action in ipairs(obj.data.actions) do
            local show = true

            if action.type == ActionType.TECH then                              -- TODO: DIT IN EEN APPARTE FUNCTIE ZETTEN. BEPALEN WAT SHOW WORDT
                if TechController.isDiscovered(action.researchTech) then
                    show= false 
                else
                    local researching = TechController.isResearching(action.researchTech)
                    if researching == true then
                        local r, aantal = obj.getActiveRunningActionsProgress(action)
                        if aantal == 0 then
                            show = false
                        end
                    end
                end
            end

            if show == true then
                local element = GuiController.addElement(action.name, "A", x, y, GuiController.objectSize, GuiController.objectSize, S.clickAction, S.rightClickAction, {obj, action}, action.icon, nil)
                table.insert(S.elements, element)
                x = x + GuiController.objectSize + GuiController.objectMargin
            end
        end
    end

    function S.clear()
        for index, elm in ipairs(S.elements) do
            GuiController.removeElement(elm)
        end
        S.elements = {}
    end

return S