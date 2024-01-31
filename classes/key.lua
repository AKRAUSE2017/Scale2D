Key = Class{}

require('helpers.utils')

function Key:init(x, y, w, h, name)
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    self.r = 100/255
    self.g = 144/255
    self.b = 200/255

    self.name = name
    self.state = "not_collected"
end

function Key:render()
    if self.state == "not_collected" then
        love.graphics.setColor(self.r, self.g, self.b)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    end
end

function Key:collect(player)
    self.x = 1220
    self.y = 15

    self.state = "collected"
end

function Key:check_collision(obj)
    return utils_collision(obj, self)
end