Player = Class{}

require('helpers.constants')
require('helpers.utils')

function Player:init(x, y, w, h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    self.prev_x = 0

    self.dx = 0
    self.dy = 0

    self.should_snap = true

    self.state = "air"
    self.inherit_dx = 0
    self.inherit_dy = 0

    self.air_time = 0
end

function Player:render()
    love.graphics.setColor(255/255, 255/255, 255/255)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

    if DEBUG_MODE then
        love.graphics.print(string.format("%.2f",tostring(utils_round(self.x, 2)))..", "..string.format("%.2f",tostring(utils_round(self.y, 2))), self.x - 5, self.y - 25)
        love.graphics.print(string.format("%.2f",tostring(utils_round(self.y  + self.h, 2))), self.x - 50, self.y + self.h - 15)
    end
end

function Player:update(dt)
    --print(self.dy)
    if love.keyboard.keysPressed["space"] and self.state == "grounded" then
        self.dy = -PLAYER_JUMP_HEIGHT --+ self.inherit_dy
        self.state = "air"
        self.air_time = 0
    end

    if love.keyboard.isDown('d') or love.keyboard.isDown("right") then
        self.dx = PLAYER_SPEED
    elseif love.keyboard.isDown('a') or love.keyboard.isDown("left") then
        self.dx = -PLAYER_SPEED
    else
        self.dx = 0
    end

    if self.state == "air" then
        self.air_time = self.air_time + dt
        self.dy = math.min(self.dy + GRAVITY * dt, 400)
        self.y = self.y + self.dy * dt
        
        self.inherit_dx = 0
        self.should_snap = true
    end

    if self.dx * self.inherit_dx < 0 then -- self.dx * self.inherit_dx is > 0 when both are moving in same direction
        self.inherit_dx = 0 -- when moving in opposite directions, disable the inherited velocity
    end

    self.dx = self.dx + self.inherit_dx

    self.x = self.x + (self.dx) * dt
end 

function Player:grounded(platform)
    self.state = "grounded"
    self.dy = 0
    if platform.type == "moving" then
        if platform.direction == "x" then self.inherit_dx = platform.speed end
        if platform.direction == "y" then self.inherit_dy = platform.speed end
        if self.should_snap then
            print(self.air_time)
            if platform.direction == "x" then 
                self.x = math.floor(self.x + 0.5)
                platform.platform.x = math.floor(platform.platform.x + 0.5)
                self.should_snap = false
            end
        end
        self.y = platform.platform.y-PLAYER_HEIGHT+1
    else
        self.y = platform.y-PLAYER_HEIGHT+1
        self.inherit_dx = 0
        self.inherit_dy = 0
    end
end