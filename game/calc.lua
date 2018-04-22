function distanceto(x1, y1, x2, y2)
    return math.sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2)
end

function distanceto2(x1, y1, x2, y2)
    return (x1 - x2) ^ 2 + (y1 - y2) ^ 2
end

-- Angle between 2 points
function anglebetween(x1, y1, x2, y2)
    return math.atan2(y2 - y1, x2 - x1)
end
