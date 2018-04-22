local game = {}

-- Game Objects
local player = require("player")
local map = nil
local clock = nil
local playbutton = nil
local sliderl = nil
local sliderr = nil
local thrusterl = 0
local thrusterr = 0
local timer = 0
local countdown = 0

-- Game Constants
local maxtimer = 2

--[[
    Game States:
    1 - Waiting for player input
    2 - Simulation
]]
local gamestate = 1

function game.init()
    player.init()

    local tiled = require("tiled/sti")
    map = tiled("maps/map.lua")

    clock = newclock(375, 525, 65)

    playbutton = newbutton(510, 460, sprites.playbutton)

    sliderl = newslider(60)
    sliderr = newslider(210)
end

function game.update(dt)
    if gamestate == 1 then
    elseif gamestate == 2 then
        if countdown <= 0 then
            gamestate = 1
            clock.v = timer / maxtimer
            return
        end
        player.thrust(thrusterl, thrusterr)
        player.update(dt)
        countdown = countdown - dt
        clock.v = countdown / maxtimer
    end
end

function game.draw()
    love.graphics.draw(sprites.bg, 0, 0)
    map:drawLayer(map.layers["Tiles1"])
    player.draw()
    love.graphics.draw(sprites.hudbg, 0, 448)
    drawslider(sliderl)
    drawslider(sliderr)
    drawclock(clock)
    drawbutton(playbutton)

    love.graphics.setFont(fonts.small)
    love.graphics.print("Thruster: " .. thrusterl * 100 .. "% " .. thrusterr * 100 .. "%", 0, 0)
    love.graphics.print("Time: " .. timer, 0, 20)
end

function game.mousepressed(x, y, button)
    if gamestate == 1 and button == 1 then
        -- Check collision with sliders
        if clickslider(x, y, sliderl) then
            thrusterl = sliderl.v
        end
        if clickslider(x, y, sliderr) then
            thrusterr = sliderr.v
        end
        -- Check collision with clock
        if clickclock(x, y, clock) then
            timer = clock.v * maxtimer
        end
        -- Check collision with play button
        if checkinside(x, y, playbutton) then
            gamestate = 2
            countdown = timer
        end
    end
end

return game
