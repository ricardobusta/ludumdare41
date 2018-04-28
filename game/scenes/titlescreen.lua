local startbutton = nil
local quitbutton = nil

local lg = love.graphics

local titlescreen = {
    init = function()
        startbutton = newbutton(500, 250, sprites.pinkbutton, "Start", 8)
        quitbutton = newbutton(500, 350, sprites.pinkbutton, "Quit", 8)
    end,
    update = function(dt)
    end,
    draw = function()
        lg.draw(sprites.rocat)
        lg.setFont(fonts.small)
        lg.printf("Game by Ricardo Bustamante and Vanessa Karla", 0, 540, 800, "center")
        lg.printf("Ludum Dare 41 - Game Jam! - apr 2018", 0, 560, 800, "center")
        lg.printf(
            'Music: "Mighty Like Us", "Airship Serenity" by Kevin MacLeod (incompetech.com)',
            0,
            580,
            800,
            "center"
        )

        drawbutton(startbutton)
        drawbutton(quitbutton)
    end,
    mousepressed = function(x, y, button)
        if button == 1 and checkinside(x, y, startbutton) then
            currentscene = 2
        end
        if button == 1 and checkinside(x, y, quitbutton) then
            love.event.quit()
        end
    end
}

return titlescreen
