local U = {}

    function U.drawRect(type, pos, size)
        love.graphics.rectangle(type, pos.x, pos.y, size.x, size.y)
    end

return U