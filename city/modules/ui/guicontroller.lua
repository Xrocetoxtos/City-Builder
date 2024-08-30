local GC = {}

    function GC.load()
        GC.elements = {}
        GC.activeElement = nil
        BuildingControllerDisplay.load()

        GC.addElement("test", 100, 100, 100, 150, nil, nil)
    end

    function GC.addElement(title, x, y, width, height, func, args)
        local element = {
            title = title,
            x = x,
            y = y,
            width = width,
            height = height,
            func = func,
            args = args
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
            love.graphics.rectangle("line",element.x,element.y,element.width, element.height)
        end
    end

return GC