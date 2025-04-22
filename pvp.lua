
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local board
local appleImg
local applePos

local interval
local over

local p

local function paintGrid(x, y, flag)
	if (flag == 0) then
		board[x][y]:setFillColor(0, 0, 0)
	elseif (flag == 1) then
		board[x][y]:setFillColor(1, 0, 0)
	elseif (flag == 2) then
		board[x][y]:setFillColor(0, 0, 1)
	elseif (flag == 3) then
		board[x][y]:setFillColor(1, 1, 1)
	end
end

local function paintApple(flag, bool)
	if (bool == true) then
		appleImg[flag].x = 15 + 15 * (2 * applePos[flag].x - 1)
		appleImg[flag].y = 15 + 15 * (2 * applePos[flag].y - 1)
	end
	appleImg[flag].isVisible = bool
end

local function moveHead(x, y, player)
	p[player].head = p[player].head + 1
	if (p[player].head > 961) then p[player].head = 1 end
	p[player][p[player].head].x = x
	p[player][p[player].head].y = y
end

local function moveTail(x, y, player)
	p[player].tail = p[player].tail + 1
	if (p[player].tail > 961) then p[player].tail = 1 end
end

local function collideSnake(x, y)
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

local function collideApple(flag)
	for i = 1, 3 do
		if (i ~= flag and applePos[i].x == applePos[flag].x and applePos[i].y == applePos[flag].y) then return true end
	end
	return false
end

local function spawnApple(flag)
	while (collideSnake(applePos[flag].x, applePos[flag].y) and collideApple(flag)) do
		applePos[flag].x = math.random(31)
		applePos[flag].y = math.random(31)
	end
end

local function clear()
	for x = 14, 18 do
		for y = 5, 11 do paintGrid(x, y, 0) end
	end
	for x = 6, 10 do
		for y = 13, 19 do paintGrid(x, y, 0) end
	end
	for x = 22, 26 do
		for y = 13, 19 do paintGrid(x, y, 0) end
	end
end

local function initGame()
	applePos = {{x = 8, y = 24}, {x = 24, y = 24}, {x = 16, y = 28}}
	p = {
		{{x = 8, y = 6}, {x = 8, y = 7}, {x = 8, y = 8},},
		{{x = 24, y = 6}, {x = 24, y = 7}, {x = 24, y = 8},}
	}
	interval = 1
	over = -4

	for player = 1, 2 do
		p[player].tail = 1
		p[player].head = 3
		p[player].len = 3
		p[player].dir = 2
		p[player].eat = false
		p[player].lock = true
		p[player].interval = -1
	end

	for x = 1, 31 do
		for y = 1, 31 do paintGrid(x, y, 0) end
	end

	for i = 1, 3 do
		paintGrid(p[1][i].x, p[1][i].y, 1)
		paintGrid(p[2][i].x, p[2][i].y, 2)
		-- spawnApple(i)
		paintApple(i, true)
	end

	for y = 13, 19 do
		board[8][y]:setFillColor(1, 0, 0, 0.5)
		board[24][y]:setFillColor(0, 0, 1, 0.5)
	end
	board[6][17]:setFillColor(1, 0, 0, 0.5)
	board[7][18]:setFillColor(1, 0, 0, 0.5)
	board[9][18]:setFillColor(1, 0, 0, 0.5)
	board[10][17]:setFillColor(1, 0, 0, 0.5)
	board[22][17]:setFillColor(0, 0, 1, 0.5)
	board[23][18]:setFillColor(0, 0, 1, 0.5)
	board[25][18]:setFillColor(0, 0, 1, 0.5)
	board[26][17]:setFillColor(0, 0, 1, 0.5)
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

	appleImg = {}

	appleImg[1] = display.newCircle(480, 480, 10)
	appleImg[1]:setFillColor(1, 0, 0)
	appleImg[1].isVisible = false

	appleImg[2] = display.newCircle(480, 480, 10)
	appleImg[2]:setFillColor(0, 0, 1)
	appleImg[2].isVisible = false

	appleImg[3] = display.newCircle(480, 480, 10)
	appleImg[3]:setFillColor(1, 1, 1)
	appleImg[3].isVisible = false

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
