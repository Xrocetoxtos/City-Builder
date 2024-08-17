local MP = {}

function MP.load()
    MP.mouseGridPosition = Vector(0,0)
    MP.pointerPosition = Vector(0,0)
end

function MP.update (dt)
    MP.mouseGridPosition = Map.getGridCoordinate(MOUSE_POSITION)
    MP.pointerPosition = Map.getGridPosition(MP.mouseGridPosition)
    Animations.ui.bonePointerAnimation:update(dt)
end

function MP.draw()
    Animations.ui.bonePointerAnimation:draw(Sprites.ui.bonePointer,MP.pointerPosition.x, MP.pointerPosition.y)
end


function love.mousepressed(x,y,button)
    if button == 1 then
        UnitController.select()
    else 
        if button ==2 then
            UnitController.moveSelected()
        end
    end
end

return MP