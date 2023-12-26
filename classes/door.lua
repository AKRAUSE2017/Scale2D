Door = Class{}

require('helpers.utils')

function Door:init(x, y, w, h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
end

function Door:render()
    love.graphics.setColor(100/255, 144/255, 200/255)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end