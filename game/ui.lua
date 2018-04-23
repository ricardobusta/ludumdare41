-- General UI functions
function checkinside(x, y, button)
    return x >= button.x and x < (button.x + button.w) and y >= button.y and y < (button.y + button.h)
end

-- Sliders
function newslider(x, n)
    local slider = {}
    slider.x = x
    slider.y = 460
    slider.w = 40
    slider.h = 130
    slider.v = 0
    slider.n = n
    slider.bg = sprites.thrusterbg
    slider.hand = sprites.thrusterslider
    slider.handoff = sprites.thrusterslideroff

    return slider
end

function drawslider(slider)
    love.graphics.draw(slider.bg, slider.x, slider.y)
    
    local handsprite = nil
    if gamestate == 1 then
        handsprite = slider.hand
    else
        handsprite = slider.handoff
    end

    local handx = slider.x
    local ofx = 0
    local handy = slider.y + (1 - slider.v) * slider.h
    if slider.n == 1 then
        handx = handx - 20
    else
        ofx = handsprite:getWidth()
    end

    love.graphics.draw(handsprite, handx, handy, nil, slider.n, 1, ofx, handsprite:getHeight() / 2)
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
    clock.handoff = sprites.clockhandoff
    clock.v = 0
    clock.hox = 5
    clock.hoy = 5
    return clock
end

function clickclock(x, y, clock)
    if y <= clock.y and distanceto(x, y, clock.x, clock.y) < clock.r then
        clock.v = (anglebetween(x, y, clock.x, clock.y) / (math.pi))
        clock.v = math.ceil(maxtimer * clock.v * 100) / 100
        return true
    elseif y <= clock.y + 5 and y > clock.y then
        if x < clock.x then
            clock.v = 0
        else
            clock.v = maxtimer
        end
    end
    return false
end

function drawclock(clock)
    love.graphics.draw(clock.bg, clock.x, clock.y, nil, nil, nil, clock.r, 122)
    local rot = (clock.v/maxtimer) * (math.pi) - math.pi

    local clocksprite = nil
    if gamestate == 1 then
        clocksprite = clock.hand
    else
        clocksprite = clock.handoff
    end
    love.graphics.draw(clocksprite, clock.x, clock.y, rot, nil, nil, clock.hox, clock.hoy)
    love.graphics.setFont(fonts.panel)
    love.graphics.printf("Time: " .. string.format("%1.2f",clock.v) .. "s", clock.x - clock.r, clock.y - 95, clock.r*2 - 20, "right")
end
