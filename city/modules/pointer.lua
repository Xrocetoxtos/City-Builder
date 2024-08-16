local pointer = {}

function pointer.load(x,y)

    pointer.position = Vector(x,y)
    pointer.standStillVector = Vector(0,0)
    pointer.moveSpeed = Keybinding.camera.moveSpeed

    pointer.margin = Keybinding.camera.panMargin
    pointer.leftTop = Vector(pointer.margin,pointer.margin)
    pointer.rightBottom = Vector(SCREEN_WIDTH-pointer.margin, SCREEN_HEIGHT-pointer.margin)
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
        -- print(newPos.x..":"..newPos.y.." --> " ..pointer.position.x..":"..pointer.position.y)
    end
end

function pointer.getMovementInput()
    local move = Vector(0,0)
    if MOUSE_POSITION.x < pointer.leftTop.x 
        or love.keyboard.isDown(Keybinding.camera.left[1]) 
        or love.keyboard.isDown(Keybinding.camera.left[2]) then
        move.x = move.x - 1
    end
    if MOUSE_POSITION.x > pointer.rightBottom.x 
        or love.keyboard.isDown(Keybinding.camera.right[1])
        or love.keyboard.isDown(Keybinding.camera.right[2]) then
        move.x = move.x + 1
    end
    if MOUSE_POSITION.y < pointer.leftTop.y 
        or love.keyboard.isDown(Keybinding.camera.up[1])
        or love.keyboard.isDown(Keybinding.camera.up[2]) then
        move.y = move.y - 1
    end
    if MOUSE_POSITION.y > pointer.rightBottom.y 
        or love.keyboard.isDown(Keybinding.camera.down[1]) 
        or love.keyboard.isDown(Keybinding.camera.down[2]) then
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