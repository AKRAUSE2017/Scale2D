push = require('imports.push')
Class = require('imports.class')

require('helpers.constants')
require('helpers.utils')
require('helpers.levels')

require('classes.player')
require('classes.platform')
require('classes.movingplatform')
require('classes.button')
require('classes.door')
require('classes.key')

function love.load()
    print("START", VIRTUAL_HEIGHT-15)
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    SCALE_X = VIRTUAL_WIDTH/WINDOW_WIDTH
    SCALE_Y = VIRTUAL_HEIGHT/WINDOW_HEIGHT

    love.keyboard.keysPressed = {} -- using love SDK to create new key to the keyboard table

    player = Player(15, 150, PLAYER_WIDTH, PLAYER_HEIGHT)
    
    level_number = 1
    platforms, doors, keys = setLevel(level_number)

    scale_mode = "w"
    button_scale_w = Button(10, 10, 20, 15, "w", true)
    button_scale_h = Button(40, 10, 20, 15, "h", false)
end

function setLevel(level)
    local platforms = {}
    local doors = {}
    local keys = {}

    for _, properties in pairs(levels[level]["platforms"]) do
        if properties.moving then
            table.insert(platforms, MovingPlatform(properties.x, properties.y, properties.w, properties.h, properties.scalable, properties.speed, properties.direction, properties.low_bound, properties.up_bound))
        else
            table.insert(platforms, Platform(properties.x, properties.y, properties.w, properties.h, properties.scalable)) 
        end
    end

    for _, properties in pairs(levels[level]["doors"]) do
        table.insert(doors, Door(properties.x, properties.y, properties.w, properties.h)) 
    end

    for _, properties in pairs(levels[level]["keys"]) do
        table.insert(keys, Key(properties.x, properties.y, properties.w, properties.h)) 
    end

    return platforms, doors, keys
end

function love.resize(w,h)
    SCALE_X = VIRTUAL_WIDTH/w
    SCALE_Y = VIRTUAL_HEIGHT/h
    push:resize(w,h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true; -- capture whatever key has been pressed
    if key == 'escape' then
        love.event.quit()
    elseif key == 'k' then
        level_number = level_number + 1
        platforms = setLevel(level_number)
    end
end

function love.mousereleased(x, y, button)
    mouse_button = button
    mouse = {x=x*SCALE_X, y=y*SCALE_Y, w=1, h=1}
    print("mouse", mouse.x, mouse.y)

    if button_scale_w:check_collision(mouse) then
        button_scale_w.active = true
        button_scale_h.active = false
        scale_mode = "w"
    elseif button_scale_h:check_collision(mouse) then
        button_scale_h.active = true
        button_scale_w.active = false
        scale_mode = "h"
    end

    for _, platform in pairs(platforms) do -- should probably update this to track the moving platforms only
        if platform.state == "freeze" then
            platform.state = "active"
            platform.speed = platform.saved_speed
        end
    end
end

function mouseDown(button, dt)
    x, y = love.mouse.getPosition()
    mouse_button = button
    mouse = {x=x*SCALE_X, y=y*SCALE_Y, w=1, h=1}

    for _, platform in pairs(platforms) do
        if platform.scalable and platform:check_collision(mouse) then
            if platform.speed then
                platform.state = "freeze"
            end
            if mouse_button == 1 then
                platform:scaleUp(scale_mode, dt)
            elseif mouse_button == 2 then
                platform:scaleDown(scale_mode, dt)
            end
        end
    end
end

-- new/custom function implementation using love SDK
function love.keyboard.wasPressed(key)
    -- return value stored in our custom table for a given key
    return love.keyboard.keysPressed[key] -- would be true if love.keypressed triggered it
end

function love.draw()
    push:start() 

    for _, door in pairs(doors) do
        door:render()
    end

    for _, platform in pairs(platforms) do
        platform:render()
    end

    player:render()

    for _, key in pairs(keys) do
        key:render()
    end

    button_scale_w:render()
    button_scale_h:render()

    if DEBUG_MODE then
        love.graphics.setColor(255/255, 255/255, 255/255)
        love.graphics.print(love.timer.getFPS(), VIRTUAL_WIDTH-30, 10)
    end

    push:finish()
end

function love.keyreleased(key)
    if key == "d" or key == "right" or key == "a" or key == "left" then
       player.should_snap = true
    end
    if key == "f" then
        for _, platform in pairs(platforms) do
            platform.state = "active"
            platform.speed = platform.saved_speed
        end
    end
end

function love.update(dt)
    if love.mouse.isDown(1) then
        mouseDown(1, dt)
    elseif love.mouse.isDown(2) then
        mouseDown(2, dt)
    end

    if love.keyboard.isDown("f") then
        for _, platform in pairs(platforms) do
            platform.state = "freeze"
        end
    end

    player.state = "air"
    for _, platform in pairs(platforms) do
        if platform:check_top_collision(player) then
            player:grounded(platform, dt)
        end  
        if platform.type == "moving" then
            platform:update(dt)
        end      
    end
    print(player.state)

    player:update(dt)

    for _, key in pairs(keys) do
        if key:check_collision(player.collision_box) and (not key.collected) then
            key:collect(player)
        end
    end

    love.keyboard.keysPressed = {}
end