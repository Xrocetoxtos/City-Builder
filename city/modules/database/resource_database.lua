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
        name = "Tree",
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

    RD.apple = {
        name = "Apple",
        type = ResourceType.FOOD,
        icon = nil,
        image = Sprites.resources.apple.image,
        sprites = Sprites.resources.apple.sprites,
        amount = 1,
        time = 1,
        walkable = true
    }
    RD.cow_meat = {
        name = "Cow meat",
        type = ResourceType.FOOD,
        icon = nil,
        image = Sprites.resources.cow_meat.image,
        sprites = Sprites.resources.cow_meat.sprites,
        amount = 10,
        time = 2
    }
    RD.berry_bush = {
        name = "Berry bush",
        type = ResourceType.FOOD,
        icon = nil,
        image = Sprites.resources.berry_bush.image,
        sprites = Sprites.resources.berry_bush.sprites,
        amount = 20,
        time = 2
    }
    RD.apple_tree = {
        name = "Apple tree",
        type = ResourceType.WOOD,
        icon = nil,
        image = Sprites.resources.apple_tree.image,
        sprites = Sprites.resources.apple_tree.sprites,
        amount = 1,
        time = 2,   
        drop = {
            dropObject = RD.apple,
            dropTime = 1
        }
    }

return RD 