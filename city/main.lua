function love.load()
    require('startup.require')

    love.graphics.setDefaultFilter("nearest", "nearest")
    love.mouse.setVisible(false)

    Settings.load(nil) -- file
    Map.load()
    UnitController.load()
    BuildingController.load()
    ResourceController.load()
    MousePointer.load()
    GuiController.load()
    Pointer.load(400,400)
end


function love.update(dt)
    MOUSE_POSITION.x, MOUSE_POSITION.y = love.mouse.getPosition()

    DELTA = dt

    Pointer.update()
    Camera:lookAt(Pointer.position.x, Pointer.position.y)
    Map.update()
    UnitController.update()
    UnitSelector.update()
    BuildingController.update()
    MousePointer.update()
    GuiController.update()
end

local function debugDetached()
    if DEBUG == false then return end

    love.graphics.print ("mouse: " .. MOUSE_POSITION.x.." : " .. MOUSE_POSITION.y, 10,410)
    love.graphics.print("grid: ".. MousePointer.mouseGridPosition.x .. " : " .. MousePointer.mouseGridPosition.y, 10,430)
    love.graphics.print("map pointer: ".. MousePointer.pointerPosition.x .. " : " .. MousePointer.pointerPosition.y, 10,450)

    Pointer.debugDetached()
end

local function debugAttached()
    if DEBUG == false then return end

    Pointer.debugAttached()
end

function love.draw()
    Camera:attach()
        Map.draw()
        UnitController.draw()
        BuildingController.draw()
        ResourceController.draw()
        MousePointer.draw()
        debugAttached()
    Camera:detach()
    GuiController.draw()
    debugDetached()
end

