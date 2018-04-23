local game = {}

-- constants
local radtodeg = 180 / math.pi

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
local turns = 0

-- References
local lg = love.graphics
local la = love.audio
local lm = love.mouse

-- Sound
local thrustsrcl = la.newSource("sfx/thrust.wav", "static")
local thrustsrcr = la.newSource("sfx/thrust.wav", "static")
local explosion = la.newSource("sfx/explosion.wav", "static")

-- Game Constants
maxtimer = 2

--[[
    Game States:
    1 - Waiting for player input
    2 - Simulation
    3 - Game Over
    4 - Win
]]
gamestate = 1

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

    clock = newclock(540, 575, 65)

    playbutton = newbutton(660, 460, sprites.playbutton)

    local x = 320
    sliderl = newslider(x, -1)
    sliderboth = newslider(x + 40, 0)
    sliderr = newslider(x + 80, 1)
end

function game.draw()
    lg.draw(sprites.bg, 0, 0)
    map:drawLayer(tiles)
    player.draw()
    lg.draw(sprites.hudbg, 0, 448)
    drawslider(sliderl)
    drawslider(sliderr)
    drawclock(clock)
    drawbutton(playbutton)

    local panx = 35
    local pany = 463
    lg.setFont(fonts.panel)
    lg.draw(sprites.infopanel, 35, 463)
    lg.print(string.format("%03.0f", thrusterl * 100) .. "%", panx + 100, pany + 92)
    lg.print(string.format("%03.0f", thrusterr * 100) .. "%", panx + 189, pany + 92)

    lg.printf(math.floor(speed), panx, pany + 8, 113, "right")
    lg.printf(math.abs(math.floor(rotspeed * radtodeg)), panx, pany + 42, 113, "right")
    lg.printf(turns, panx, pany + 92, 80, "right")
end

function game.update(dt)
    if gamestate == 1 then
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
                thrusterr = sliderr.v
                thrusterl = sliderl.v
            elseif -- Check collision with clock
                clickclock(x, y, clock) then
                timer = clock.v
            end
        end
    elseif gamestate == 2 then
        -- Timer finished
        if countdown <= 0 then
            gamestate = 1
            clock.v = timer
            thrustsrcl:stop()
            thrustsrcr:stop()
            playbutton.sprite = sprites.playbutton
            return
        end
        countdown = countdown - dt
        clock.v = math.floor(100 * countdown) / 100

        if player.islanded() then
            return
        end
        -- Main loop
        player.thrust(thrusterl, thrusterr)
        player.update(dt)

        speed, rotspeed = player.getinfo()

        -- Collision
        if player.detectcollision(tiles.data) then
            if player.isdead() then
                gamestate = 3
                explosion:play()
            elseif win then
                -- Landed objective!
                gamestate = 3
            else
                -- Landed start
                player.land()
            end
            thrustsrcl:stop()
            thrustsrcr:stop()
        end
    end
end

function game.mousepressed(x, y, button)
    if gamestate == 1 and button == 1 then
        -- Check collision with play button
        if checkinside(x, y, playbutton) then
            gamestate = 2
            countdown = timer
            player.fly()
            turns = turns + 1
            playbutton.sprite = sprites.playbuttonoff
            if thrusterl > 0 then
                thrustsrcr:setPitch(thrusterl * 0.8 + 0.2)
                thrustsrcl:play()
            end
            if thrusterr > 0 then
                thrustsrcl:setPitch(thrusterr * 0.8 + 0.2)
                thrustsrcr:play()
            end
        end
    end
end

return game
