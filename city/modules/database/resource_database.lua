ResourceType = {
    NONE= "none",
    ALL = "all",
    WOOD = "wood",
    GOLD = "gold",
    STONE = "stone",
    FOOD = "food"
}

local RD = {}

    RD.wood = {
        name = "Wood",
        type = ResourceType.WOOD,
        icon = nil,
        image = Sprites.resources.wood.image,
        sprites = Sprites.resources.wood.sprites,
        amount = 1,
        time = 2
    }

    RD.gold = {
        name = "Gold",
        type = ResourceType.GOLD,
        icon = nil,
        image = Sprites.resources.gold.image,
        sprites = Sprites.resources.gold.sprites,
        amount = 15,
        time = 10
    }


    RD.stone = {
        name = "Stone",
        type = ResourceType.STONE,
        icon = nil,
        image = Sprites.resources.stone.image,
        sprites = Sprites.resources.stone.sprites,
        amount = 2,
        time = 1
    }

    --TODO. verschillende types food nodig? (bessen, graan, dieren, vis...)
    RD.food = {
        name = "Food",
        type = ResourceType.FOOD,
        icon = nil,
        --image = Sprites.resources.food.image,
        --sprites = Sprites.resources.food.sprites,
        amount = 1,
        time = 10
    }

return RD 