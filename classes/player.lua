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
    elseif self.state == "fall" then
        love.graphics.draw(player_fall, math.floor(self.x+offset_x), math.floor(self.y+PLAYER_SPRITE_SCALE), 0, self.flip, PLAYER_SPRITE_SCALE)
    else
        if self.dy > 0 and self.state == "air" then animation.currentTime = 0 end
        local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
        love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], math.floor(self.x+offset_x), math.floor(self.y+PLAYER_SPRITE_SCALE), 0, self.flip, PLAYER_SPRITE_SCALE)
    end

    if DEBUG_MODE then
        love.graphics.print(string.format("%.2f",tostring(utils_round(self.x, 2)))..", "..string.format("%.2f",tostring(utils_round(self.y, 2))), self.x - 5, self.y - 25)
        love.graphics.setColor(255/255, 0/255, 255/255)
        love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

        for _, collision_box in pairs(self.collision_boxes) do 
            love.graphics.setColor(0/255, 255/255, 0/255)
            love.graphics.rectangle("line", collision_box.x, collision_box.y, collision_box.w, collision_box.h)
        end
    end

    for index, item in pairs(self.items) do
        love.graphics.setColor(item.r, item.g, item.b)
        love.graphics.rectangle("fill", item.x, item.y+1, item.w, item.h)
    end 
end

function Player:update(dt)
    -- print(self.state)
    if (love.keyboard.keysPressed["space"] or (self.bend_to_jump_timer > 0)) and self.state == "grounded" and GAME_STATE == "play" then
        self.bend_to_jump_timer = self.bend_to_jump_timer + dt
        if self.bend_to_jump_timer > 0.1 then
            self.dy = -PLAYER_JUMP_HEIGHT + self.inherit_dy
            self.state = "air"
            self.air_time = 0
        end
    end

    if love.keyboard.keysReleased["d"] or love.keyboard.keysReleased["right"] or love.keyboard.keysReleased["a"] or love.keyboard.keysReleased["left"] then
        self.should_snap = true
    end

    if love.keyboard.isDown('d') or love.keyboard.isDown("right") and GAME_STATE == "play" then
        self.dx = PLAYER_SPEED
        if self.state == "grounded" then
            animation.currentTime = animation.currentTime + dt
            if animation.currentTime >= animation.duration then
                animation.currentTime = animation.currentTime - animation.duration
            end
        else animation.currentTime = 0.1 end
        self.flip = PLAYER_SPRITE_SCALE
    elseif love.keyboard.isDown('a') or love.keyboard.isDown("left") and GAME_STATE == "play" then
        self.dx = -PLAYER_SPEED
        if self.state == "grounded" then
            animation.currentTime = animation.currentTime + dt
            if animation.currentTime >= animation.duration then
                animation.currentTime = animation.currentTime - animation.duration
            end
        else animation.currentTime = 0.1 end
        self.flip = -PLAYER_SPRITE_SCALE
    else
        self.dx = 0
        animation.currentTime = 0
    end

    if self.state == "air" or self.state == "fall" then
        self.bend_to_jump_timer = 0

        self.dy = math.min(self.dy + GRAVITY, 400)
        self.y = self.y + self.dy * dt
        
        self.inherit_dx = 0
        self.should_snap = true

        if self.dy > 300 then self.state = "fall" end
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
    local playerCollideLeft = self.collision_boxes[1].x + self.collision_boxes[1].w >= platform.x and self.collision_boxes[1].x + self.collision_boxes[1].w < platform.x + platform.w 
    local playerCollideRight = self.collision_boxes[1].x <= platform.x + platform.w and self.collision_boxes[1].x > platform.x

    -- print(self.collision_box.x, platform.x + platform.w)
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