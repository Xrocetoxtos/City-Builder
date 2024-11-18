local GC = {}


    function GC.load()
        GC.selectedX = 50
        GC.actionsX = 200
        GC.objectSize = 64
        GC.objectMargin = 16
        GC.objectActionNumberpadding = 3

        GC.elements = {}
        GC.activeElement = nil
        BuildingControllerDisplay.load()
        GC.messageTimerMax = 3
        GC.messageHeight = 20
        GC.setMessage("")
        Minimap.load()
    end

    function GC.setMessage(message)
        GC.message = message
        GC.messageTimer = 0
    end

    function GC.addElement(title, typ, x, y, width, height, leftClick, rightClick, args, image, quad)
        local element = {
            title = title,
            type = typ,
            x = x,
            y = y,
            width = width,
            height = height,
            leftClick = leftClick,
            rightClick = rightClick,
            args = args,
            image = image,
            quad = quad
        }
        table.insert(GC.elements, element)
        -- print (element.title.. "  "..element.x.. ":".. element.y.. "   "..element.width..":"..element.height)
       
        return element
    end

    function GC.removeElement(element)
        for index, elm in ipairs(GC.elements) do
            if elm == element then
                table.remove(GC.elements, index)
            end
        end
    end

    function GC.clearAllElements()
        GC.elements = {}
        BuildingControllerDisplay.elements = {}
    end

    function GC.leftClick()
        if GC.activeElement == nil then
            return
        end
        if GC.activeElement.leftClick ~= nil then
            GC.activeElement.leftClick(GC.activeElement.args)
        end
    end

    function GC.rightClick()
        if GC.activeElement == nil then
            return
        end
        if GC.activeElement.rightClick ~= nil then
            GC.activeElement.rightClick(GC.activeElement.args)
        end
    end

    function GC.update()
        if GC.message ~= "" then
            GC.messageTimer = GC.messageTimer + DELTA
            if GC.messageTimer >  GC.messageTimerMax then
                GC.message = ""
            end
        end
        MOUSE_ON_GUI= false
        GC.activeElement=nil
        local x, y = love.mouse.getPosition()
        for index, element in ipairs(GC.elements) do
           if x>=element.x and x<=element.x+element.width and y >= element.y and y<=element.y+element.height then
                MOUSE_ON_GUI=true
                GC.activeElement = element
           end 
        end
        Minimap.update()
    end

    function GC.draw()
        love.graphics.line(SCREEN_WIDTH/2,0, SCREEN_WIDTH/2,SCREEN_HEIGHT)
        for index, element in ipairs(GC.elements) do
            GC.setColour(element)

            love.graphics.rectangle("line",element.x,element.y,element.width, element.height)
            if element.quad ~= nil then
                local x, y, width, height = element.quad:getViewport()
                local size = element.width / width
                love.graphics.draw(element.image, element.quad, element.x, element.y, 0, size)
            else
                if element.image ~= nil then
                    love.graphics.draw(element.image, element.x, element.y)
                else
                    love.graphics.print(element.title, element.x, element.y)
                end
            end      
            
            if element.type == "A" then
                local procent, aantal = element.args[1].getActiveRunningActionsProgress(element.args[2])
                if procent > 0 then
                    local size = (1-procent) * GC.objectSize
                    Colours.setColour(Colours.GREY_50)
                    love.graphics.rectangle("fill", element.x, element.y, GC.objectSize, size)
                    Colours.setColour(Colours.WHITE)
                end
                if aantal > 1 then
                    love.graphics.print(aantal,  element.x + 
                                        GC.objectSize - GC.objectActionNumberpadding - love.graphics.getFont():getWidth(aantal), 
                                        element.y + GC.objectSize - GC.objectActionNumberpadding - love.graphics.getFont():getHeight()) 
                end
            end
        end

        ResourceControllerDisplay.draw()
        ControlGroupDisplay.draw()
        GC.drawMessage()

        Minimap.draw()
        love.graphics.print(#UnitController.idleUnits,  SCREEN_WIDTH - 30, SCREEN_HEIGHT - GC.messageHeight) 
        Colours.setColour(Colours.WHITE)
    end

    function GC.drawMessage()
        Colours.setColour(Colours.GREY)
        love.graphics.rectangle("fill",0,SCREEN_HEIGHT-GC.messageHeight ,SCREEN_WIDTH, SCREEN_HEIGHT)

        if GC.message ~= "" then
            Colours.setColour(Colours.RED)
            love.graphics.print(GC.message,  SCREEN_WIDTH * 0.5 - (love.graphics.getFont():getWidth(GC.message) *0.5), SCREEN_HEIGHT - GC.messageHeight) 

        end
        Colours.setColour(Colours.WHITE)
    end

    function GC.setColour(element)
        if element == nil then return end

        if element.type == "B" then
            local available = ResourceController.hasResources(element.args.resource)
            if available == true then
                Colours.setColour(Colours.WHITE)
            else
                Colours.setColour(Colours.RED)
            end
            return
        end

        if element.type == "A" then
            local available = ResourceController.hasResources(element.args[2].resource)
            if available == true then
                Colours.setColour(Colours.WHITE)
            else
                Colours.setColour(Colours.RED)
            end        
            return
        end
        Colours.setColour(Colours.WHITE)
    end

return GC