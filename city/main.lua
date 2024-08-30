function love.load()
    require('startup.require')

    love.graphics.setDefaultFilter("nearest", "nearest")
    love.mouse.setVisible(false)

    Settings.load(nil) -- file
    Map.load()
    Pointer.load(400,400)
    UnitController.load()
    BuildingController.load()
    MousePointer.load()
    GuiController.load()
end


function love.update(dt)
    MOUSE_POSITION.x, MOUSE_POSITION.y = love.mouse.getPosition()

    Pointer.update(dt)
    Camera:lookAt(Pointer.position.x, Pointer.position.y)
    Map.update(dt)
    UnitController.update(dt)
    BuildingController.update(dt)
    MousePointer.update(dt)
    GuiController.update(dt)
end

function love.keyreleased(key)
    if key == Settings.quit then
        love.event.quit()
    end
end

local function debugDetached()
    if DEBUG == false then return end

    love.graphics.print ("mouse: " .. MOUSE_POSITION.x.." : " .. MOUSE_POSITION.y, 10,10)
    love.graphics.print("grid: ".. MousePointer.mouseGridPosition.x .. " : " .. MousePointer.mouseGridPosition.y, 10,30)
    love.graphics.print("map pointer: ".. MousePointer.pointerPosition.x .. " : " .. MousePointer.pointerPosition.y, 10,50)

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
        UnitController.draw()
        BuildingController.draw()
        MousePointer.draw()
        debugAttached()
    Camera:detach()
    GuiController.draw()
    debugDetached()
end

