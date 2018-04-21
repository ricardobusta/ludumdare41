local player = {}

-- Constant Parameters
local size = 16 -- spaceship size
local tacc = 200 -- thruster acceleration
local grav = 80 -- gravity

-- Player State
local px, py = 100, 100 -- position x, y
local sx, sy = 0, 0 -- speed x, y
local rot = 0 -- rotation
local srot = 0 -- rotation speed
local sl, sr = 0, 0 -- speed from thrusters

function player.init()
end

function player.thrust(l, r)
    sl = l
    sr = r
    srot = 10 * (l - r)
end

function player.update(dt)
    local acc = tacc * (sl + sr) -- acceleration is the sum of both thrusters

    -- Accelerate the ship
    sx = sx + acc * math.sin(rot) * dt
    sy = sy + -acc * math.cos(rot) * dt + grav * dt

    -- Move the ship
    px = px + sx * dt
    py = py + sy * dt
    rot = rot + srot * dt
end

function player.draw()
    -- love.graphics.circle("fill", px, py, size)
    love.graphics.draw(sprites.player, px, py, rot, nil, nil, 16, 16)
end

return player
