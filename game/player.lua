local player = {}

-- Constant Parameters
local twopi = math.pi*2
local size = 16 -- spaceship size
local tileradius = 16*math.sqrt(2)
local tacc = 200 -- thruster acceleration
local grav = 80 -- gravity
local deadlyspeed = 100
local minangle = math.pi/6 
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

-- References
local lg = love.graphics
local sprite = nil
local sprx = 0
local spry = 0

function player.init()
    sprite = sprites.player
    sprx = sprite:getWidth()/2
    spry = sprite:getHeight()/2
end

function player.thrust(l, r)
    sl = l
    sr = r
    accrot = 10 * (l - r)
end

function player.update(dt)
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
    -- love.graphics.circle("fill", px, py, size)
    lg.draw(sprite, px, py, rot, nil, nil, sprx, spry)
end

function player.getinfo()
    return speed, srot, tx, ty, dead
end

function player.detectcollision(tiles, ox, oy)
    local x, y = tx + ox, ty + oy
    local mx, my = x + 1, y + 1
    if tiles[my] and tiles[my][mx] and collidewithtile(x,y) then
        if tiles[my][mx].id >= 12 and survivableconditions() then
            dead = false
        else
            dead = true
        end
        return true
    end
    return false
end

local function survivableconditions()
    return speed < deadlyspeed and (rot > maxangle or rot < minangle)
end

local function collidewithtile(x, y)
    if 
end

function player.debugcollision(tiles, ox, oy)
    local x, y = tx + ox, ty + oy
    local mx, my = x + 1, y + 1
    if tiles[my] and tiles[my][mx] then
        lg.print(tiles[my][mx].id, x * 32, y * 32)
    end
    lg.print(x .. " " .. y .. " " .. rot)

    lg.rectangle("line", x * 32, y * 32, 32, 32)
end

return player
