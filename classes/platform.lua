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
end

function Platform:render()
    if self.scalable then
        love.graphics.setColor(35/255, 33/255, 61/255)
        love.graphics.rectangle("fill", math.floor(self.x), math.floor(self.y), self.w, self.h)
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
    if direction == "w" then
        new_w = self.w + SCALE_FACTOR * dt

        if new_w < MAX_PLATFORM_WIDTH then
            self.x = self.x - (SCALE_FACTOR/2 * dt)
            self.w = self.w + (SCALE_FACTOR * dt)

            self.collision_box.x = self.x
            self.collision_box.w = self.w
        end
    elseif direction == "h" then
        new_h = self.h + SCALE_FACTOR * dt

        if new_h < MAX_PLATFORM_HEIGHT then
            self.y = self.y - (SCALE_FACTOR/2 * dt)
            self.h = self.h + (SCALE_FACTOR * dt)

            self.collision_box.y = self.y
            self.collision_box.h = self.h
        end
    end
end

function Platform:scaleDown(direction, dt)
    if direction == "w" then
        new_w = self.w - SCALE_FACTOR * dt

        if new_w > MIN_PLATFORM_WIDTH then
            self.x = self.x + (SCALE_FACTOR/2 * dt)
            self.w = self.w - (SCALE_FACTOR * dt)

            self.collision_box.x = self.x
            self.collision_box.w = self.w
        end
    elseif direction == "h" then
        new_h = self.h - SCALE_FACTOR * dt

        if new_h > MIN_PLATFORM_WIDTH then
            self.y = self.y + (SCALE_FACTOR/2 * dt)
            self.h = self.h - (SCALE_FACTOR * dt)

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
    if (obj.collision_box) then 
        obj_y = obj.collision_box.y
        obj_h = obj.collision_box.h
        obj_collision_box = obj.collision_box
    else
        obj_y = obj.y
        obj_h = obj.h
        obj_collision_box = obj
    end

    if obj_y + obj_h < self.collision_box.y + self.collision_box.h then
        if obj.inherit_dy == 0 then -- if not snapped on a moving platform
            return utils_collision(obj_collision_box, self.collision_box) and obj.dy>=0
        else
            return utils_collision(obj_collision_box, self.collision_box)
        end
    else return false end
end

function Platform:check_collision(obj)
    return utils_collision(obj, self)
end