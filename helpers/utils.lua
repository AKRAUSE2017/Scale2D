function utils_collision(obj1, obj2)
    obj1_rightEdge = math.floor(obj1.x + obj1.w + 0.5)
    obj1_leftEdge = math.floor(obj1.x + 0.5)

    obj2_rightEdge = math.floor(obj2.x + obj2.w + 0.5)
    obj2_leftEdge = math.floor(obj2.x + 0.5)

    obj1_bottomEdge = math.floor(obj1.y + obj1.h + 0.5)
    obj1_topEdge = math.floor(obj1.y + 0.5)
    
    obj2_bottomEdge = math.floor(obj2.y + obj2.h + 0.5)
    obj2_topEdge = math.floor(obj2.y + 0.5)

    collX = obj1_rightEdge >= obj2_leftEdge and obj2_rightEdge >= obj1_leftEdge
    collY = obj1_topEdge <= obj2_bottomEdge and obj2_topEdge <= obj1_bottomEdge

    return collX and collY
end

function utils_round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- maximum_velocity = dy
-- distance traveled in one frame = self.dy * gravity
-- what is the maximum distance that the player can travel in one frame 
-- 400 * dt
-- 400 * 1/60