levels = {}

levels[1] = {}
levels[1]["platforms"] = {
    {x = 0, y = VIRTUAL_HEIGHT-15-200, w = VIRTUAL_WIDTH, h = 20, scalable = false, moving = false, coll_type = "solid"},
    {x = 220, y = 270, w = 100, h = 20, scalable = false, moving = false, coll_type = "one_way"},
    {x = 375, y = 350, w = 100, h = 20, scalable = false, moving = false, coll_type = "one_way"},
    {x = 550, y = 430, w = 100, h = 20, scalable = false, moving = false, coll_type = "one_way"},
}

levels[1]["doors"] = {
    {x = VIRTUAL_WIDTH-100, y = VIRTUAL_HEIGHT-300, w = 80, h = 100, name = "a"},
}
levels[1]["keys"] = {
    {x = 260, y = 234, w = 20, h = 20, name = "a"},
}
levels[1]["player_start"] = {x = 15, y = 300}
levels[1]["nina_dialog"] = {"Where am I?", "I was just about to \nfall asleep...", "Am I dreaming?"}

-- ---------------------------------------------------------------------------------------

levels[2] = {}
levels[2]["platforms"] = {
    {x = 0, y = VIRTUAL_HEIGHT-15-200, w = 150, h = 20, scalable = false, coll_type = "one_way"},
    {x = VIRTUAL_WIDTH-150, y = VIRTUAL_HEIGHT-15-200,  w = 150, h = 20, scalable = false, coll_type = "one_way"},
    {x = VIRTUAL_WIDTH/2 - 75, y = VIRTUAL_HEIGHT-40-200,  w = 150, h = 20, scalable = true, moving = true, speed = PLATFORM_SPEED, direction = "y", low_bound = 150, up_bound = 505, coll_type = "one_way"},
    {x = VIRTUAL_WIDTH-150, y = 150, w = 150, h = 20, scalable = false, coll_type = "one_way"},
}
levels[2]["doors"] = {
    {x = VIRTUAL_WIDTH-100, y = VIRTUAL_HEIGHT-300, w = 80, h = 100, name = "a"},
}
levels[2]["keys"] = {
    {x = VIRTUAL_WIDTH-50, y = 90, w = 20, h = 20, name = "a"},
}
levels[2]["player_start"] = {x = 15, y = 150}
levels[2]["nina_dialog"] = {}

-- ---------------------------------------------------------------------------------------

levels[3] = {}
levels[3]["platforms"] = {
    {x = 0, y = VIRTUAL_HEIGHT-215, w = 600, h = 20, scalable = false, moving = false, coll_type = "one_way"},
    {x = 600, y = VIRTUAL_HEIGHT-215,  w = 150, h = 20, scalable = true, moving = true, speed = PLATFORM_SPEED, direction = "x", low_bound = 600, up_bound = VIRTUAL_WIDTH-150, coll_type = "one_way"},
    {x = 350, y = 300, w = 150, h = 20, scalable = false, moving = false, coll_type = "one_way"},
    {x = 1030, y = 0, w = 20, h = 450, scalable = false, moving = false, coll_type = "solid"},
    {x = 1040, y = 430, w = 150, h = 20, scalable = false, moving = false, coll_type = "one_way"},
    
}
levels[3]["doors"] = {}
levels[3]["keys"] = {
    {x = 415, y = 260, w = 20, h = 20, name = "a"},
}
levels[3]["player_start"] = {x = 15, y = 150}
levels[3]["nina_dialog"] = {}