local C = {}

    C.amounts = {0,0,0,0,0,0,0,0,0,0}

    C.elementSize = 32
    C.elementMargin = 4
    C.elementY = ResourceControllerDisplay.barHeight + C.elementMargin

    function C.update()
        for i = 1, #UnitSelector.controlGroups do
            C.amounts = #UnitSelector.controlGroups[i]
        end
    end

    function C.draw()
        for i = 1, #C.amounts do
            C.drawElement(i)
        end
    end

    function C.drawElement(index)
        local x = SCREEN_WIDTH - ((C.elementMargin + C.elementSize) * (index-1) + C.elementMargin)
        love.graphics.rectangle("line", x, C.elementY, C.elementSize, C.elementSize)
        love.graphics.print(C.amounts[index], x + C.elementMargin, C.elementY + C.elementMargin)
    end

return C