local credits = {}

function credits.init()
end

function credits.update(dt)
end

function credits.draw()
    love.graphics.setFont(font)
    love.graphics.print("title screen")
end

function credits.mousepressed(x, y, button)
end

return credits
