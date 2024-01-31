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
    font = love.graphics.newFont('assets/fonts/font.ttf', 30)
    love.graphics.setFont(font)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    SCALE_X = VIRTUAL_WIDTH/WINDOW_WIDTH
    SCALE_Y = VIRTUAL_HEIGHT/WINDOW_HEIGHT

    love.keyboard.keysPressed = {} -- create keyboard tables
    love.keyboard.keysReleased = {}
    love.keyboard.keysDown = {}

    background =  love.graphics.newImage("assets/background/test_bg.png")
    
    player = Player(0, 0, PLAYER_WIDTH, PLAYER_HEIGHT)
    player_sprite_sheet = love.graphics.newImage("assets/nina/nina_walk_right.png")
    player_sprite_sheet:setFilter("nearest", "nearest")
    animation = newAnimation(player_sprite_sheet, 32, 32, 0.3)

    player_profile = love.graphics.newImage("assets/nina/nina_profile.png")
    player_profile:setFilter("nearest", "nearest")

    level_number = 1
    platforms, platforms_moving, doors, keys = setLevel(level_number)

    scale_mode = "w"
    button_scale_w = Button(10, 10, 40, 35, "w", true)
    button_scale_h = Button(60, 10, 40, 35, "h", false)
end

function setLevel(level)
    local platforms = {}
    local platforms_moving = {}
    local doors = {}
    local keys = {}

    for _, properties in pairs(levels[level]["platforms"]) do
        if properties.moving then
            table.insert(platforms_moving, MovingPlatform(properties.x, properties.y, properties.w, properties.h, properties.scalable, properties.speed, properties.direction, properties.low_bound, properties.up_bound))
        else
            table.insert(platforms, Platform(properties.x, properties.y, properties.w, properties.h, properties.scalable)) 
        end
    end

    for _, properties in pairs(levels[level]["doors"]) do
        table.insert(doors, Door(properties.x, properties.y, properties.w, properties.h, properties.name)) 
    end

    for _, properties in pairs(levels[level]["keys"]) do
        table.insert(keys, Key(properties.x, properties.y, properties.w, properties.h, properties.name)) 
    end

    player.x = levels[level]["player_start"].x
    player.y = levels[level]["player_start"].y
    player.items = {}

    return platforms, platforms_moving, doors, keys
end

function love.resize(w,h)
    SCALE_X = VIRTUAL_WIDTH/w
    SCALE_Y = VIRTUAL_HEIGHT/h
    push:resize(w,h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true -- capture whatever key has been pressed

    if key == 'escape' then
        love.event.quit()
    elseif key == 'k' then
        level_number = level_number + 1
        if levels[level_number] then
            platforms, platforms_moving, doors, keys = setLevel(level_number)
        end
    end    
end

function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true; -- capture whatever key has been released
end

function love.mousereleased(x, y, button)
    mouse_button = button
    mouse = {x=x*SCALE_X, y=y*SCALE_Y, w=1, h=1}
    print(mouse.x, mouse.y)

    if button_scale_w:check_collision(mouse) then
        button_scale_w.active = true
        button_scale_h.active = false
        scale_mode = "w"
    elseif button_scale_h:check_collision(mouse) then
        button_scale_h.active = true
        button_scale_w.active = false
        scale_mode = "h"
    end

    for _, platform in pairs(platforms_moving) do
        if platform.state == "freeze" and GAME_STATE == "play" then
            platform.state = "active"
            platform.speed = platform.saved_speed
        end
    end
end

function handlePlatformScale(button, platform, dt)
    if platform.speed then platform.state = "freeze" end
            
    if button == 1 then
        platform:scaleUp(scale_mode, dt)
    elseif button == 2 then
        platform:scaleDown(scale_mode, dt)
    end
end

function mouseDown(button, dt)
    x, y = love.mouse.getPosition()
    local mouse_button = button
    local mouse = {x=x*SCALE_X, y=y*SCALE_Y, w=1, h=1}

    for _, platform in pairs(platforms) do
        if platform.scalable and (platform:check_collision(mouse) or keyPressed) then
            handlePlatformScale(mouse_button, platform, dt)
        end
    end

    for _, platform in pairs(platforms_moving) do
        if platform.scalable and (platform:check_collision(mouse) or keyPressed) then
            handlePlatformScale(mouse_button, platform, dt)
        end
    end
end

function newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0

    return animation
end

function love.draw()
    push:start() 

    love.graphics.setColor(89/255, 89/255, 107/255)
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    
    love.graphics.draw(background, 0, 0)
    
    -- item box
    love.graphics.setColor(255/255, 255/255, 255/255)
    love.graphics.rectangle("line", COLLECTED_ITEMS_X, COLLECTED_ITEMS_Y, COLLECTED_ITEMS_W, COLLECTED_ITEMS_H)

    for _, door in pairs(doors) do
        door:render()
    end

    for _, platform in pairs(platforms) do
        platform:render()
    end

    for _, platform in pairs(platforms_moving) do
        platform:render()
    end

    player:render()

    for _, key in pairs(keys) do
        key:render()
    end

    button_scale_w:render()
    button_scale_h:render()

    if GAME_STATE == "freeze" then
        love.graphics.setColor(255/255, 255/255, 255/255)
        love.graphics.print("FROZEN", 70, 10)
    end

    if DEBUG_MODE then
        love.graphics.setColor(255/255, 255/255, 255/255)
        love.graphics.print("FPS: "..love.timer.getFPS(), VIRTUAL_WIDTH-120, 10)
    end

    love.graphics.setColor(255/255, 255/255, 255/255)
    love.graphics.draw(player_profile, -20, 530, 0, 2, 2)
    love.graphics.rectangle("line", 30, 540, 200, 160)
    love.graphics.rectangle("fill", 200, 539, 400, 162)

    love.graphics.setColor(35/255, 33/255, 61/255)
    love.graphics.print("Nina:", 227, 565)
    love.graphics.print("Where am I?", 227, 600)

    push:finish()
end

function love.update(dt)
    if love.mouse.isDown(1) then
        mouseDown(1, dt)
    elseif love.mouse.isDown(2) then
        mouseDown(2, dt)
    end

    if love.keyboard.keysPressed["1"] then
        button_scale_w.active = true
        button_scale_h.active = false
        scale_mode = "w"
    elseif love.keyboard.keysPressed["2"] then
        button_scale_h.active = true
        button_scale_w.active = false
        scale_mode = "h"
    end

    player.state = "air"
    for _, platform in pairs(platforms) do -- static platforms
        if platform:check_top_collision(player) then
            player:grounded(platform, "static", dt)
        end  
    end

    for _, platform in pairs(platforms_moving) do -- moving platforms
        if platform:check_top_collision(player) then
            player:grounded(platform, "moving", dt)
        end  
        platform:update(dt)     
    end

    player:update(dt)
    if player:outOfBounds() then
        platforms, platforms_moving, doors, keys = setLevel(level_number)
    end

    for _, key in pairs(keys) do
        if key:check_collision(player) and (not key.collected) then
            key:collect(player)
            player:collect(key)
        end
    end

    for _, door in pairs(doors) do
        if door:check_collision(player) then
            canOpen, keyID = player:openDoorIfKey(door.name)
            if canOpen then
                door.doorTimer = door.doorTimer + dt
                if door.doorTimer > door.doorOpenAfterSecs then
                    level_number = level_number + 1
                    if levels[level_number] then
                        platforms, platforms_moving, doors, keys = setLevel(level_number)
                        door:reset()
                        player:removeItem(keyID)
                    end
                end
            end
        end   
    end

    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}
    love.keyboard.keysDown = {}
end