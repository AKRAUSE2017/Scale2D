Button = Class{}

require('helpers.constants')

function Button:init(x, y, w, h, text, active)
    self.x = x
    self.y = y 
    self.w = w 
    self.h = h
    self.text = text

    self.active = active
end

function Button:render()
    if not self.active then
        love.graphics.setColor(255/255, 255/255, 255/255)
        love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
        love.graphics.print(self.text, self.x+5, self.y)
    else
        love.graphics.setColor(255/255, 255/255, 255/255)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
        love.graphics.setColor(0/255, 0/255, 0/255)
        love.graphics.print(self.text, self.x+5, self.y)
    end
end

function Button:check_collision(obj)
    return utils_collision(obj, self)
end