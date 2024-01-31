Door = Class{}

require('helpers.utils')

function Door:init(x, y, w, h, name)
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    self.name = name

    self.doorTimer = 0
    self.doorOpenAfterSecs = 0.5
end

function Door:render()
    love.graphics.setColor(100/255, 144/255, 200/255)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function Door:check_collision(obj)
    return utils_collision(obj, self)
end

function Door:reset()
    self.doorTimer = 0
end