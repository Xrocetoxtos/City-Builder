local GC = {}

    function GC.load()
        GC.elements = {}
        GC.activeElement = nil
        BuildingControllerDisplay.load()
        GC.messageTimerMax = 3
        GC.setMessage("")
    end

    function GC.setMessage(message)
        GC.message = message
        GC.messageTimer = 0
    end

    function GC.addElement(title, typ, x, y, width, height, func, args, image, quad)
        local element = {
            title = title,
            type = typ,
            x = x,
            y = y,
            width = width,
            height = height,
            func = func,
            args = args,
            image = image,
            quad = quad
        }
        table.insert(GC.elements, element)
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

    function GC.click()
        if GC.activeElement == nil then
            return
        end
        if GC.activeElement.func ~= nil then
            GC.activeElement.func(GC.activeElement.args)
        end
    end

    function GC.update(dt)
        if GC.message ~= "" then
            GC.messageTimer = GC.messageTimer + dt
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
    end

    function GC.draw()
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
            
            ResourceControllerDisplay.draw()
            GC.drawMessage()
        end
        Colours.setColour(Colours.WHITE)
    end

    function GC.drawMessage()
        Colours.setColour(Colours.GREY)
        love.graphics.rectangle("fill",0,SCREEN_HEIGHT-20 ,SCREEN_WIDTH, SCREEN_HEIGHT)

        if GC.message ~= "" then
            Colours.setColour(Colours.RED)
            love.graphics.print(GC.message,  SCREEN_WIDTH * 0.5 - (love.graphics.getFont():getWidth(GC.message) *0.5), SCREEN_HEIGHT - 20)

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
                return
            end
        end
        Colours.setColour(Colours.WHITE)
    end

return GC