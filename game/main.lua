game = require("game")
lovesize = require("lovesize/lovesize")

function love.load()
    lovesize.set(800, 600)
    game.init()

    local flags = {}
    flags.resizable = true
    love.window.setMode(lovesize.getWidth(), lovesize.getHeight(), flags)
end

function love.update(dt)
    game.update(dt)
end

function love.draw()
    love.graphics.clear(0.91, 0.78, 0.46)
    lovesize.begin()
    game.draw()
    lovesize.finish()
end

function love.resize(x, y)
    lovesize.resize(x, y)
end
