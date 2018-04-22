local titlescreen = {}

local startbutton = nil

function titlescreen.init()
    startbutton = newbutton()
end

function titlescreen.update(dt)
end

function titlescreen.draw()
    love.graphics.setFont(font)
    love.graphics.print("title screen")
end

function titlescreen.mousepressed(x, y, button)
end

return titlescreen
