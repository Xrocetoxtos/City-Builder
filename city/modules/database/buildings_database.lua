StorageType = {
    NONE= "none",
    ALL = "all",
    WOOD = "wood",
    GOLD = "gold",
    STONE = "stone",
    FOOD = "food"
}

local BD = {

    {
        name = "Town Center",
        type = "Civic",
        icon = nil,
        ghost = nil,
        population = 5,
        sprites = {

        }, 
        resource = {
            wood = 300,
            gold = 300,
            stone = 300,
            food = 300
        },
        requiredTech = {

        },
        storageType = StorageType.ALL,
        actions = {
            ActionsDatabase.recruitUnit, ActionsDatabase.researchTech, ActionsDatabase.researchTest, ActionsDatabase.upgrade
        }
    },

    {
        name = "House",
        type = "Civic",
        icon = nil,
        ghost = nil,
        population = 2,
        sprites = {

        }, 
        resource = {
            wood = 30,
            gold = 10,
            stone = 20,
            food = 20
        },
        requiredTech = {
            "Tech"
        },
        storageType = StorageType.NONE,
        actions = {}
    },

    {
        name = "Granary",
        type = "Civic",
        icon = nil,
        ghost = nil,
        population = 0,
        sprites = {

        }, 
        resource = {
            wood = 30,
            gold = 10,
            stone = 20,
            food = 20
        },
        requiredTech = {

        },
        storageType = StorageType.FOOD,
        actions = {}
    },

    {
        name = "Barracks",
        type = "Military",
        icon = nil,
        ghost = nil,
        population = 0,
        sprites = {

        }, 
        resource = {
            wood = 30,
            gold = 10,
            stone = 20,
            food = 20
        },
        requiredTech = {

        },
        storageType = StorageType.NONE,
        actions = {}
    },
 
    {
        name = "Blacksmith",
        type = "Industrial",
        icon = nil,
        ghost = nil,
        population = 0,
        sprites = {

        }, 
        resource = {
            wood = 30,
            gold = 10,
            stone = 20,
            food = 20
        },
        requiredTech = {

        },
        storageType = StorageType.NONE,
        actions = {}
    }
}

return BD
