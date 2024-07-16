push = require('imports.push')
require('helpers.constants')

local player = {x=500, y=600, w=100, h=100, dx=0, dy=0, state="ground"}

function love.keypressed(key)
    if key == "space" then
        player.dy = -300
        player.state = "air"
    end
end

function love.update(dt)
    if love.keyboard.isDown("right") then
        player.dx = 200
    elseif love.keyboard.isDown("left") then
        player.dx = -200
    else
        player.dx = 0
    end

    if player.state == "air" then
        player.dy = player.dy + 500 * dt
    end

    if player.y > 600 then 
        player.state = "ground"
        player.y = 600
        player.dy = 0
    end
        
    player.x = player.x + player.dx * dt
    player.y = player.y + player.dy * dt
end

function love.load()
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

function love.draw()
    push:start() 
    love.graphics.setColor(255/255, 255/255, 255/255)
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
    push:finish()
end