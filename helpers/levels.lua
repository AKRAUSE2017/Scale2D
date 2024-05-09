levels = {}

levels[1] = {}
levels[1]["platforms"] = {
    -- {x = 0, y = 150, w = 150, h = 20, scalable = false, col_type = "one_way"},
    -- {x = VIRTUAL_WIDTH/2 - 75, y = VIRTUAL_HEIGHT-350,  w = 150, h = 20, scalable = true, col_type = "one_way"},
    -- {x = VIRTUAL_WIDTH/2 + 100, y = VIRTUAL_HEIGHT-300,  w = 150, h = 20, scalable = false, col_type = "solid"},
    {x = 0, y = VIRTUAL_HEIGHT-15-200, w = VIRTUAL_WIDTH, h = 20, scalable = false, moving = false, col_type = "one_way"},
    -- {x = 200, y = VIRTUAL_HEIGHT-400, w = 100, h = 50, scalable = false, moving = false, col_type = "solid"},
    -- {x = 100, y = 450, w = 20, h = 600, scalable = false, moving = false, col_type = "solid"},
    --{x = 400, y = VIRTUAL_HEIGHT-345, w = 20, h = 150, scalable = false, moving = false, col_type = "solid"},
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
    {x = 0, y = VIRTUAL_HEIGHT-15-200, w = 150, h = 20, scalable = false, col_type = "one_way"},
    {x = VIRTUAL_WIDTH-150, y = VIRTUAL_HEIGHT-15-200,  w = 150, h = 20, scalable = false, col_type = "one_way"},
    {x = VIRTUAL_WIDTH/2 - 75, y = VIRTUAL_HEIGHT-40-200,  w = 150, h = 20, scalable = true, moving = true, speed = PLATFORM_SPEED, direction = "y", low_bound = 150, up_bound = 505, col_type = "one_way"},
    {x = VIRTUAL_WIDTH-150, y = 150, w = 150, h = 20, scalable = false, col_type = "one_way"},
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
    {x = 0, y = VIRTUAL_HEIGHT-215, w = 600, h = 20, scalable = false, moving = false, col_type = "one_way"},
    {x = 600, y = VIRTUAL_HEIGHT-215,  w = 150, h = 20, scalable = true, moving = true, speed = PLATFORM_SPEED, direction = "x", low_bound = 600, up_bound = VIRTUAL_WIDTH-150, col_type = "one_way"},
    {x = 350, y = 300, w = 150, h = 20, scalable = false, moving = false, col_type = "one_way"},
    {x = 1030, y = 0, w = 20, h = 450, scalable = false, moving = false, col_type = "solid"},
    {x = 1040, y = 430, w = 150, h = 20, scalable = false, moving = false, col_type = "one_way"},
    
}
levels[3]["doors"] = {}
levels[3]["keys"] = {
    {x = 415, y = 260, w = 20, h = 20, name = "a"},
}
levels[3]["player_start"] = {x = 15, y = 150}