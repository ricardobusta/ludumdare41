local lg = love.graphics
local la = love.audio

function love.load()
    --[[
        Scenes:
        1 - Title Screen
        2 - Stage Select
        3 - Game
    ]]
    currentscene = 1

    -- Assets
    lg.setDefaultFilter("nearest", "nearest", 1)
    sprites = {
        bg = lg.newImage("sprites/bg.png"),
        player = lg.newImage("sprites/ship.png"),
        hudbg = lg.newImage("sprites/hudbg.png"),
        thrusterbg = lg.newImage("sprites/thrusterbg.png"),
        thrusterslider = lg.newImage("sprites/thrusterslider.png"),
        thrusterslideroff = lg.newImage("sprites/thrusterslideroff.png"),
        clockbg = lg.newImage("sprites/clockbg.png"),
        playbutton = lg.newImage("sprites/playbutton.png"),
        playbuttonoff = lg.newImage("sprites/playbuttonoff.png"),
        clockhand = lg.newImage("sprites/clockhand.png"),
        clockhandoff = lg.newImage("sprites/clockhandoff.png"),
        pinkbutton = lg.newImage("sprites/pinkbutton.png"),
        infopanel = lg.newImage("sprites/infopanel.png"),
        lightred = lg.newImage("sprites/lightred.png"),
        lightgreen = lg.newImage("sprites/lightgreen.png"),
        rotate = lg.newImage("sprites/rotateccw.png"),
        rocat = lg.newImage("sprites/rocat.png"),
        fire = lg.newImage("sprites/fire.png"),
        smallbutton = lg.newImage("sprites/smallbutton.png")
    }

    -- font from: https://love2d.org/wiki/File:Resource-Imagefont.png
    fonts = {
        small = lg.newImageFont(
            "font/font.png",
            ' abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`\'*#=[]"'
        ),
        panel = lg.newImageFont("font/panelfont.png", "1234567890.s%o ")
    }

    musics = {
        game = la.newSource("music/airshipserenity.mp3", "stream"),
        title = la.newSource("music/mightylikeus.mp3", "stream")
    }

    musics.game:setLooping(true)
    musics.game:setVolume(0.8)

    musics.title:setLooping(true)
    musics.title:play()
    musics.title:setVolume(0.8)

    currentmusic = musics.game

    -- Scenes
    game = require("scenes/game")
    titlescreen = require("scenes/titlescreen")
    stageselect = require("scenes/stageselect")

    -- Libraries
    lovesize = require("lovesize/lovesize")
    ui = require("ui")
    calc = require("calc")

    lovesize.set(800, 600)
    game.init()
    titlescreen.init()
    stageselect.init()

    local flags = {
        resizable = true
    }

    love.window.setMode(lovesize.getWidth(), lovesize.getHeight(), flags)
    love.window.setTitle("Ro'Cat Science! - Ludum Dare 41")
end

function love.update(dt)
    if currentscene == 1 then
        titlescreen.update(dt)
    elseif currentscene == 2 then
        stageselect.update(dt)
    elseif currentscene == 3 then
        game.update(dt)
    end
end

function love.draw()
    lg.clear(0.91, 0.78, 0.46)
    lovesize.begin()
    if currentscene == 1 then
        titlescreen.draw()
    elseif currentscene == 2 then
        stageselect.draw()
    elseif currentscene == 3 then
        game.draw()
    end
    lovesize.finish()
end

function love.resize(x, y)
    lovesize.resize(x, y)
end

function love.mousepressed(x, y, button, istouch)
    local mx, my = lovesize.pos(x, y)
    if currentscene == 1 then
        titlescreen.mousepressed(mx, my, button)
    elseif currentscene == 2 then
        stageselect.mousepressed(mx, my, button)
    elseif currentscene == 3 then
        game.mousepressed(mx, my, button)
    end
end
