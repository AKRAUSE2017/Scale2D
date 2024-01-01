require('classes.platform')

MovingPlatform = Class{}

require('helpers.constants')

function MovingPlatform:init(x, y, w, h, scalable, speed, direction, low_bound, up_bound)
    self.platform = Platform(x, y, w, h, scalable, "moving")
    self.type = "moving"
    self.scalable = scalable

    self.direction = direction
    self.low_bound = low_bound
    self.up_bound = up_bound

    self.speed = speed
    self.saved_speed = speed
    self.state = "active"
end

function MovingPlatform:update(dt)
    if self.state == "freeze" then
        self.speed = 0
    end
    if self.state == "active" then
        self.saved_speed = self.speed
        if self.direction == "x" then
            self.platform.x = self.platform.x + self.speed * dt

            if self.platform.x > self.up_bound and self.speed > 0 then
                self.speed = -self.speed
            elseif self.platform.x < self.low_bound and self.speed < 0 then
                self.speed = -self.speed
            end

            self.platform.collision_box.x = self.platform.x
        end

        if self.direction == "y" then
            self.platform.y = self.platform.y + self.speed * dt

            if self.platform.y > self.up_bound and self.speed > 0 then
                self.speed = -self.speed
            elseif self.platform.y < self.low_bound and self.speed < 0 then
                self.speed = -self.speed
            end

            self.platform.collision_box.y = self.platform.y
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

function MovingPlatform:check_collision(obj)
    return self.platform:check_collision(obj)
end