Player = Class{}

require('helpers.constants')
require('helpers.utils')

function Player:init(x, y, w, h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    self.dx = 0
    self.dy = 0

    self.should_snap = true

    self.state = "air"
    self.inherit_dx = 0
    self.inherit_dy = 0

    self.items = {}

    self.flip = PLAYER_SPRITE_SCALE
    self.x_offset_sprite = 0

    self.collision_box = {}
    self.collision_box.x = x + PLAYER_COLLISION_OFFSET_X
    self.collision_box.y = y + PLAYER_COLLISION_OFFSET_Y
    self.collision_box.w = w + PLAYER_COLLISION_OFFSET_W
    self.collision_box.h = h + PLAYER_COLLISION_OFFSET_H
end

function Player:render()
    love.graphics.setColor(255/255, 255/255, 255/255)
    local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    
    local offset_x = 0
    if self.flip == -PLAYER_SPRITE_SCALE then offset_x = PLAYER_WIDTH end
    
    love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], math.floor(self.x+offset_x), math.floor(self.y+PLAYER_SPRITE_SCALE), 0, self.flip, PLAYER_SPRITE_SCALE)

    if DEBUG_MODE then
        love.graphics.print(string.format("%.2f",tostring(utils_round(self.x, 2)))..", "..string.format("%.2f",tostring(utils_round(self.y, 2))), self.x - 5, self.y - 25)
        love.graphics.setColor(255/255, 0/255, 255/255)
        love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

        love.graphics.setColor(255/255, 100/255, 255/255)
        love.graphics.rectangle("line", self.collision_box.x, self.collision_box.y, self.collision_box.w, self.collision_box.h)
    end

    for index, item in pairs(self.items) do
        love.graphics.setColor(item.r, item.g, item.b)
        love.graphics.rectangle("fill", item.x, item.y+1, item.w, item.h)
    end 
end

function Player:update(dt)
    if love.keyboard.keysPressed["space"] and self.state == "grounded" and GAME_STATE == "play" then
        self.dy = -PLAYER_JUMP_HEIGHT + self.inherit_dy
        self.state = "air"
        self.air_time = 0
    end

    if love.keyboard.keysReleased["d"] or love.keyboard.keysReleased["right"] or love.keyboard.keysReleased["a"] or love.keyboard.keysReleased["left"] then
        player.should_snap = true
    end

    if love.keyboard.isDown('d') or love.keyboard.isDown("right") and GAME_STATE == "play" then
        self.dx = PLAYER_SPEED
        animation.currentTime = animation.currentTime + dt
        if animation.currentTime >= animation.duration then
            animation.currentTime = animation.currentTime - animation.duration
        end
        self.flip = PLAYER_SPRITE_SCALE
    elseif love.keyboard.isDown('a') or love.keyboard.isDown("left") and GAME_STATE == "play" then
        self.dx = -PLAYER_SPEED
        animation.currentTime = animation.currentTime + dt
        if animation.currentTime >= animation.duration then
            animation.currentTime = animation.currentTime - animation.duration
        end
        self.flip = -PLAYER_SPRITE_SCALE
    else
        self.dx = 0
        animation.currentTime = 0
    end

    if self.state == "air" then
        self.dy = math.min(self.dy + GRAVITY, 400)
        self.y = self.y + self.dy * dt
        
        self.inherit_dx = 0
        self.should_snap = true
    else
        self.dy = self.inherit_dy
        self.y = self.y + self.dy * dt
    end

    if self.dx * self.inherit_dx < 0 then -- self.dx * self.inherit_dx is > 0 when both are moving in same direction
        self.inherit_dx = 0 -- when moving in opposite directions, disable the inherited velocity
    end

    self.dx = self.dx + self.inherit_dx
    self.x = self.x + self.dx * dt
    if self.x > VIRTUAL_WIDTH - self.w then self.x = VIRTUAL_WIDTH - self.w end
    if self.x < 0 then self.x = 0 end


    self.collision_box.x = self.x + PLAYER_COLLISION_OFFSET_X
    self.collision_box.y = self.y + PLAYER_COLLISION_OFFSET_Y
    self.collision_box.w = self.w + PLAYER_COLLISION_OFFSET_W
    self.collision_box.h = self.h + PLAYER_COLLISION_OFFSET_H
end 

function Player:outOfBounds()
    return player.y > VIRTUAL_HEIGHT + 150
end

function Player:grounded(platform, platform_type, dt)
    self.state = "grounded"

    if platform_type == "moving" then
        if platform.direction == "x" then self.inherit_dx = platform.speed end
        if platform.direction == "y" then self.inherit_dy = platform.speed end
        self.y = platform.platform.y-PLAYER_HEIGHT
    else
        self.y = platform.y-PLAYER_HEIGHT
        self.inherit_dx = 0
        self.inherit_dy = 0
    end
end

function Player:collect(item)
    table.insert(self.items, item)
end

function Player:openDoorIfKey(door_name)
    for index, item in pairs(self.items) do
        if item.name == door_name then
            return true, index
        end
    end 
    return false, -1
end

function Player:removeItem(index)
    self.items[index] = nil
end