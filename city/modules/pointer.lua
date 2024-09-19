local pointer = {}

function pointer.load(x,y)

    pointer.position = Vector(x,y)
    pointer.standStillVector = Vector(0,0)
    pointer.moveSpeed = Settings.camera.moveSpeed

    pointer.margin = Settings.camera.panMargin
    pointer.leftTop = Vector(pointer.margin,pointer.margin)
    pointer.rightBottom = Vector(SCREEN_WIDTH-pointer.margin, SCREEN_HEIGHT-pointer.margin - GuiController.messageHeight)
end

function pointer.update(dt)
    local move = pointer.getMovementInput()
    if move ~=pointer.standStillVector then
        move = move:normalized()
        local newPos = pointer.position+move*pointer.moveSpeed * dt
        
        if newPos.x < HALF_WIDTH  then
            newPos.x = HALF_WIDTH
        else
            if newPos.x > (Map.mapWidth - HALF_WIDTH) then
                newPos.x = (Map.mapWidth - HALF_WIDTH)
            end
        end
        if newPos.y < HALF_HEIGHT then
            newPos.y = HALF_HEIGHT
        else
            if newPos.y > (Map.mapHeight - HALF_HEIGHT) then
                newPos.y = (Map.mapHeight - HALF_HEIGHT)
            end
        end     
        if newPos ~= pointer.position then 
            pointer.position = newPos
        end
    end
    -- pointer.getZoomInput(dt)     -- TODO: kijken of dit werkt, want dit werkt door op de positie van alle objecten op de map. niet alleen de grootte
end

-- function pointer.getZoomInput(dt)
--     if love.keyboard.isDown(Settings.camera.zoomIn) then
--         Map.scale = Map.scale + Map.scale*Settings.camera.zoomSpeed*dt
--     end
--     if love.keyboard.isDown(Settings.camera.zoomOut) then
--         Map.scale = Map.scale - Map.scale*Settings.camera.zoomSpeed*dt
--     end
--     if Map.scale > Settings.camera.maxZoom then Map.scale = Settings.camera.maxZoom end
--     if Map.scale < Settings.camera.minZoom then Map.scale = Settings.camera.minZoom end

-- end

function pointer.getMovementInput()
    local move = Vector(0,0)
    if MOUSE_POSITION.x < pointer.leftTop.x and MOUSE_ON_GUI == false
        or love.keyboard.isDown(Settings.camera.left[1]) 
        or love.keyboard.isDown(Settings.camera.left[2]) then
        move.x = move.x - 1
    end
    if MOUSE_POSITION.x > pointer.rightBottom.x and MOUSE_ON_GUI == false
        or love.keyboard.isDown(Settings.camera.right[1])
        or love.keyboard.isDown(Settings.camera.right[2]) then
        move.x = move.x + 1
    end
    if MOUSE_POSITION.y < pointer.leftTop.y and MOUSE_ON_GUI == false
        or love.keyboard.isDown(Settings.camera.up[1])
        or love.keyboard.isDown(Settings.camera.up[2]) then
        move.y = move.y - 1
    end
    if MOUSE_POSITION.y > pointer.rightBottom.y and MOUSE_ON_GUI == false
        or love.keyboard.isDown(Settings.camera.down[1]) 
        or love.keyboard.isDown(Settings.camera.down[2]) then
        move.y = move.y + 1
    end
    return move
end

function pointer.debugDetached()
    love.graphics.rectangle("line", pointer.leftTop.x, pointer.leftTop.y, SCREEN_WIDTH-pointer.margin*2, SCREEN_HEIGHT-pointer.margin*2)
end

function pointer.debugAttached()
    love.graphics.circle("line", pointer.position.x, pointer.position.y, 5)
end

return pointer