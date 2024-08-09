local pointer = {}

function pointer.load(x,y)
    pointer.position = Vector(x,y)
    pointer.moveSpeed = 100
    
    pointer.leftTop = Vector(20,20)
    pointer.rightBottom = Vector(SCREEN_WIDTH-20, SCREEN_HEIGHT-20)
end

function pointer.update(dt)
    pointer.mouseMovement(dt)
end

function pointer.mouseMovement(dt)
    
    if mousePosition.x < pointer.leftTop.x then
        pointer.position.x = pointer.position.x - pointer.moveSpeed*dt
    end
    if mousePosition.x > pointer.rightBottom.x then
        pointer.position.x = pointer.position.x + pointer.moveSpeed*dt
    end
    if mousePosition.y < pointer.leftTop.y then
        pointer.position.y = pointer.position.y - pointer.moveSpeed*dt
    end
    if mousePosition.y > pointer.rightBottom.y then
        pointer.position.y = pointer.position.y + pointer.moveSpeed*dt
    end
end

function pointer.draw()
    love.graphics.circle("line", pointer.position.x, pointer.position.y, 5)
end

return pointer