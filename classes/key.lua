Key = Class{}

require('helpers.utils')

function Key:init(x, y, w, h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    self.collected = false
    self.speed = 80
end

function Key:render()
    love.graphics.setColor(200/255, 100/255, 200/255)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function Key:update(player, dt)
    if self.collected then
        self.x = player.x - 10
        self.y = player.y - 10
    end
end

function Key:collect(player)
    self.collected = true
end

function Key:check_collision(obj)
    return utils_collision(obj, self)
end