local folder = game.ReplicatedStorage.compileSettings
local maxX = folder.maxX.Value
local maxY = folder.maxY.Value
return function(loc)
	local rendering = require(loc.Parent.renderingEngine)
	local proftalk = require(loc.Parent.Parent.Scenes.PreGame.ProfTalk)
	local assets = proftalk.retrieveAssets()
	local tlp = assets[1]
	local blp = assets[2]
	local trp = assets[3]
	local brp = assets[4]
	local bir = assets[5]
	local azur = assets[6]
	coroutine.resume(coroutine.create(function()
		for i=1, 10 do
			tlp.ImageTransparency += .2
			blp.ImageTransparency += .2
			trp.ImageTransparency += .2
			brp.ImageTransparency += .2
			bir.ImageTransparency += .1
			azur.ImageTransparency += .1
			wait(.1)
		end
	end))
	for i=1, 50 do
		local movement = UDim2.new((5/maxX), 0, 0, 0)
		tlp.Position += movement
		blp.Position += movement
		trp.Position += movement
		brp.Position += movement
		wait(.02)
	end
	wait(.5)
	local loc = UDim2.new(1-tlp.Size.X.Scale, 0, tlp.Position.Y.Scale, 0)
	tlp.Position = loc
	trp.Position = loc
	blp.Position = loc
	brp.Position = loc
	local brendan = rendering.renderImg("/assets/trainers/portraits/brendan.png", maxX-(tlp.Size.X.Scale*maxX),93,64,64,Vector2.new(0.5,1), function(ni)
		ni.ImageTransparency = 1
	end)
	for i=1, 10 do
		tlp.ImageTransparency -= .1
		blp.ImageTransparency -= .1
		trp.ImageTransparency -= .1
		brp.ImageTransparency -= .1
		brendan.ImageTransparency -= .1
		wait(.1)
	end
	coroutine.resume(coroutine.create(function()
		wait(.1)
		brendan:Destroy()
	end))
end
