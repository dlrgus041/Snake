-- front

local background1 = display.newRect(480, 480, 940, 940)
background1:setFillColor(1, 1, 1)

local background2 = display.newRect(480, 480, 910, 910)
background2:setFillColor(0, 0, 0)

local board = display.newGroup()
for x = 1, 30 do
    local col = display.newGroup()
    for y = 1, 30 do display.newRect(col, 30 + 15 * (2 * x - 1), 30 + 15 * (2 * y - 1), 30, 30) end
    board:insert(col)
end

local appleImg = display.newCircle(480, 480, 10)
appleImg:setFillColor(1, 1, 1)
appleImg.isVisible = false

-- screen

-- intro
local intro = {
    [11] = {4, 5, 6, 7, 9, 12, 15, 16, 19, 22, 24, 25, 26, 27},
    [12] = {4, 9, 12, 14, 17, 19, 21, 24},
    [13] = {4, 5, 6, 7, 9, 10, 12, 14, 15, 16, 17, 19, 20, 24, 25, 26},
    [14] = {7, 9, 11, 12, 14, 17, 19, 21, 24},
    [15] = {4, 5, 6, 7, 9, 12, 14, 17, 19, 22, 24, 25, 26, 27},
    [23] = {9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22},
    [24] = {9, 22},
    [25] = {9, 22},
    [26] = {9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22},
}

-- game over
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
    [22] = {}, --{5, 6, 7, 8, 11, 12, 13, 14, 17, 18, 19, 20, 23, 24, 25, 26},
    [23] = {}, --{5, 8, 11, 14, 17, 20, 23, 26},
    [24] = {}, --{5, 8, 11, 14, 17, 20, 23, 26},
    [25] = {}, --{5, 8, 11, 14, 17, 20, 23, 26},
    [26] = {}, --{5, 6, 7, 8, 11, 12, 13, 14, 17, 18, 19, 20, 23, 24, 25, 26},
}

local whiteX = {22, 16, 10, 4}

local number = {
    [0] = {
        {1, 2, 3, 4},
        {1, 4},
        {1, 4},
        {1, 4},
        {1, 2, 3, 4}
    },
    [1] = {
        {2, 3},
        {2, 3},
        {2, 3},
        {2, 3},
        {2, 3},
    },
    [2] = {
        {1, 2, 3, 4},
        {4},
        {1, 2, 3, 4},
        {1},
        {1, 2, 3, 4}
    },
    [3] = {
        {1, 2, 3, 4},
        {4},
        {1, 2, 3, 4},
        {4},
        {1, 2, 3, 4}
    },
    [4] = {
        {1, 4},
        {1, 4},
        {1, 2, 3, 4},
        {4},
        {4}
    },
    [5] = {
        {1, 2, 3, 4},
        {1},
        {1, 2, 3, 4},
        {4},
        {1, 2, 3, 4}
    },
    [6] = {
        {1, 2, 3, 4},
        {1},
        {1, 2, 3, 4},
        {1, 4},
        {1, 2, 3, 4}
    },
    [7] = {
        {1, 2, 3, 4},
        {1, 4},
        {1, 4},
        {4},
        {4}
    },
    [8] = {
        {1, 2, 3, 4},
        {1, 4},
        {1, 2, 3, 4},
        {1, 4},
        {1, 2, 3, 4}
    },
    [9] = {
        {1, 2, 3, 4},
        {1, 4},
        {1, 2, 3, 4},
        {4},
        {4}
    },
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

local function initGame()

    X, Y, tail, head = {}, {}, 1, 3
    for i = 1, 3 do X[i], Y[i] = 6 + i, 23 end

    snake = {len = 3, dir = 1}
    apple = {x = 23, y = 23}

    eat = false
    lock = false
    interval = 30
    over = -4

    for x = 1, 30 do
        for y = 1, 30 do paintGrid(x, y, false) end
    end

    for i = 22, 26 do white[i] = {} end
    for i = 1, 3 do paintGrid(X[i], Y[i], true) end

    spawnApple()
    drawApple(true)
end

local function onKeyEvent(event)
    if (event.phase == "down") then
        if (interval < 0) then
            if (event.keyName == "escape") then
                os.exit()
            elseif (event.keyName == "space" or event.keyName == "enter") then
                initGame()
            end
        elseif (lock == false) then
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
            interval = over > 30 and -1 or 3
        elseif (over < 0) then
            for x = 14, 17 do
                for y = 6, 10 do paintGrid(x, y, false) end
            end
            if (over < -1) then
                for y = 1, 5 do
                    for _, x in ipairs(number[-over-1][y]) do paintGrid(13 + x, 5 + y, true) end
                end
            end
            over = over + 1
            interval = over < -1 and 30 or 5
        else
            local x, y = X[head], Y[head]
            if (snake.dir == 0) then y = y - 1
            elseif (snake.dir == 1) then x = x + 1
            elseif (snake.dir == 2) then y = y + 1
            elseif (snake.dir == 3) then x = x - 1
            end

            if (x < 1 or x > 30 or y < 1 or y > 30 or isImpossible(x, y)) then
                drawApple(false)
                snake.len = snake.len - 3
                for i = 1, 4 do
                    for y = 1, 5 do
                        for _, x in ipairs(number[snake.len % 10][y]) do table.insert(white[21 + y], whiteX[i] + x) end
                    end
                    snake.len = math.floor(snake.len / 10)
                end
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
                    snake.len = snake.len + 1
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

-- action

for x = 1, 30 do
    for y = 1, 30 do paintGrid(x, y, true) end
end
for y, arrX in pairs(intro) do
    for _, x in ipairs(arrX) do paintGrid(x, y, false) end
end
Runtime:addEventListener("key", onKeyEvent)
Runtime:addEventListener("enterFrame", onFrameEvent)