local S = {}


    S.elements = {}
    S.currentBuilding = nil

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
        S.currentBuilding = obj
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
            local show = S.showAction(action, obj)

            if show == true then
                local element = GuiController.addElement(action.name, "A", x, y, GuiController.objectSize, GuiController.objectSize, S.clickAction, S.rightClickAction, {obj, action}, action.icon, nil)
                table.insert(S.elements, element)
                x = x + GuiController.objectSize + GuiController.objectMargin
            end
        end
    end

    function S.showAction(action, obj)
        if action.requiredTech ~= nil then
            local req = TechController.isDiscovered(action.requiredTech)
            if req == false then return false end
        end

        if action.type == ActionType.TECH then
            print(action.researchTech)
            if TechController.isDiscovered(action.researchTech) then
                print(action.researchTech.. " is al uitgevonden")
                return false 
            end

            local researching = TechController.isResearching(action.researchTech)
            if researching == true then
                print(action.researchTech.. " is al bezig")

                local r, aantal = obj.getActiveRunningActionsProgress(action)
                print (aantal)
                if aantal == 0 then
                    return false
                end
            end

        elseif action.type == ActionType.UPGRADE then               -- TODO. kijken waarom hij altijd finished lijkt
            if UpgradeController.isFinished(action.researchUpgrade) then
                print(action.researchUpgrade.. " is al uitgevonden")
                return false 
            end

            local researching = UpgradeController.isPending(action.researchUpgrade)
            if researching == true then
                print(action.researchTech.. " is al bezig")

                local r, aantal = obj.getActiveRunningActionsProgress(action)
                print (aantal)
                if aantal == 0 then
                    return false
                end
            end

        end

        return true
    end

    function S.clear()
        for index, elm in ipairs(S.elements) do
            GuiController.removeElement(elm)
        end
        S.elements = {}
    end

return S