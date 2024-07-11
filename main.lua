push = require('imports.push')

require('helpers.constants')

local player = {x=500, y=600, w=100, h=100, dx=0, dy=0, state="ground"}

function love.load()
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

function love.keypressed(key)
    if key == "space" then
        player.state = "jump"
    end
end

function love.draw()
    push:start() 

    love.graphics.setColor(255/255, 255/255, 255/255)
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)

    push:finish()
end

function love.update(dt)
    if love.keyboard.isDown('d') or love.keyboard.isDown("right") then
        player.dx = 200 * dt
    elseif love.keyboard.isDown('a') or love.keyboard.isDown("left") then
        player.dx = -200 * dt
    else
        player.dx = 0
    end

    if player.state == "jump" then
        player.dy = -250 * dt
        player.state = "air"
    elseif player.state == "air" then
        player.dy = player.dy + 5 * dt
    end

    if player.y > 600 then 
        player.y = 600
        player.state = "ground"
        player.dy = 0
    end
        
    player.x = player.x + player.dx
    player.y = player.y + player.dy
end