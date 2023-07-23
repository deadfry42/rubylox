local creditsboot = {}
local rendering = require(script.Parent.Parent.Parent.Engines.renderingEngine)
local scenes = require(script.Parent.Parent.Parent.Engines.sceneEngine)
local folder = game.ReplicatedStorage.compileSettings
local maxX = folder.maxX.Value
local maxY = folder.maxY.Value
creditsboot.run = function()
	script.Parent.Parent.Parent.Parent.gry.overlay.BackgroundColor3 = Color3.new(1,1,1)
	script.Parent.Parent.Parent.Parent.gry.overlay.BackgroundTransparency = 0
	--offset 15. get to 28px. lineheight 4

	local test = 3
	local base = 40
	local space = 15

	local lines = rendering.batchRenderFromSameLinkInBounds({
		--[[ 2003 txt ]]{["x"] = 80-test, ["y"] = base+(space), ["sizex"] = 28, ["sizey"] = 8, ["anchor"] = Vector2.new(0.5,0.5), ["frameRectOffset"] = Vector2.new(15, 0), ["frameRectSize"] = Vector2.new(30,8), ["callback"] = "",},
		--[[ cpr symbol 1 ]]{["x"] = 70-test, ["y"] = base+(space*2), ["sizex"] = 8, ["sizey"] = 8, ["anchor"] = Vector2.new(0.5,0.5), ["frameRectOffset"] = Vector2.new(15, 0), ["frameRectSize"] = Vector2.new(9,8), ["callback"] = "",},
		--[[ cpr symbol 2 ]]{["x"] = 70-test, ["y"] = base+(space*3), ["sizex"] = 8, ["sizey"] = 8, ["anchor"] = Vector2.new(0.5,0.5), ["frameRectOffset"] = Vector2.new(15, 0), ["frameRectSize"] = Vector2.new(9,8), ["callback"] = "",},
		--[[ cpr symbol 3 ]]{["x"] = 70-test, ["y"] = base+(space*4), ["sizex"] = 8, ["sizey"] = 8, ["anchor"] = Vector2.new(0.5,0.5), ["frameRectOffset"] = Vector2.new(15, 0), ["frameRectSize"] = Vector2.new(9,8), ["callback"] = "",},
		--[[ pokemon txt ]]{["x"] = maxX/2, ["y"] = base+(space), ["sizex"] = 52, ["sizey"] = 8, ["anchor"] = Vector2.new(0,0.5), ["frameRectOffset"] = Vector2.new(49, 0), ["frameRectSize"] = Vector2.new(52,8), ["callback"] = "",},
		--[[ date txt 1 ]]{["x"] = 75-test, ["y"] = base+(space*2), ["sizex"] = 41, ["sizey"] = 8, ["anchor"] = Vector2.new(0,0.5), ["frameRectOffset"] = Vector2.new(105, 0), ["frameRectSize"] = Vector2.new(41,8), ["callback"] = "",},
		--[[ date txt 2 ]]{["x"] = 75-test, ["y"] = base+(space*3), ["sizex"] = 41, ["sizey"] = 8, ["anchor"] = Vector2.new(0,0.5), ["frameRectOffset"] = Vector2.new(105, 0), ["frameRectSize"] = Vector2.new(41,8), ["callback"] = "",},
		--[[ date txt 3 ]]{["x"] = 75-test, ["y"] = base+(space*4), ["sizex"] = 41, ["sizey"] = 8, ["anchor"] = Vector2.new(0,0.5), ["frameRectOffset"] = Vector2.new(105, 0), ["frameRectSize"] = Vector2.new(41,8), ["callback"] = "",},
		--[[ nintendo txt ]]{["x"] = 120, ["y"] = base+(space*2), ["sizex"] = 50, ["sizey"] = 8, ["anchor"] = Vector2.new(0,0.5), ["frameRectOffset"] = Vector2.new(153, 0), ["frameRectSize"] = Vector2.new(50,8), ["callback"] = "",},
		--[[ creatures txt ]]{["x"] = 120, ["y"] = base+(space*3), ["sizex"] = 61, ["sizey"] = 8, ["anchor"] = Vector2.new(0,0.5), ["frameRectOffset"] = Vector2.new(1, 9), ["frameRectSize"] = Vector2.new(61,7), ["callback"] = "",},
		--[[ gamefreak txt ]]{["x"] = 120, ["y"] = base+(space*4), ["sizex"] = 71, ["sizey"] = 8, ["anchor"] = Vector2.new(0,0.5), ["frameRectOffset"] = Vector2.new(65, 9), ["frameRectSize"] = Vector2.new(71,7), ["callback"] = "",},
	}, "/assets/titlescreen/copyright.png")
	
	rendering.genericOpacityTween(script.Parent.Parent.Parent.Parent.gry.overlay, 1, 10)
	
	wait(2.5)
	rendering.batchGenericOpacityTween(lines, 0, 1, 10)
	wait(.5)
	rendering.clearGraphics()
	scenes.openscene("PreGame.Movie1")
end

return creditsboot
