local MP = {}

function MP.load()
    MP.mouseGridPosition = Vector(0,0)
    MP.pointerPosition = Vector(0,0)
end

function MP.update (dt)
    MP.mouseGridPosition = Map.getGridCoordinate(MOUSE_POSITION)
    MP.pointerPosition = Map.getGridPosition(MP.mouseGridPosition)
    Animations.ui.bonePointerAnimation:update(dt)
    local tile = Map.getTileInfo(MP.mouseGridPosition)
end

function MP.draw()
    Animations.ui.bonePointerAnimation:draw(Sprites.ui.bonePointer,MP.pointerPosition.x, MP.pointerPosition.y,0,Map.scale)
end


function love.mousereleased(x,y,button)
    if button == 1 then
        if MOUSE_ON_GUI == true then
            GuiController.click()
        else
            local tile = Map.getTileInfo(MP.mouseGridPosition)
            if tile ==nil then return end
            if tile.unit ~=nil then
                SelectedObjectDisplay.clear()
                UnitSelector.select(tile.unit)
            else
                if tile.building ~= nil then
                    SelectedObjectDisplay.setup(tile.building)
                    UnitSelector.deselectAll()
                else
                    SelectedObjectDisplay.clear()
                    UnitSelector.deselectAll()
                end
            end
            BuildingController.selectBuilding(nil)
        end
    end
    if button ==2 then
        if MOUSE_ON_GUI == true then

        else                                    -- TODO. beoordelen obv het target wat te doen.
            BuildingController.placeCurrentBuilding()
            --UnitSelector.moveSelected(MP.mouseGridPosition)
            local tile = Map.getTileInfo(MP.mouseGridPosition)
            if tile ~= nil then
                UnitOrders.interactWithTile(tile)
            end
        end
    end
end

return MP