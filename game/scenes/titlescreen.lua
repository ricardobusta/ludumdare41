local titlescreen = {}

local startbutton = nil
local quitbutton = nil

local player = require("player")

function titlescreen.init()
    startbutton = newbutton(500, 250, sprites.pinkbutton, "start game", 8)
    quitbutton = newbutton(500, 350, sprites.pinkbutton, "quit game", 8)
end

function titlescreen.update(dt)
end

function titlescreen.draw()
    love.graphics.draw(sprites.rocat)
    love.graphics.setFont(fonts.small)
    love.graphics.printf("Game by Ricardo Bustamante and Vanessa Karla", 0, 540, 800, "center")
    love.graphics.printf("Ludum Dare 41 - Game Jam! - apr 2018", 0, 560, 800, "center")
    love.graphics.printf(
        'Music: "Mighty Like Us", "Airship Serenity" by Kevin MacLeod (incompetech.com)',
        0,
        580,
        800,
        "center"
    )

    drawbutton(startbutton)
    drawbutton(quitbutton)
end

function titlescreen.mousepressed(x, y, button)
    if button == 1 and checkinside(x, y, startbutton) then
        currentscene = 2
    end
    if button == 1 and checkinside(x, y, quitbutton) then
        love.event.quit()
    end
end

return titlescreen
