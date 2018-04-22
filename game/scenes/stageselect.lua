local stageselect = {}

function stageselect.init()
end

function stageselect.update(dt)
end

function stageselect.draw()
    love.graphics.setFont(fonts.small)
    love.graphics.print("stage select")
end

function stageselect.mousepressed(x, y, button)
end

return stageselect
