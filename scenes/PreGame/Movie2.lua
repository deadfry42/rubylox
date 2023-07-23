local movie2 = {}
local pbu = require(game.ReplicatedStorage.patchbaseurl)
local inputs = require(script.Parent.Parent.Parent.Engines.inputEngine)
local scenes = require(script.Parent.Parent.Parent.Engines.sceneEngine)
local rendering = require(script.Parent.Parent.Parent.Engines.renderingEngine)
local ctrls = require(game.ReplicatedStorage.inputs)
movie2.run = function()
	local newsound = Instance.new("Sound")
	newsound.Volume = 1

	newsound.SoundId = pbu.."/music/2.mp3"
	newsound.Parent = game.Players.LocalPlayer.PlayerGui
	newsound:Play()
	local movie = coroutine.create(function()
		newsound.Ended:Wait()
		newsound:Destroy()
		scenes.openscene("PreGame.Titlescreen")
	end)
	coroutine.resume(movie)
	local function skip()
		newsound:Destroy()
		coroutine.close(movie)
		inputs.wipeAllFuncs()
		rendering.clearGraphics()
		scenes.openscene("PreGame.Titlescreen")
	end
	inputs.assignKeyToFunc(ctrls.scheme1.interact, "skipmovie", skip, true)
	inputs.assignKeyToFunc(ctrls.scheme1.cancel, "skipmovie", skip, true)
	inputs.assignKeyToFunc(ctrls.scheme1.menu, "skipmovie", skip, true)
	inputs.assignKeyToFunc(ctrls.scheme1.extra, "skipmovie", skip, true)
	inputs.assignKeyToFunc(ctrls.scheme1.up, "skipmovie", skip, true)
	inputs.assignKeyToFunc(ctrls.scheme1.left, "skipmovie", skip, true)
	inputs.assignKeyToFunc(ctrls.scheme1.down, "skipmovie", skip, true)
	inputs.assignKeyToFunc(ctrls.scheme1.right, "skipmovie", skip, true)
end

return movie2
