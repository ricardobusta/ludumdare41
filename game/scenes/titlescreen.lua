local titlescreen = {}

local startbutton = nil

function titlescreen.init()
    startbutton = newbutton(100, 100, sprites.pinkbutton, "start game")
end

function titlescreen.update(dt)
end

function titlescreen.draw()
    love.graphics.setFont(fonts.small)
    love.graphics.print("title screen")

    drawbutton(startbutton)
end

function titlescreen.mousepressed(x, y, button)
    if button == 1 and checkinside(x, y, startbutton) then
        currentscene = 2
    end
end

return titlescreen
