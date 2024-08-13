function love.load()
	DEBUG = true
    require('startup.require')
    Camera = CameraLib()

	SCREEN_WIDTH, SCREEN_HEIGHT = love.graphics.getDimensions()

    Pointer.load(200,200)
end


function love.update(dt)
    mousePosition = Vector(love.mouse.getPosition())
    Pointer.update(dt)
    Camera:lookAt(Pointer.position.x, Pointer.position.y)
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

    Pointer.debugAttached()
end

function love.draw()
    debugDetached()
    
    Camera:attach()
        debugAttached()
        love.graphics.rectangle("line", 100,100,400,500)

    Camera:detach()
end

