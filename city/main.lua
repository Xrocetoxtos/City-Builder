function love.load()
    require('startup.require')

    love.graphics.setDefaultFilter("nearest", "nearest")

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

