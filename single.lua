
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local const = require("constants")

local board
local appleImg

local X
local Y
local tail
local head

local snake
local apple

local eat
local lock
local interval
local over

local screenX = {19, 13, 7}
local screen = {
    [2] = {3, 4, 5, 11, 12, 13, 18, 22, 26, 27, 28, 29, 30},
    [3] = {2, 6, 10, 14, 18, 22, 26},
    [4] = {2, 10, 14, 18, 19, 21, 22, 26},
    [5] = {2, 5, 6, 10, 11, 12, 13, 14, 18, 20, 22, 26, 27, 28, 29},
    [6] = {2, 6, 10, 14, 18, 22, 26},
    [7] = {2, 6, 10, 14, 18, 22, 26},
    [8] = {3, 4, 5, 10, 14, 18, 22, 26, 27, 28, 29, 30},
    [10] = {3, 4, 5, 10, 14, 18, 19, 20, 21, 22, 26, 27, 28, 29},
    [11] = {2, 6, 10, 14, 18, 26, 30},
    [12] = {2, 6, 10, 14, 18, 26, 30},
    [13] = {2, 6, 10, 14, 18, 19, 20, 21, 26, 27, 28, 29},
    [14] = {2, 6, 11, 13, 18, 26, 28},
    [15] = {2, 6, 11, 13, 18, 26, 29},
    [16] = {3, 4, 5, 12, 18, 19, 20, 21, 22, 26, 30},
}

local function paintGrid(x, y, flag)
    if (flag == true) then
        board[x][y]:setFillColor(1, 1, 1)
    else
        board[x][y]:setFillColor(0, 0, 0)
    end
end

local function paintApple(flag)
    if (flag == true) then
        appleImg.x = 15 + 15 * (2 * apple.x - 1)
        appleImg.y = 15 + 15 * (2 * apple.y - 1)
    end
    appleImg.isVisible = flag
end

local function moveHead(x, y)
    head = head + 1
    if (head > 961) then head = 1 end
    X[head], Y[head] = x, y
end

local function moveTail()
    tail = tail + 1
    if (tail > 961) then tail = 1 end
end

local function isImpossible(x, y)
    if (head > tail) then
        for i = tail, head do
            if (X[i] == x and Y[i] == y) then return true end
        end
    else
        for i = tail, 961 do
            if (X[i] == x and Y[i] == y) then return true end
        end
        for i = 1, head do
            if (X[i] == x and Y[i] == y) then return true end
        end
    end
    return false
end

local function spawnApple()
    while (isImpossible(apple.x, apple.y)) do apple.x, apple.y = math.random(31), math.random(31) end
end

local function clear()
    for x = 13, 19 do
        for y = 5, 26 do paintGrid(x, y, false) end
    end
end

local function initGame()

    X, Y, tail, head = {}, {}, 1, 3
    for i = 1, 3 do X[i], Y[i] = 5 + i, 24 end

    snake = {len = 3, dir = 1}
    apple = {x = 24, y = 24}

    eat = false
    lock = true
    interval = 1
    over = -4

    for x = 1, 31 do
        for y = 1, 31 do paintGrid(x, y, false) end
    end

    for i = 21, 27 do screen[i] = {} end
    for i = 1, 3 do paintGrid(X[i], Y[i], true) end

    spawnApple()
    paintApple(true)

    for x = 13, 19 do board[x][24]:setFillColor(0.5, 0.5, 0.5) end
    board[17][22]:setFillColor(0.5, 0.5, 0.5)
    board[17][26]:setFillColor(0.5, 0.5, 0.5)
    board[18][23]:setFillColor(0.5, 0.5, 0.5)
    board[18][25]:setFillColor(0.5, 0.5, 0.5)
end

local function onKeyEvent(event)
	if (event.phase == "down") then
		if (over > 31) then
			if (event.keyName == "space" or event.keyName == "enter") then
				initGame()
			elseif (event.keyName == "escape") then
				composer.gotoScene("intro")
			end
		elseif (over == 0 and lock == false) then
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

    if (interval > 0) then
		interval = interval - 1
	elseif (interval == 0) then
        if (over > 31) then
            interval = -1
        elseif (over > 0) then
            for x = 1, 31 do paintGrid(x, over, true) end
            if screen[over] then
                for i, x in ipairs(screen[over]) do paintGrid(x, over, false) end
            end
            over = over + 1
            interval = 3
        elseif (over == -1) then
            clear()
            over = 0
            interval = 5
            lock = false
        elseif (over < -1) then
            for x = 14, 18 do
                for y = 5, 11 do paintGrid(x, y, false) end
            end
            for y = 1, 7 do
                for _, x in ipairs(const.number[-over-1][y]) do paintGrid(13 + x, 5 + y, true) end
            end
            over = over + 1
            interval = 30
        else
            local x, y = X[head], Y[head]
            if (snake.dir == 0) then y = y - 1
            elseif (snake.dir == 1) then x = x + 1
            elseif (snake.dir == 2) then y = y + 1
            elseif (snake.dir == 3) then x = x - 1
            end

            if (x < 1 or x > 31 or y < 1 or y > 31 or isImpossible(x, y)) then
                paintApple(false)
                snake.len = snake.len - 3
                for i = 1, 3 do
                    for y = 1, 7 do
                        for _, x in ipairs(const.number[snake.len % 10][y]) do table.insert(screen[20 + y], screenX[i] + x) end
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
                    paintApple(false)
                    spawnApple()
                    paintApple(true)
                end
                lock = false

                interval = 5
            end
        end
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	local background1 = display.newRect(480, 480, 950, 950)
	background1:setFillColor(1, 1, 1)
	
	local background2 = display.newRect(480, 480, 940, 940)
	background2:setFillColor(0, 0, 0)

	board = display.newGroup()
	for x = 1, 31 do
    	local col = display.newGroup()
    	for y = 1, 31 do display.newRect(col, 15 + 15 * (2 * x - 1), 15 + 15 * (2 * y - 1), 30, 30) end
    	board:insert(col)
	end

	appleImg = display.newCircle(480, 480, 10)
	appleImg:setFillColor(1, 1, 1)
	appleImg.isVisible = false

	initGame()
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

		Runtime:addEventListener("key", onKeyEvent)
		Runtime:addEventListener("enterFrame", onFrameEvent)

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

		Runtime:removeEventListener("key", onKeyEvent)
		Runtime:removeEventListener("enterFrame", onFrameEvent)
		composer.removeScene("single")

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
