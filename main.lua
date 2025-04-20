local background = display.newRect(480, 480, 960, 960)
background:setFillColor(0, 1, 0)

local board = display.newGroup()
for x = 1, 15 do
    local row = display.newGroup()
    for y = 1, 15 do
        local grid = display.newRect(row, 30 + 30 * (2 * x - 1), 30 + 30 * (2 * y - 1), 60, 60)
        if ((x + y) % 2 > 0) then grid:setFillColor(0.6, 0.6, 0.6, 0.2) else grid:setFillColor(0.4, 0.4, 0.4, 0.2) end
    end
    board:insert(row)
end

local arr = {}
for x = 1, 15 do
    arr[x] = {}
    for y = 1, 15 do arr[x][y] = false end
end