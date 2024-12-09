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
        sprite = nil,
        time = 10
    }

    RD.gold = {
        name = "Gold",
        type = ResourceType.GOLD,
        icon = nil,
        sprite = nil,
        time = 10
    }


    RD.stone = {
        name = "Stone",
        type = ResourceType.STONE,
        icon = nil,
        sprite = nil,
        time = 1
    }

    RD.food = {
        name = "Food",
        type = ResourceType.FOOD,
        icon = nil,
        sprite = nil,
        time = 10
    }

return RD 