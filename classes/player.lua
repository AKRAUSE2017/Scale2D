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

    self.state = "air"
    self.inherit_dx = 0
    self.inherit_dy = 0

    self.items = {}

    self.flip = PLAYER_SPRITE_SCALE
    self.x_offset_sprite = 0

    self.collision_boxes = {}

    self.collision_boxes[1] = {}
    self.collision_boxes[1]["x"] = x + PLAYER_COLLISION_OFFSETS[1]["X"]
    self.collision_boxes[1]["y"] = y + PLAYER_COLLISION_OFFSETS[1]["Y"]
    self.collision_boxes[1]["w"] = w + PLAYER_COLLISION_OFFSETS[1]["W"]
    self.collision_boxes[1]["h"] = h + PLAYER_COLLISION_OFFSETS[1]["H"]

    self.collision_boxes[2] = {}
    self.collision_boxes[2]["x"] = x + PLAYER_COLLISION_OFFSETS[2]["X"]
    self.collision_boxes[2]["y"] = y + PLAYER_COLLISION_OFFSETS[2]["Y"]
    self.collision_boxes[2]["w"] = w + PLAYER_COLLISION_OFFSETS[2]["W"]
    self.collision_boxes[2]["h"] = h + PLAYER_COLLISION_OFFSETS[2]["H"]

    self.sprite_height = self.collision_boxes[1]["h"] + self.collision_boxes[2]["h"]

    self.bend_to_jump_timer = 0
end

function Player:render()
    love.graphics.setColor(255/255, 255/255, 255/255)
    
    local offset_x = 0
    if self.flip == -PLAYER_SPRITE_SCALE then offset_x = PLAYER_WIDTH end
    
    if self.bend_to_jump_timer > 0 then
        love.graphics.draw(player_bend, math.floor(self.x+offset_x), math.floor(self.y+PLAYER_SPRITE_SCALE), 0, self.flip, PLAYER_SPRITE_SCALE)
    else
        if self.dy > 0 and self.state == "air" then animation.currentTime = 0 end
        local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
        love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], math.floor(self.x+offset_x), math.floor(self.y+PLAYER_SPRITE_SCALE), 0, self.flip, PLAYER_SPRITE_SCALE)
    end

    if DEBUG_MODE then
        love.graphics.print(string.format("%.2f",tostring(utils_round(self.x, 2)))..", "..string.format("%.2f",tostring(utils_round(self.y, 2))), self.x - 5, self.y - 25)
        love.graphics.setColor(255/255, 0/255, 255/255)
        love.graphics.rectangle("line", math.floor(self.x), math.floor(self.y), self.w, self.h)

        for _, collision_box in pairs(self.collision_boxes) do 
            love.graphics.setColor(0/255, 255/255, 0/255)
            love.graphics.rectangle("line", math.floor(collision_box.x), math.floor(collision_box.y), collision_box.w, collision_box.h)
        end
    end

    for index, item in pairs(self.items) do
        love.graphics.setColor(item.r, item.g, item.b)
        love.graphics.rectangle("fill", item.x, item.y+1, item.w, item.h)
    end 
end

function Player:update(dt)
    if (love.keyboard.keysPressed["space"] or (self.bend_to_jump_timer > 0)) and self.state == "grounded" and GAME_STATE == "play" then
        self.bend_to_jump_timer = self.bend_to_jump_timer + dt
        if self.bend_to_jump_timer > 0.1 then
            self.dy = (-PLAYER_JUMP_HEIGHT + self.inherit_dy) * dt
            self.state = "air"
        end
    end

    if love.keyboard.isDown('d') or love.keyboard.isDown("right") then
        self.dx = PLAYER_SPEED * dt
        self.flip = PLAYER_SPRITE_SCALE
        if self.state == "air" then
            animation.currentTime = 0.1
        else
            animation.currentTime = animation.currentTime + dt
            if animation.currentTime >= animation.duration then
                animation.currentTime = animation.currentTime - animation.duration
            end
        end
    elseif love.keyboard.isDown('a') or love.keyboard.isDown("left") then
        self.dx = -PLAYER_SPEED * dt
        self.flip = -PLAYER_SPRITE_SCALE
        if self.state == "air" then
            animation.currentTime = 0.1
        else
            animation.currentTime = animation.currentTime + dt
            if animation.currentTime >= animation.duration then
                animation.currentTime = animation.currentTime - animation.duration
            end
        end
    else
        self.dx = self.inherit_dx * dt
        animation.currentTime = 0
    end

    if self.state == "air" then
        self.bend_to_jump_timer = 0
        dy_pre_accel = self.dy
        self.dy = self.dy + GRAVITY * dt
        dy_avg = (dy_pre_accel + self.dy)/2
        self.y = self.y + dy_avg

        self.inherit_dx = 0
    else
        self.dy = self.inherit_dy * dt
        self.y = self.y + self.dy
    end

    self.x = self.x + self.dx
    
    
    -- check screen boundaries
    if self.x > VIRTUAL_WIDTH - self.w then self.x = VIRTUAL_WIDTH - self.w end
    if self.x < 0 then self.x = 0 end

    for key, collision_box in pairs(self.collision_boxes) do 
        self.collision_boxes[key]["x"] = self.x + PLAYER_COLLISION_OFFSETS[key]["X"]
        self.collision_boxes[key]["y"] = self.y + PLAYER_COLLISION_OFFSETS[key]["Y"]
        self.collision_boxes[key]["w"] = self.w + PLAYER_COLLISION_OFFSETS[key]["W"]
        self.collision_boxes[key]["h"] = self.h + PLAYER_COLLISION_OFFSETS[key]["H"]
    end
end 

function Player:outOfBounds()
    return self.y > VIRTUAL_HEIGHT + 150
end

function Player:grounded(platform, platform_type, dt)
    self.state = "grounded"

    if platform_type == "moving" then
        if platform.direction == "x" then self.inherit_dx = platform.speed end
        if platform.direction == "y" then self.inherit_dy = platform.speed end
        self.y = platform.platform.y-PLAYER_HEIGHT+1
    else
        self.y = platform.y-PLAYER_HEIGHT
        self.inherit_dx = 0
        self.inherit_dy = 0
    end
end

function Player:stop_moving(platform)
    if platform_type == "moving" then 
        platform = platform.platform
    end
    -- self.collision_boxes[1] is nina's head
    local playerCollideLeft = self.collision_boxes[1].x + self.collision_boxes[1].w >= platform.x and self.collision_boxes[1].x + self.collision_boxes[1].w < platform.x + platform.w 
    local playerCollideRight = self.collision_boxes[1].x <= platform.x + platform.w and self.collision_boxes[1].x > platform.x

    if self.collision_boxes[1].y <= platform.y + platform.h and self.collision_boxes[1].y > platform.y + platform.h - 2 then
        self.y = platform.y + platform.h - PLAYER_COLLISION_OFFSETS[1]["Y"] + 2
        if self.dy < 0 then
            self.dy = 10
        end
    elseif playerCollideLeft then -- player is left of the platform
        if (self.collision_boxes[1].y + self.collision_boxes[1].h >= platform.y) or (self.dy > 0) then -- give a buffer for when trying to jump at the top of the platform
            self.x = platform.x - self.collision_boxes[1].w - PLAYER_COLLISION_OFFSETS[1]["X"]  -- always offset by larger collision box
            self.dx = 0
        end
    elseif playerCollideRight then -- player is right of the platform
        if (self.collision_boxes[1].y + self.collision_boxes[1].h >= platform.y) or (self.dy > 0) then -- give a buffer for when trying to jump at the top of the platform
            self.x = (platform.x + platform.w) - PLAYER_COLLISION_OFFSETS[1]["X"]
            self.dx = 0
        end
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