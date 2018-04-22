function love.load()
    --[[
        Scenes:
        1 - Title Screen
        2 - Stage Select
        3 - Game
    ]]
    currentscene = 3

    -- Assets

    sprites = {}
    sprites.bg = love.graphics.newImage("sprites/bg.png")
    sprites.player = love.graphics.newImage("sprites/ship.png")
    sprites.hudbg = love.graphics.newImage("sprites/hudbg.png")
    sprites.thrusterbg = love.graphics.newImage("sprites/thrusterbg.png")
    sprites.thrusterslider = love.graphics.newImage("sprites/thrusterslider.png")
    sprites.clockbg = love.graphics.newImage("sprites/clockbg.png")
    sprites.playbutton = love.graphics.newImage("sprites/playbutton.png")
    sprites.clockhand = love.graphics.newImage("sprites/clockhand.png")
    sprites.pinkbutton = love.graphics.newImage("sprites/pinkbutton.png")

    -- font from: https://love2d.org/wiki/File:Resource-Imagefont.png
    fonts = {}
    fonts.small =
        love.graphics.newImageFont(
        "font/font.png",
        ' abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`\'*#=[]"'
    )

    musics = {}
    musics.game = love.audio.newSource("music/airshipserenity.mp3", "stream")
    musics.game:setLooping(true)
    musics.title = love.audio.newSource("music/mightylikeus.mp3", "stream")
    musics.title:setLooping(true)
    musics.title:play()

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

    local flags = {}
    flags.resizable = true
    love.window.setMode(lovesize.getWidth(), lovesize.getHeight(), flags)

    love.window.setTitle("Ludum Dare 41 - Ricardo & Vanessa")
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
    love.graphics.clear(0.91, 0.78, 0.46)
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
