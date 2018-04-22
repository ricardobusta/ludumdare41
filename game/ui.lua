-- General UI functions
function checkinside(x, y, button)
    return x >= button.x and x < (button.x + button.w) and y >= button.y and y < (button.y + button.h)
end

-- Sliders
function newslider(x)
    local slider = {}
    slider.x = x
    slider.y = 460
    slider.w = 50
    slider.h = 130
    slider.v = 0
    slider.bg = sprites.thrusterbg
    slider.hand = sprites.thrusterslider

    return slider
end

function drawslider(slider)
    love.graphics.draw(slider.bg, slider.x, slider.y)
    love.graphics.draw(
        slider.hand,
        slider.x,
        slider.y + (1 - slider.v) * slider.h,
        nil,
        nil,
        nil,
        0,
        slider.hand:getHeight() / 2
    )
end

function clickslider(x, y, slider)
    if checkinside(x, y, slider) then
        local v = 1 - (y - (slider.y + 5)) / (slider.h - 10)
        v = math.floor(v * 100) / 100
        v = math.min(1, math.max(0, v))
        slider.v = v
        return true
    end
    return false
end

-- Buttons
function newbutton(x, y, sprite, text, textoffset)
    local button = {}
    button.x = x
    button.y = y
    button.w = sprite:getWidth()
    button.h = sprite:getHeight()
    button.sprite = sprite
    button.text = text or ""
    button.toff = textoffset or 0

    return button
end

function drawbutton(button)
    love.graphics.draw(button.sprite, button.x, button.y)
    love.graphics.printf(button.text, button.x, button.y + button.h / 2 - button.toff, button.w, "center")
end

-- Clocks
function newclock(x, y, r)
    local clock = {}
    clock.x = x
    clock.y = y
    clock.r = r
    clock.bg = sprites.clockbg
    clock.hand = sprites.clockhand
    clock.v = 0
    clock.hox = 5
    clock.hoy = sprites.clockhand:getHeight() / 2
    return clock
end

function clickclock(x, y, clock)
    if distanceto(x, y, clock.x, clock.y) < clock.r then
        clock.v = 0.5 - (anglebetween(clock.y, clock.x, y, x) / (math.pi * 2))
        clock.v = math.ceil(clock.v * 100) / 100
        return true
    end
    return false
end

function drawclock(clock)
    love.graphics.draw(clock.bg, clock.x, clock.y, nil, nil, nil, clock.r, clock.r)
    love.graphics.draw(
        clock.hand,
        clock.x,
        clock.y,
        clock.v * (2 * math.pi) - math.pi / 2,
        nil,
        nil,
        clock.hox,
        clock.hoy
    )
end
