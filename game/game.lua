local game = {}

function game.init()
    local tiled = require("tiled/sti")
    map = tiled("maps/map.lua")
end

function game.update(dt)
end

function game.draw()
    love.graphics.clear(0.42, 0.65, 0.67)

    map:drawLayer(map.layers["Tiles1"])
    love.graphics.rectangle("fill", 0, 448, 800, 152)
end

return game
