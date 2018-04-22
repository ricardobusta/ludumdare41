local game = {}

-- Game Objects
local player = require("player")
local map = nil
local tiles = nil
local clock = nil
local playbutton = nil
local sliderl = nil
local sliderr = nil
local sliderboth = nil
local thrusterl = 0
local thrusterr = 0
local timer = 0
local countdown = 0
local speed = 0
local rotspeed = 0
local tilex = 0
local tiley = 0
local dead = false

-- References
local lg = love.graphics
local la = love.audio
local lm = love.mouse

-- Sound
local thrustsrcl = la.newSource("sfx/thrust.wav", "static")
local thrustsrcr = la.newSource("sfx/thrust.wav", "static")
local explosion = la.newSource("sfx/explosion.wav", "static")

-- Game Constants
local maxtimer = 2

--[[
    Game States:
    1 - Waiting for player input
    2 - Simulation
    3 - Game Over
    4 - Win
]]
local gamestate = 1

function game.init()
    player.init()

    thrustsrcl:setLooping(true)
    thrustsrcl:setVolume(0.5)

    thrustsrcr:setLooping(true)
    thrustsrcr:setVolume(0.5)

    explosion:setVolume(0.8)

    local tiled = require("tiled/sti")
    map = tiled("maps/map.lua")
    tiles = map.layers["Tiles1"]

    clock = newclock(375, 525, 65)

    playbutton = newbutton(510, 460, sprites.playbutton)

    sliderl = newslider(60)
    sliderr = newslider(210)
    sliderboth = newslider(130)
end

function game.draw()
    lg.draw(sprites.bg, 0, 0)
    map:drawLayer(tiles)
    player.draw()
    lg.draw(sprites.hudbg, 0, 448)
    drawslider(sliderl)
    drawslider(sliderr)
    drawslider(sliderboth)
    drawclock(clock)
    drawbutton(playbutton)

    lg.setFont(fonts.small)
    lg.print("Thruster: " .. thrusterl * 100 .. "% " .. thrusterr * 100 .. "%", 30, lg.getHeight() - 30)
    lg.print("Speed: " .. speed, 30, lg.getHeight() - 60)
    lg.print("Rot Speed: " .. rotspeed, 30, lg.getHeight() - 90)
    lg.print("Time: " .. timer, clock.x, clock.y)

    -- player.debugcollision(tiles.data, 0, 0)
    -- player.debugcollision(tiles.data, 1, 0)
    -- player.debugcollision(tiles.data, 0, 1)
    -- player.debugcollision(tiles.data, 1, 1)
end

function game.update(dt)
    if gamestate == 1 then
    elseif gamestate == 2 then
        -- Timer finished
        if countdown <= 0 then
            gamestate = 1
            clock.v = timer / maxtimer
            thrustsrcl:stop()
            thrustsrcr:stop()
            return
        end
        -- Main loop
        player.thrust(thrusterl, thrusterr)
        player.update(dt)
        countdown = countdown - dt
        clock.v = countdown / maxtimer
        speed, rotspeed, tilex, tiley, dead = player.getinfo()

        -- Collision
        local collide = player.detectcollision(tiles.data, 0, 0) or player.detectcollision(tiles.data, 1, 0)
        collide = collide or player.detectcollision(tiles.data, 0, 1) or player.detectcollision(tiles.data, 1, 1)
        if collide then
            if dead == true then
                gamestate = 3
                thrustsrcl:stop()
                thrustsrcr:stop()
                explosion:play()
            end
        end
    end

    if lm.isDown(1) then
        local x, y = lovesize.pos(lm:getX(), lm:getY())
        -- Check collision with sliders
        if clickslider(x, y, sliderl) then
            thrusterl = sliderl.v
        elseif clickslider(x, y, sliderr) then
            thrusterr = sliderr.v
        elseif clickslider(x, y, sliderboth) then
            sliderl.v = sliderboth.v
            sliderr.v = sliderboth.v
        elseif -- Check collision with clock
            clickclock(x, y, clock) then
            timer = clock.v * maxtimer
        end
    end
end

function game.mousepressed(x, y, button)
    if gamestate == 1 and button == 1 then
        -- Check collision with play button
        if checkinside(x, y, playbutton) then
            gamestate = 2
            countdown = timer
            thrustsrcl:setPitch(thrusterr * 0.8 + 0.2)
            thrustsrcr:setPitch(thrusterl * 0.8 + 0.2)
            thrustsrcl:play()
            thrustsrcr:play()
        end
    end
end

return game
