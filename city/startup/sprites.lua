local sprites = {}

    -- UI
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

    -- villager
    sprites.villager = love.graphics.newImage("resources/sprites/villager.png")

    -- In map resources
    sprites.resources = {}
    sprites.resources.wood = {}
    sprites.resources.wood.image = love.graphics.newImage("resources/sprites/trees.png")
    sprites.resources.wood.sprites = {}
    for i = 1, 3 , 1 do
        sprites.resources.wood.sprites[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, sprites.resources.wood.image)
    end   

    sprites.resources.stone = {}
    sprites.resources.stone.image = love.graphics.newImage("resources/sprites/rocks.png")
    sprites.resources.stone.sprites = {}
    for i = 1, 3 , 1 do
        sprites.resources.stone.sprites[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, sprites.resources.stone.image)
    end   

    sprites.resources.gold = {}
    sprites.resources.gold.image = love.graphics.newImage("resources/sprites/gold.png")
    sprites.resources.gold.sprites = {}
    sprites.resources.gold.sprites[1] = love.graphics.newQuad(0, 0, 16, 16, sprites.resources.gold.image)

    sprites.resources.apple = {}
    sprites.resources.apple.image = love.graphics.newImage("resources/sprites/apple.png")
    sprites.resources.apple.sprites = {}
    sprites.resources.apple.sprites[1] = love.graphics.newQuad(0, 0, 16, 16, sprites.resources.apple.image)

    sprites.resources.cow_meat = {}
    sprites.resources.cow_meat.image = love.graphics.newImage("resources/sprites/dead cow.png")
    sprites.resources.cow_meat.sprites = {}
    sprites.resources.cow_meat.sprites[1] = love.graphics.newQuad(0, 0, 16, 16, sprites.resources.cow_meat.image)
 
    sprites.resources.berry_bush = {}
    sprites.resources.berry_bush.image = love.graphics.newImage("resources/sprites/berry bush.png")
    sprites.resources.berry_bush.sprites = {}
    sprites.resources.berry_bush.sprites[1] = love.graphics.newQuad(0, 0, 16, 16, sprites.resources.berry_bush.image)

    -- sprites.resources.food = {}
    -- sprites.resources.food.image = love.graphics.newImage("resources/sprites/food.png")
    -- sprites.resources.food.sprites = {}
    -- for i = 1, 3 , 1 do
    --     sprites.resources.food.sprites[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, sprites.resources.food.image)
    -- end   
return sprites