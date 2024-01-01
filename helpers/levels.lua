levels = {}

levels[1] = {}
levels[1]["platforms"] = {
    {x = 0, y = VIRTUAL_HEIGHT-15, w = 70, h = 10, scalable = true},
    {x = VIRTUAL_WIDTH-70, y = VIRTUAL_HEIGHT-15, w = 70, h = 10, scalable = false},
    {x = VIRTUAL_WIDTH/2-40/2, y = VIRTUAL_HEIGHT-40, w = 40, h = 10, scalable = true, moving = true, speed = PLATFORM_SPEED, direction = "y", low_bound = 50, up_bound = VIRTUAL_HEIGHT-15},
    {x = VIRTUAL_WIDTH-70, y = 100, w = 70, h = 10, scalable = false},
    {x = 0, y = 100, w = 70, h = 10, scalable = false}
}
levels[1]["doors"] = {
    {x = VIRTUAL_WIDTH-50, y = VIRTUAL_HEIGHT-60, w = 40, h = 50},
}
levels[1]["keys"] = {
    {x = VIRTUAL_WIDTH-35, y = 80, w = 7, h = 7},
}

levels[2] = {}
levels[2]["platforms"] = {
    {x = 0, y = VIRTUAL_HEIGHT-15, w = VIRTUAL_WIDTH, h = 10, scalable = false, moving = false},
    {x = VIRTUAL_WIDTH/2 + 70, y = VIRTUAL_HEIGHT-70, w = 70, h = 10, scalable = true, moving = true, speed = 70, direction = "x", low_bound = 50, up_bound = VIRTUAL_WIDTH-100}
}
levels[2]["doors"] = {}
levels[2]["keys"] = {}

levels[3] = {}
levels[3]["platforms"] = {
    {x = 0, y = VIRTUAL_HEIGHT-15, w = VIRTUAL_WIDTH, h = 10, scalable = false},
    {x = 90, y = VIRTUAL_HEIGHT-40, w = 70, h = 10, scalable = true},
    {x = VIRTUAL_WIDTH/2 + 140, y = VIRTUAL_HEIGHT-60, w = 70, h = 10, scalable = true}
}
levels[3]["doors"] = {}
levels[3]["keys"] = {}