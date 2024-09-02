local sprites = {}

    sprites.ui = {}
    sprites.ui.bonePointer = love.graphics.newImage("resources/sprites/ui/bone_pointer.png")
    sprites.ui.building_types = {}
    sprites.ui.building_types.image = love.graphics.newImage("resources/sprites/ui/BuildingTypes.png")
    sprites.ui.building_types.types = {}
    for i = 1, 4 , 1 do
        sprites.ui.building_types.types[i] = love.graphics.newQuad((i-1)*32, 0, 32, 32, sprites.ui.building_types.image)
    end
    
return sprites