local options = {}
local twns = game:GetService("TweenService")
local pbu = require(game.ReplicatedStorage.patchbaseurl)
local inputs = require(script.Parent.Parent.Parent.Engines.inputEngine)
local scenes = require(script.Parent.Parent.Parent.Engines.sceneEngine)
local rendering = require(script.Parent.Parent.Parent.Engines.renderingEngine)
local engine = require(script.Parent.Parent.Parent.Engines.gameEngine)
local savefile = require(script.Parent.Parent.Parent.Engines.savingEngine)
local ctrls = require(game.ReplicatedStorage.inputs)
local folder = game.ReplicatedStorage.compileSettings
local maxX = folder.maxX.Value
local maxY = folder.maxY.Value
options.run = function()
	inputs.wipeAllFuncs()
	rendering.clearGraphics()
	local bg = rendering.renderImg(pbu.."/assets/titlescreen/brightwhitelight.png", 0 ,0, maxX, maxY, Vector2.new(0 ,0))
	bg.BackgroundColor3 = Color3.new(0.309804, 0.32549, 0.560784)
	bg.ImageTransparency = 1
	bg.BackgroundTransparency = 0
	engine.drawText("font3_dark", "W\nI\nP\n \ns\no\ns\n.", 10, 10, Color3.new(1,1,1))
	wait(0.25)
	rendering.genericOpacityTween(script.Parent.Parent.Parent.Parent.gry.overlay, 1, 10, function()
		inputs.assignKeyToFunc(ctrls.scheme1.cancel, "exitoptions", function()
			inputs.wipeAllFuncs()
			script.Parent.Parent.Parent.Parent.gry.overlay.BackgroundTransparency = 1
			script.Parent.Parent.Parent.Parent.gry.overlay.BackgroundColor3 = Color3.new(0, 0, 0)
			rendering.genericOpacityTween(script.Parent.Parent.Parent.Parent.gry.overlay, 0, 10, function()
				wait(0.2)
				rendering.clearGraphics()
				scenes.openscene("PreGame.Menuscreen")
			end)
		end, true)
	end)
end

return options
