function love.load()
    require('startup.require')

    love.graphics.setDefaultFilter("nearest", "nearest")
    -- love.mouse.setVisible(false)

    Map.load()
    Pointer.load(400,400)
end


function love.update(dt)
    MOUSE_POSITION = Vector(love.mouse.getPosition())
    Pointer.update(dt)
    Camera:lookAt(Pointer.position.x, Pointer.position.y)
    Map.update(dt)
end

function love.keyreleased(key)
    if key == "escape" then
        love.event.quit()
    end
end

local function debugDetached()
    if DEBUG == false then return end

    love.graphics.print ("mouse: " .. MOUSE_POSITION.x.." : " .. MOUSE_POSITION.y, 10,10)
    love.graphics.print("grid: ".. Map.mouseGridPosition.x .. " : " .. Map.mouseGridPosition.y, 10,30)
    love.graphics.print("map pointer: ".. Map.pointerPosition.x .. " : " .. Map.pointerPosition.y, 10,50)

    Pointer.debugDetached()
end

local function debugAttached()
    if DEBUG == false then return end

    -- love.graphics.rectangle("line", 100,100,400,500)
    Pointer.debugAttached()
end

function love.draw()
    Camera:attach()
        Map.draw()
        debugAttached()
    Camera:detach()
    debugDetached()
end

