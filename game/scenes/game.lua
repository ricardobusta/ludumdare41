local game = {}

-- constants
local radtodeg = 180 / math.pi

-- Game Objects
local player = require("player")
local tiled = require("tiled/sti")
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

    game.playagain()

    clock = newclock(540, 575, 65)

    playbutton = newbutton(635, 512, sprites.playbutton)

    resetbutton = newbutton(730, 480, sprites.lightred, "Reset", 5)
    quitbutton = newbutton(730, 550, sprites.lightred, "Quit", 5)

    resetbutton2 = newbutton(400, 300, sprites.pinkbutton, "Reset", 7)
    quitbutton2 = newbutton(400, 350, sprites.pinkbutton, "Quit", 7)

    local x = 310
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

    -- Draw light
    local light = nil
    if player.dieconditions() then
        light = sprites.lightred
    else
        light = sprites.lightgreen
    end
    lg.draw(light, 650, 463)

    -- Draw info panel
    local panx = 35
    local pany = 463
    lg.setFont(fonts.panel)
    lg.draw(sprites.infopanel, panx, pany)
    lg.print(string.format("%03.0f", thrusterl * 100) .. "%", panx + 100, pany + 92)
    lg.print(string.format("%03.0f", thrusterr * 100) .. "%", panx + 189, pany + 92)

    lg.printf(math.floor(speed), panx, pany + 8, 113, "right")
    lg.printf(math.abs(math.floor(rotspeed * radtodeg)), panx, pany + 42, 113, "right")
    lg.printf(turns, panx, pany + 92, 80, "right")
    if rotspeed > 0.01 or rotspeed < -0.01 then
        local s = 1
        if rotspeed > 0 then
            s = -1
        end
        lg.draw(
            sprites.rotate,
            panx + 197,
            pany + 37,
            nil,
            s,
            1,
            sprites.rotate:getWidth() / 2,
            sprites.rotate:getHeight() / 2
        )
    end

    drawbutton(resetbutton)
    drawbutton(quitbutton)

    -- Draw info popup
    if gamestate >= 3 then
        lg.setColor(0, 0, 0, 0.7)
        lg.rectangle("fill", 0, 0, 800, 600)
        lg.setColor(1, 1, 1, 1)
        lg.setFont(fonts.small)
        local msg = ""
        if gamestate == 3 then
            msg = "Game Over!"
        else
            msg = "You Win!"
        end
        lg.printf(msg, 0, 200, 800, "center")
        lg.printf("Number of turns: " .. turns, 0, 250, 800, "center")

        drawbutton(resetbutton2)
        drawbutton(quitbutton2)
    end
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
    if button == 1 then
        if gamestate == 1 then
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

        if gamestate <= 2 then
            if checkinside(x, y, resetbutton) then
                game.playagain()
            end

            if checkinside(x, y, quitbutton) then
                game.quit()
            end
        elseif gamestate >= 3 then
            if checkinside(x, y, resetbutton2) then
                game.playagain()
            end

            if checkinside(x, y, quitbutton2) then
                game.quit()
            end
        end
    end
end

function game.playagain()
    map = tiled("maps/map.lua")
    tiles = map.layers["Tiles1"]
    player.setpos(100, 100)
    player.reset()
    gamestate = 1
    player.fly()
end

function game.quit()
    musics.title:play()
    musics.game:stop()
    currentscene = 1
end

return game
