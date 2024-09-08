local sprites = {}

    sprites.ui = {}
    sprites.ui.bonePointer = love.graphics.newImage("resources/sprites/ui/bone_pointer.png")

    sprites.ui.building_types = {}
    sprites.ui.building_types.image = love.graphics.newImage("resources/sprites/ui/BuildingTypes.png")
    sprites.ui.building_types.types = {}
    for i = 1, 4 , 1 do
        sprites.ui.building_types.types[i] = love.graphics.newQuad((i-1)*32, 0, 32, 32, sprites.ui.building_types.image)
    end

    sprites.ui.resources = {}
    sprites.ui.resources.image = love.graphics.newImage("resources/sprites/ui/resources.png")
    sprites.ui.resources.types = {}
    for i = 1, 5 , 1 do
        sprites.ui.resources.types[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, sprites.ui.resources.image)
    end
    
return sprites