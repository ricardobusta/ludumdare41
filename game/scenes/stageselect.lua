local stageselect = {}

local buttons = {}

local stage1 = nil
local stage2 = nil
local stage3 = nil
local stage4 = nil

local back = nil

function stageselect.init()
    stage1 = newbutton(300, 100, sprites.pinkbutton, "stage 1", 8)
    stage2 = newbutton(300, 200, sprites.pinkbutton, "stage 2", 8)
    stage3 = newbutton(300, 300, sprites.pinkbutton, "stage 3", 8)
    stage4 = newbutton(300, 400, sprites.pinkbutton, "stage 4", 8)
    back = newbutton(50, 500, sprites.pinkbutton, "back", 8)

    table.insert(buttons, stage1)
    table.insert(buttons, stage2)
    table.insert(buttons, stage3)
    table.insert(buttons, stage4)
end

function stageselect.update(dt)
end

function stageselect.draw()
    love.graphics.setFont(fonts.small)
    love.graphics.print("stage select")

    for _, b in ipairs(buttons) do
        drawbutton(b)
    end
    drawbutton(back)
end

function stageselect.mousepressed(x, y, button)
    if button == 1 then
        if checkinside(x, y, back) then
            currentscene = 1
        end
        for _, b in ipairs(buttons) do
            if checkinside(x, y, b) then
                currentscene = 3
                musics.title:stop()
                musics.game:play()
            end
        end
    end
end

return stageselect
