local C = {}

    C.WHITE = {
        r=1,
        g=1,
        b=1,
        a=1
    }

    C.BLACK = {
        r=0,
        g=0,
        b=0,
        a=1
    }

    C.RED = {
        r=1,
        g=0,
        b=0,
        a=1
    }

    C.ORANGE = {
        r = 1,
        g = 0.5, 
        b = 0,
        a = 1
    }

    C.BLUE = {
        r=0,
        g = 0,
        b = 1,
        a = 1
    }

    C.GREY = {
        r=.83,
        g=.83,
        b=.83,
        a=1
    }

    C.currentColour= C.WHITE

    function C.setColour(colour)
        if C.currentColour ~= colour then 
            love.graphics.setColor(colour.r, colour.g, colour.b, colour.a)
            C.currentColour= colour
        end
    end

return C