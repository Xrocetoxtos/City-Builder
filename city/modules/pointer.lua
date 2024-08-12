local pointer = {}

function pointer.load(x,y)
    pointer.position = Vector(x,y)
    pointer.standStillVector = Vector(0,0)
    pointer.moveSpeed = 100

    pointer.margin = 50
    pointer.leftTop = Vector(pointer.margin,pointer.margin)
    pointer.rightBottom = Vector(SCREEN_WIDTH-pointer.margin, SCREEN_HEIGHT-pointer.margin)
end

function pointer.update(dt)
    local move = pointer.getMovementInput()
    if move ~=pointer.standStillVector then
        move = move:normalized()
        pointer.position = pointer.position + move*pointer.moveSpeed * dt
    end
end

function pointer.getMovementInput()
    local move = Vector(0,0)
    if mousePosition.x < pointer.leftTop.x 
        or love.keyboard.isDown("a") 
        or love.keyboard.isDown("left") then
        move.x = move.x - 1
    end
    if mousePosition.x > pointer.rightBottom.x 
        or love.keyboard.isDown("d")
        or love.keyboard.isDown("right") then
        move.x = move.x + 1
    end
    if mousePosition.y < pointer.leftTop.y 
        or love.keyboard.isDown("w")
        or love.keyboard.isDown("up") then
        move.y = move.y - 1
    end
    if mousePosition.y > pointer.rightBottom.y 
        or love.keyboard.isDown("s") 
        or love.keyboard.isDown("down") then
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