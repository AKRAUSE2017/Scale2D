function utils_collision(obj1, obj2)
    obj1_rightEdge = obj1.x + obj1.w
    obj1_leftEdge = obj1.x

    obj2_rightEdge = obj2.x + obj2.w
    obj2_leftEdge = obj2.x

    obj1_bottomEdge = obj1.y + obj1.h
    obj1_topEdge = obj1.y
    
    obj2_bottomEdge = obj2.y + obj2.h
    obj2_topEdge = obj2.y

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