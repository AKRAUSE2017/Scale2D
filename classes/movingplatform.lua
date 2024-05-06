require('classes.platform')

MovingPlatform = Class{}

require('helpers.constants')

function MovingPlatform:init(x, y, w, h, scalable, speed, direction, low_bound, up_bound, col_type)
    self.platform = Platform(x, y, w, h, scalable)
    self.scalable = scalable

    -- properties unique to moving platforms
    self.direction = direction
    self.low_bound = low_bound
    self.up_bound = up_bound
    
    self.speed = speed
    self.saved_speed = speed
    self.state = "active"

    self.col_type = col_type
end

function MovingPlatform:update(dt)
    --print(self.state)
    if love.keyboard.keysPressed["f"] and self.state == "active" then 
        self.state = "freeze"
        GAME_STATE = "freeze"
    elseif love.keyboard.keysPressed["f"] and self.state == "freeze" then
        self.state = "active"
        self.speed = self.saved_speed
        GAME_STATE = "play"
    end

    if self.state == "freeze" then
        self.speed = 0
    end
    
    if self.state == "active" then
        self.saved_speed = self.speed
        local new_position = 0
        if self.direction == "x" then
            new_position = self.platform.x + self.speed * dt
            self.platform.x = new_position
            self.platform.collision_box.x = new_position
        elseif self.direction == "y" then
            new_position = self.platform.y + self.speed * dt
            self.platform.y = new_position
            self.platform.collision_box.y = new_position
        end

        if (new_position > self.up_bound and self.speed > 0) or (new_position < self.low_bound and self.speed < 0) then
            self.speed = -self.speed
        end
    end
end

function MovingPlatform:render()
    self.platform:render()
end

function MovingPlatform:scaleUp(direction, dt)
    self.platform:scaleUp(direction, dt)
end

function MovingPlatform:scaleDown(direction, dt)
    self.platform:scaleDown(direction, dt)
end

function MovingPlatform:check_top_collision(obj)
    return self.platform:check_top_collision(obj)
end

function MovingPlatform:check_boundary_collision(obj)
    return self.platform:check_boundary_collision(obj)
end

function MovingPlatform:check_collision(obj)
    return self.platform:check_collision(obj)
end