local RCD = {}

    function RCD.draw()
        Colours.setColour(Colours.GREY)
        love.graphics.rectangle("fill",0,0,SCREEN_WIDTH, 20)

        Colours.setColour(Colours.BLACK)
        love.graphics.print(ResourceController.wood, 30, 2)
        love.graphics.print(ResourceController.gold, 110, 2)
        love.graphics.print(ResourceController.stone, 190, 2)
        love.graphics.print(ResourceController.wood, 270, 2)

        Colours.setColour(Colours.WHITE)

        love.graphics.draw(Sprites.ui.resources.image, Sprites.ui.resources.types[1], 8,2)
        love.graphics.draw(Sprites.ui.resources.image, Sprites.ui.resources.types[2], 88,2)
        love.graphics.draw(Sprites.ui.resources.image, Sprites.ui.resources.types[3], 168,2)
        love.graphics.draw(Sprites.ui.resources.image, Sprites.ui.resources.types[4], 248,2)

        
    end


return RCD