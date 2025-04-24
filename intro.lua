
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function onKeyEvent(event)
	if (event.phase == "down") then
		if (event.keyName == "escape") then
			os.exit()
		elseif (event.keyName == "space" or event.keyName == "enter") then
			composer.gotoScene("cpu")
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

	local board = display.newGroup()
	for x = 1, 31 do
		local col = display.newGroup()
		for y = 1, 31 do display.newRect(col, 15 + 15 * (2 * x - 1), 15 + 15 * (2 * y - 1), 30, 30) end
		board:insert(col)
	end

	local intro = {
		[5] = {3, 4, 5, 8, 12, 15, 16, 17, 20, 24, 26, 27, 28, 29, 30},
		[6] = {2, 6, 8, 12, 14, 18, 20, 23, 26},
		[7] = {2, 8, 9, 12, 14, 18, 20, 22, 26},
		[8] = {3, 4, 5, 8, 10, 12, 14, 15, 16, 17, 18, 20, 21, 26, 27, 28, 29},
		[9] = {6, 8, 11, 12, 14, 18, 20, 22, 26},
		[10] = {2, 6, 8, 12, 14, 18, 20, 23, 26},
		[11] = {3, 4, 5, 8, 12, 14, 18, 20, 24, 26, 27, 28, 29, 30},
	}

	for x = 1, 31 do
		for y = 1, 31 do board[x][y]:setFillColor(0, 0, 0) end
	end
	for y, arrX in pairs(intro) do
		for _, x in ipairs(arrX) do board[x][y]:setFillColor(1, 1, 1) end
	end

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
		composer.removeScene("intro")
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
