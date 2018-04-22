local game = {}

function game.init()
    ui = require("ui")
    calc = require("calc")
    player = require("player")
    player.init()

    local tiled = require("tiled/sti")
    map = tiled("maps/map.lua")

    sprites = {}
    sprites.bg = love.graphics.newImage("sprites/bg.png")
    sprites.player = love.graphics.newImage("sprites/ship.png")
    sprites.hudbg = love.graphics.newImage("sprites/hudbg.png")
    sprites.thrusterbg = love.graphics.newImage("sprites/thrusterbg.png")
    sprites.thrusterslider = love.graphics.newImage("sprites/thrusterslider.png")
    sprites.clockbg = love.graphics.newImage("sprites/clockbg.png")
    sprites.playbutton = love.graphics.newImage("sprites/playbutton.png")
    sprites.clockhand = love.graphics.newImage("sprites/clockhand.png")

    font =
        love.graphics.newImageFont(
        "font/font.png",
        ' abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`\'*#=[]"'
    )

    clock = newclock(375, 525, 65)

    playbutton = newbutton(510, 460, sprites.playbutton)

    sliderl = newslider(60)
    sliderr = newslider(210)

    --[[
        Game States:
        1 - Waiting for player input
        2 - Simulation
    ]]
    gamestate = 1

    maxtimer = 2

    thrusterl = 0
    thrusterr = 0
    timer = 0
    countdown = 0
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

    love.graphics.setFont(font)
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
