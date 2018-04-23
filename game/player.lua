local player = {}

-- Constant Parameters
local twopi = math.pi * 2
local size2 = 32
local size = size2 / 2
local tileship2 = (size * math.sqrt(2) + size) ^ 2 -- max distance to the center of the tile to the center of the ship
local tacc = 200 -- thruster acceleration
local grav = 80 -- gravity
local deadlyspeed = 100
local minangle = math.pi / 6
local maxangle = twopi - minangle

-- Player State
local px, py = 100, 100 -- position x, y
local sx, sy = 0, 0 -- speed x, y
local rot = 0 -- rotation
local accrot = 0 -- rotation acceleration
local srot = 0 -- rotation speed
local sl, sr = 0, 0 -- speed from thrusters
local tx, ty = 0, 0 -- player in tile coordinates
local speed = 0
local dead = false
local landed = false

-- References
local lg = love.graphics
local sprite = nil
local sprx = 0
local spry = 0

function player.init()
    sprite = sprites.player
    sprx = sprite:getWidth() / 2
    spry = sprite:getHeight() / 2
end

function player.thrust(l, r)
    sl = l
    sr = r
    accrot = 10 * (l - r)
end

function player.update(dt)
    if landed then
        return
    end
    local acc = tacc * (sl + sr) -- acceleration is the sum of both thrusters

    -- Accelerate the ship
    sx = sx + acc * math.sin(rot) * dt
    sy = sy + -acc * math.cos(rot) * dt + grav * dt
    srot = srot + accrot * dt

    -- Move the ship
    px = px + sx * dt
    py = py + sy * dt
    rot = rot + srot * dt
    rot = rot % twopi

    -- Update coords
    tx = math.floor((px - 16) / 32)
    ty = math.floor((py - 16) / 32)
    speed = math.sqrt(sx ^ 2 + sy ^ 2)
end

function player.draw()
    lg.draw(sprite, px, py, rot, nil, nil, sprx, spry)
end

function player.getinfo()
    return speed, srot
end

local debugstring = ""

function player.detectcollision(tiles)
    local mx, my = (tx + 1), (ty + 1) -- center in tile coord
    local cx, cy = tx * size2 + size, ty * size2 + size -- center in pixel coord

    dead = false
    local collide = false

    collide =
        collidewithtile(tiles, tx, ty) or collidewithtile(tiles, tx + 1, ty) or collidewithtile(tiles, tx + 1, ty + 1) or
        collidewithtile(tiles, tx, ty + 1)

    debugstring = string.format("%s",collide)

    return collide
end

function collidewithtile(tiles, x, y)
    local mx, my = (x + 1), (y + 1) -- center in tile coord
    local cx, cy = x * size2 + size, y * size2 + size -- center in pixel coord

    if tiles[my] and tiles[my][mx] then
        if math.abs(px - cx) <= size or math.abs(py - cy) <= size or distanceto2(cx, cy, px, py) <= tileship2 then
            if tiles[my][mx].id < 12 or player.dieconditions()  then
                dead = true
            end
            return true
        end
    end
    return false
end

function player.dieconditions()
    return (speed >= deadlyspeed or (rot <= maxangle and rot >= minangle))
end

function player.debugcollision(tiles)
    player.debugcollisiontile(tiles, 0, 0)
    player.debugcollisiontile(tiles, 1, 0)
    player.debugcollisiontile(tiles, 0, 1)
    player.debugcollisiontile(tiles, 1, 1)

    lg.circle("line", px, py, 16)
    lg.print(debugstring .. string.format("%s",player.dieconditions()), 0, 60)
end

function player.debugcollisiontile(tiles, ox, oy)
    local x, y = tx + ox, ty + oy
    local mx, my = x + 1, y + 1
    if tiles[my] and tiles[my][mx] then
        lg.print(tiles[my][mx].id, x * 32, y * 32)
    end
    lg.print(debugstring)

    lg.rectangle("line", x * 32, y * 32, 32, 32)
end

function player.debugposition()
    local x, y = lovesize.pos(love.mouse.getX(), love.mouse.getY())
    px, py = x, y
end

function player.land()
    landed = true
    sx = 0
    sy = 0
    rot = 0
    srot = 0
    py = math.floor((py+16)/32)*32-16
end

function player.fly()
    landed = false
end

function player.islanded()
    return landed
end

function player.isdead()
    return dead
end

return player
