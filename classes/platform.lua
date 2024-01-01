Platform = Class{}

require('helpers.utils')

function Platform:init(x, y, w, h, scalable, platform_type)
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    self.scalable = scalable

    self.collision_box = {}
    self.collision_box.x = x
    self.collision_box.y = y
    self.collision_box.w = w
    self.collision_box.h = h

    if platform_type then
        self.type = platform_type
    else
        self.type = "static"
    end
end

function Platform:render()
    if self.scalable then
        love.graphics.setColor(144/255, 238/255, 144/255)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    else
        love.graphics.setColor(255/255, 255/255, 255/255)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    end

    if DEBUG_MODE then
        love.graphics.print(string.format("%.2f",tostring(utils_round(self.x, 2)))..", "..string.format("%.2f",tostring(utils_round(self.y, 2))), self.x, self.y + self.h + 5)
        love.graphics.setColor(0/255, 0/255, 255/255)
        love.graphics.rectangle("line", self.collision_box.x, self.collision_box.y, self.collision_box.w, self.collision_box.h)
    end
end

function Platform:scaleUp(direction, dt)
    factor = SCALE_FACTOR
    
    if direction == "w" then
        new_w = self.w + factor * dt

        if new_w < MAX_PLATFORM_WIDTH then
            self.x = self.x - (factor/2 * dt)
            self.w = self.w + (factor * dt)

            self.collision_box.x = self.x
            self.collision_box.w = self.w
        end
    elseif direction == "h" then
        new_h = self.h + factor * dt

        if new_h < MAX_PLATFORM_HEIGHT then
            self.y = self.y - (factor/2 * dt)
            self.h = self.h + (factor * dt)

            self.collision_box.y = self.y
            self.collision_box.h = self.h
        end
    end
end

function Platform:scaleDown(direction, dt)
    factor = SCALE_FACTOR

    if direction == "w" then
        new_w = self.w - factor * dt

        if new_w > MIN_PLATFORM_WIDTH then
            self.x = self.x + (factor/2 * dt)
            self.w = self.w - (factor * dt)

            self.collision_box.x = self.x
            self.collision_box.w = self.w
        end
    elseif direction == "h" then
        new_h = self.h - factor * dt

        if new_h > MIN_PLATFORM_WIDTH then
            self.y = self.y + (factor/2 * dt)
            self.h = self.h - (factor * dt)

            self.collision_box.y = self.y
            self.collision_box.h = self.h
        end
    end
end

function Platform:check_top_collision(obj)
    -- we only check for collisions when the bottom edge of the object is above the bottom edge of the platform
    -- we don't do this relative to the top edge of the platform because we can't catch the collision 
    -- i.e. the collision can only occur once the bottom edge has become equal to or a fraction of a pixel grater than 
    -- the top edge of the platform

    if obj.collision_box.y + obj.collision_box.h < self.collision_box.y + self.collision_box.h then
        if obj.inherit_dy == 0 then
            return utils_collision(obj.collision_box, self.collision_box) and obj.dy>=0
        else
            return utils_collision(obj.collision_box, self.collision_box)
        end
    else return false end
end

function Platform:check_collision(obj)
    return utils_collision(obj, self)
end