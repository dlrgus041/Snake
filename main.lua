-- front

local background1 = display.newRect(480, 480, 940, 940)
background1:setFillColor(1, 1, 1)

local background2 = display.newRect(480, 480, 910, 910)
background2:setFillColor(0, 0, 0)

local board = display.newGroup()
for x = 1, 30 do
    local col = display.newGroup()
    for y = 1, 30 do
        local grid = display.newRect(col, 30 + 15 * (2 * x - 1), 30 + 15 * (2 * y - 1), 30, 30)
        grid:setFillColor(0, 0, 0)
        -- if ((x + y) % 2 > 0) then grid:setFillColor(0.6, 0.6, 0.6, 0.2) else grid:setFillColor(0.4, 0.4, 0.4, 0.2) end
    end
    board:insert(col)
end

local appleImg = display.newCircle(480, 480, 10)
appleImg:setFillColor(1, 1, 1)
appleImg.isVisible = false

-- game over screen
local white = {
    [2] = {4, 5, 6, 12, 17, 21, 24, 25, 26, 27, 28},
    [3] = {3, 7, 11, 13, 17, 18, 20, 21, 24, 28},
    [4] = {3, 10, 14, 17, 19, 21, 24},
    [5] = {3, 10, 11, 12, 13, 14, 17, 19, 21, 24, 25, 26},
    [6] = {3, 6, 7, 10, 14, 17, 21, 24},
    [7] = {3, 7, 10, 14, 17, 21, 24, 28},
    [8] = {4, 5, 6, 10, 14, 17, 21, 24, 25, 26, 27, 28},
    [11] = {4, 5, 6, 10, 14, 17, 18, 19, 20, 21, 24, 25, 26, 27},
    [12] = {3, 7, 10, 14, 17, 21, 24, 28},
    [13] = {3, 7, 10, 14, 17, 24, 28},
    [14] = {3, 7, 10, 14, 17, 18, 19, 24, 25, 26, 27},
    [15] = {3, 7, 11, 13, 17, 24, 26},
    [16] = {3, 7, 11, 13, 17, 21, 24, 27},
    [17] = {4, 5, 6, 12, 17, 18, 19, 20, 21, 24, 28},
    [22] = {5, 6, 7, 8, 11, 12, 13, 14, 17, 18, 19, 20, 23, 24, 25, 26},
    [23] = {5, 8, 11, 14, 17, 20, 23, 26},
    [24] = {5, 8, 11, 14, 17, 20, 23, 26},
    [25] = {5, 8, 11, 14, 17, 20, 23, 26},
    [26] = {5, 6, 7, 8, 11, 12, 13, 14, 17, 18, 19, 20, 23, 24, 25, 26},
}

-- back
-- dir = {north = 0, east = 1, south = 2, west = 3}

-- local arr = {}
-- for x = 1, 15 do
--     arr[x] = {}
--     for y = 1, 15 do arr[x][y] = false end
-- end

local X
local Y
local tail
local head

local snake
local apple

local eat
local lock
local interval = -1
local over

-- functions

math.randomseed(os.time())

local function paintGrid(x, y, flag)
    if (flag == true) then
        board[x][y]:setFillColor(1, 1, 1)
    else
        board[x][y]:setFillColor(0, 0, 0)
    end
end

local function drawApple(flag)
    if (flag == true) then
        appleImg.x = 30 + 15 * (2 * apple.x - 1)
        appleImg.y = 30 + 15 * (2 * apple.y - 1)
    end
    appleImg.isVisible = flag
end

local function moveHead(x, y)
    head = head + 1
    if (head > 900) then head = 1 end
    X[head], Y[head] = x, y
end

local function moveTail()
    tail = tail + 1
    if (tail > 900) then tail = 1 end
end

local function isImpossible(x, y)
    if (head > tail) then
        for i = tail, head do
            if (X[i] == x and Y[i] == y) then return true end
        end
    else
        for i = tail, 900 do
            if (X[i] == x and Y[i] == y) then return true end
        end
        for i = 1, head do
            if (X[i] == x and Y[i] == y) then return true end
        end
    end
    return false
end

local function spawnApple()
    while (isImpossible(apple.x, apple.y)) do apple.x, apple.y = math.random(30), math.random(30) end
end

local function onKeyEvent(event)
    if (lock == false and event.phase == "down") then
        if (event.keyName == "up") then
            if (snake.dir == 3 or snake.dir == 1) then
                snake.dir = 0
                lock = true
            end
        elseif (event.keyName == "right") then
            if (snake.dir == 0 or snake.dir == 2) then
                snake.dir = 1
                lock = true
            end
        elseif (event.keyName == "down") then
            if (snake.dir == 1 or snake.dir == 3) then
                snake.dir = 2
                lock = true
            end
        elseif (event.keyName == "left") then
            if (snake.dir == 2 or snake.dir == 0) then
                snake.dir = 3
                lock = true
            end
        end
    end
end

local function onFrameEvent()

    if (interval > 0) then interval = interval - 1 end

    if (interval == 0) then
        if (over > 0) then
            for x = 1, 30 do paintGrid(x, over, true) end
            if white[over] then
                for i, x in ipairs(white[over]) do paintGrid(x, over, false) end
            end
            over = over + 1
            interval = over > 30 and -1 or 5
        else
            local x, y = X[head], Y[head]
            if (snake.dir == 0) then y = y - 1
            elseif (snake.dir == 1) then x = x + 1
            elseif (snake.dir == 2) then y = y + 1
            elseif (snake.dir == 3) then x = x - 1
            end

            if (x < 1 or x > 30 or y < 1 or y > 30 or isImpossible(x, y)) then
                drawApple(false)
                over = 1
            else
                moveHead(x, y)
                paintGrid(x, y, true)

                if (eat == true) then
                    eat = false
                else
                    paintGrid(X[tail], Y[tail], false)
                    moveTail()
                end

                if (apple.x == x and apple.y == y) then
                    eat = true
                    drawApple(false)
                    spawnApple()
                    drawApple(true)
                end
                lock = false

                interval = 5
            end
        end
    end
end

local function initGame()

    X, Y, tail, head = {}, {}, 1, 3
    for i = 1, 3 do X[i], Y[i] = 2 + i, 8 end

    snake = {len = 3, dir = 1}
    apple = {x = 11, y = 8}

    eat = false
    lock = false
    interval = 30
    over = 0

    for i = 1, 3 do paintGrid(X[i], Y[i], true) end
    drawApple(true)
end

-- action

initGame()
Runtime:addEventListener("key", onKeyEvent)
Runtime:addEventListener("enterFrame", onFrameEvent)