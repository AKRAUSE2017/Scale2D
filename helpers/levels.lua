levels = {}

levels[1] = {}
levels[1]["platforms"] = {
    {x = 0, y = 150, w = 150, h = 20, scalable = false},
    {x = VIRTUAL_WIDTH/2 - 75, y = VIRTUAL_HEIGHT-350,  w = 150, h = 20, scalable = true},
    {x = 0, y = VIRTUAL_HEIGHT-15-200, w = VIRTUAL_WIDTH, h = 20, scalable = false, moving = false},
}

levels[1]["doors"] = {
    {x = VIRTUAL_WIDTH-100, y = VIRTUAL_HEIGHT-300, w = 80, h = 100, name = "a"},
}
levels[1]["keys"] = {
    {x = 50, y = 90, w = 20, h = 20, name = "a"},
}
levels[1]["player_start"] = {x = 15, y = 300}

-- ---------------------------------------------------------------------------------------

levels[2] = {}
levels[2]["platforms"] = {
    {x = 0, y = VIRTUAL_HEIGHT-15-200, w = 150, h = 20, scalable = false},
    {x = VIRTUAL_WIDTH-150, y = VIRTUAL_HEIGHT-15-200,  w = 150, h = 20, scalable = false},
    {x = VIRTUAL_WIDTH/2 - 75, y = VIRTUAL_HEIGHT-40-200,  w = 150, h = 20, scalable = true, moving = true, speed = PLATFORM_SPEED, direction = "y", low_bound = 150, up_bound = 505},
    {x = VIRTUAL_WIDTH-150, y = 150, w = 150, h = 20, scalable = false},
}
levels[2]["doors"] = {
    {x = VIRTUAL_WIDTH-100, y = VIRTUAL_HEIGHT-300, w = 80, h = 100, name = "a"},
}
levels[2]["keys"] = {
    {x = VIRTUAL_WIDTH-50, y = 90, w = 20, h = 20, name = "a"},
}
levels[2]["player_start"] = {x = 15, y = 150}

-- ---------------------------------------------------------------------------------------

levels[3] = {}
levels[3]["platforms"] = {
    {x = 0, y = VIRTUAL_HEIGHT-215, w = 600, h = 20, scalable = false, moving = false},
    {x = 600, y = VIRTUAL_HEIGHT-215,  w = 150, h = 20, scalable = true, moving = true, speed = PLATFORM_SPEED, direction = "x", low_bound = 600, up_bound = VIRTUAL_WIDTH-150},
    {x = 350, y = 300, w = 150, h = 20, scalable = false, moving = false},
    {x = 1030, y = 0, w = 20, h = 450, scalable = false, moving = false},
    {x = 1030, y = 450, w = 150, h = 20, scalable = false, moving = false},
    
}
levels[3]["doors"] = {}
levels[3]["keys"] = {
    {x = 415, y = 260, w = 20, h = 20, name = "a"},
}
levels[3]["player_start"] = {x = 15, y = 150}