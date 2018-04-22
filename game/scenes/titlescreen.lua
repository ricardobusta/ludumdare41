local titlescreen = {}

local startbutton = nil

function titlescreen.init()
    startbutton = newbutton(100, 100, sprites.pinkbutton, "start game", 8)
end

function titlescreen.update(dt)
end

function titlescreen.draw()
    love.graphics.setFont(fonts.small)
    love.graphics.print("title screen")
    love.graphics.print("game by Ricardo Bustamante and Vanessa Karla", 0, 20)
    love.graphics.print("\"Mighty Like Us\", \"Airship Serenity\" Kevin MacLeod (incompetech.com)", 0, 40)

    drawbutton(startbutton)
end

function titlescreen.mousepressed(x, y, button)
    if button == 1 and checkinside(x, y, startbutton) then
        currentscene = 2
    end
end

return titlescreen
