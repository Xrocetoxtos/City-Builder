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
    Animations.ui.bonePointerAnimation:draw(Sprites.ui.bonePointer,MP.pointerPosition.x, MP.pointerPosition.y,0,Map.scale)
end


function love.mousereleased(x,y,button)
    if button == 1 then
        if MOUSE_ON_GUI == false then
            UnitController.select()
        else
            GuiController.click()
        end
    end
    if button ==2 then
        if MOUSE_ON_GUI == true then

        else
            UnitController.moveSelected()
            BuildingController.placeCurrentBuilding()
        end
    end
end

return MP