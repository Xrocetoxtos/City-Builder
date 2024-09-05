local C = {}

    C.WHITE = {
        r=1,
        g=1,
        b=1,
        a=1
    }

    C.RED = {
        r=1,
        g=0,
        b=0,
        a=1
    }

    C.GREY = {
        r=.83,
        g=.83,
        b=.83,
        a=1
    }

    function C.setColour(colour)
        love.graphics.setColor(colour.r, colour.g, colour.b, colour.a)
    end

return C