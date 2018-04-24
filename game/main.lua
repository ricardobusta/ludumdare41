function love.load()
    --[[
        Scenes:
        1 - Title Screen
        2 - Stage Select
        3 - Game
    ]]
    currentscene = 1

    -- Assets
    love.graphics.setDefaultFilter("nearest", "nearest", 1)
    sprites = {}
    sprites.bg = love.graphics.newImage("sprites/bg.png")
    sprites.player = love.graphics.newImage("sprites/ship.png")
    sprites.hudbg = love.graphics.newImage("sprites/hudbg.png")
    sprites.thrusterbg = love.graphics.newImage("sprites/thrusterbg.png")
    sprites.thrusterslider = love.graphics.newImage("sprites/thrusterslider.png")
    sprites.thrusterslideroff = love.graphics.newImage("sprites/thrusterslideroff.png")
    sprites.clockbg = love.graphics.newImage("sprites/clockbg.png")
    sprites.playbutton = love.graphics.newImage("sprites/playbutton.png")
    sprites.playbuttonoff = love.graphics.newImage("sprites/playbuttonoff.png")
    sprites.clockhand = love.graphics.newImage("sprites/clockhand.png")
    sprites.clockhandoff = love.graphics.newImage("sprites/clockhandoff.png")
    sprites.pinkbutton = love.graphics.newImage("sprites/pinkbutton.png")
    sprites.infopanel = love.graphics.newImage("sprites/infopanel.png")
    sprites.lightred = love.graphics.newImage("sprites/lightred.png")
    sprites.lightgreen = love.graphics.newImage("sprites/lightgreen.png")
    sprites.rotate = love.graphics.newImage("sprites/rotateccw.png")
    sprites.rocat = love.graphics.newImage("sprites/rocat.png")
    sprites.fire = love.graphics.newImage("sprites/fire.png")
    sprites.smallbutton = love.graphics.newImage("sprites/smallbutton.png")

    -- font from: https://love2d.org/wiki/File:Resource-Imagefont.png
    fonts = {}
    fonts.small =
        love.graphics.newImageFont(
        "font/font.png",
        ' abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`\'*#=[]"'
    )
    fonts.panel = love.graphics.newImageFont("font/panelfont.png", "1234567890.s%o ")

    musics = {}
    musics.game = love.audio.newSource("music/airshipserenity.mp3", "stream")
    musics.game:setLooping(true)
    musics.game:setVolume(0.8)
    musics.title = love.audio.newSource("music/mightylikeus.mp3", "stream")
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

    local flags = {}
    flags.resizable = true
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
