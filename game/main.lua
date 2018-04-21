game = require("game")
lovesize = require("lovesize/lovesize")

function love.load()
    lovesize.set(800, 600)
    game.init()

    local flags = {}
    flags.resizable = true
    love.window.setMode(lovesize.getWidth(), lovesize.getHeight(), flags)

    love.window.setTitle("Ludum Dare 41 - Ricardo & Vanessa")
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

function love.mousepressed(x, y, button, istouch)
    local mx, my = lovesize.pos(x, y)
    game.mousepressed(mx, my, button)
end
