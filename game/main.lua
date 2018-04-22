game = require("game")
titlescreen = require("scenes/titlescreen")
lovesize = require("lovesize/lovesize")

--[[
    Scenes:
    1 - Title Screen
    2 - Stage Select
    3 - Game
    4 - Credits
]]
currentscene = 1

function love.load()
    lovesize.set(800, 600)
    game.init()

    local flags = {}
    flags.resizable = true
    love.window.setMode(lovesize.getWidth(), lovesize.getHeight(), flags)

    love.window.setTitle("Ludum Dare 41 - Ricardo & Vanessa")
end

function love.update(dt)
    if currentscene == 1 then
    elseif currentscene == 2 then
    elseif currentscene == 3 then
    elseif currentscene == 4 then
        game.update(dt)
    end
end

function love.draw()
    love.graphics.clear(0.91, 0.78, 0.46)
    lovesize.begin()
    if currentscene == 1 then
    elseif currentscene == 2 then
    elseif currentscene == 3 then
    elseif currentscene == 4 then
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
    elseif currentscene == 2 then
    elseif currentscene == 3 then
    elseif currentscene == 4 then
        game.mousepressed(mx, my, button)
    end
end
