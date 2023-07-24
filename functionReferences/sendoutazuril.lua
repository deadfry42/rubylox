local folder = game.ReplicatedStorage.compileSettings
local maxX = folder.maxX.Value
local maxY = folder.maxY.Value
local twns = game:GetService("TweenService")
return function(loc)
	local rendering = require(loc.Parent.renderingEngine)
	local proftalk = require(loc.Parent.Parent.Scenes.PreGame.ProfTalk)
	local azur = proftalk.retrieveAssets()[6]
	local bir = proftalk.retrieveAssets()[5]
	local left = 108
	local top = 58
	local pokeball = rendering.renderImgInBounds("/assets/balls/poke.png", left,top, 16, 16, Vector2.new(0.5,0.5), Vector2.new(0,0), Vector2.new(16,16))
	wait(.5)
	pokeball:Destroy()
	local pokeballopen = rendering.renderImgInBounds("/assets/balls/poke.png", left,top, 16, 16, Vector2.new(0.5,0.5), Vector2.new(0,16), Vector2.new(16,16))
	rendering.playSFX("ballopen.wav")
	rendering.playCry("298.ogg")
	local flash = rendering.renderImg("/assets/titlescreen/brightwhitelight.png", 0, 0, maxX, maxY, Vector2.new(0,0), function(ni)
		ni.ImageTransparency = 1
	end)
	azur.ZIndex = 10
	local azurwhite = rendering.renderImg("/assets/creatures/frontwhite/298.png", 0, 0, 240, 160,Vector2.new(0,0), function(ni)
		ni.Parent = azur
		ni.ImageColor3 = Color3.new(1, 0.709804, 0.968627)
		ni.ZIndex = 20
	end)
	bir.ZIndex = 10
	--create 4 flakes before pokeball dies smh
	azur.Size = pokeballopen.Size
	azur.Position = pokeballopen.Position
	azur.AnchorPoint = pokeballopen.AnchorPoint
	azur.ImageTransparency = 0
	local twni = TweenInfo.new(1/4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local twni2 = TweenInfo.new(1/4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local g = {}
	g.Position = UDim2.new((84/maxX), 0, (40/maxY), 0)
	g.Size = UDim2.new((32/maxX), 0, (32/maxY), 0)
	local g2 = {}
	g2.Position = UDim2.new((100/maxX), 0, (73/maxY), 0)
	g.Size = UDim2.new((64/maxX), 0, (64/maxY), 0)
	coroutine.resume(coroutine.create(function()
		twns:Create(azur, twni, g):Play()
		wait(1/4)
		twns:Create(azur, twni2, g2):Play()
	end))
	local spriteTable = {
		[1] = {["left"] = 0, ["top"] = 0},
		[2] = {["left"] = 7, ["top"] = 0},
		[3] = {["left"] = 14, ["top"] = 0},
		[4] = {["left"] = 0, ["top"] = 7},
		[5] = {["left"] = 7, ["top"] = 7},
		[6] = {["left"] = 14, ["top"] = 7},
		[7] = {["left"] = 0, ["top"] = 14},
		[8] = {["left"] = 7, ["top"] = 14},
	}
	for i=1, 4 do
		local movementTable = {
			[1] = {["up"] = 0, ["left"] = 1},
			[2] = {["up"] = 1, ["left"] = 0},
			[3] = {["up"] = -1, ["left"] = 0},
			[4] = {["up"] = 0, ["left"] = -1},
		}
		local movement = movementTable[i]
		local count = i
		local particle = rendering.renderImgInBounds("/assets/vfx/sendoutstandardball.png", left, top, 7, 7, Vector2.new(0,0), Vector2.new(spriteTable[count].left, spriteTable[count].top), Vector2.new(7,7))
		particle.ZIndex = 100
		task.wait(1/60)
		coroutine.resume(coroutine.create(function()
			for ii=1, 20 do
				particle.ImageRectOffset = Vector2.new(spriteTable[count].left, spriteTable[count].top)
				particle.Position += UDim2.new((movementTable[i].left*2/maxX), 0, (movementTable[i].up*2/maxY), 0)
				task.wait(1/60)
				count+=1
				if count > 8 then count = 1 end
			end
			particle:Destroy()
		end))
	end
	pokeballopen:Destroy()
	for i=1, 4 do
		local movementTable = {
			[1] = {["up"] = 1, ["left"] = 1},
			[2] = {["up"] = 1, ["left"] = -1},
			[3] = {["up"] = -1, ["left"] = 1},
			[4] = {["up"] = -1, ["left"] = -1},
		}
		local movement = movementTable[i]
		local count = i+4
		local particle = rendering.renderImgInBounds("/assets/vfx/sendoutstandardball.png", left, top, 7, 7, Vector2.new(0,0), Vector2.new(spriteTable[count].left, spriteTable[count].top), Vector2.new(7,7))
		particle.ZIndex = 100
		task.wait(1/60)
		coroutine.resume(coroutine.create(function()
			for ii=1, 20 do
				particle.ImageRectOffset = Vector2.new(spriteTable[count].left, spriteTable[count].top)
				particle.Position += UDim2.new((movementTable[i].left*2/maxX), 0, (movementTable[i].up*2/maxY), 0)
				task.wait(1/60)
				count+=1
				if count > 8 then count = 1 end
			end
			particle:Destroy()
		end))
	end
	coroutine.resume(coroutine.create(function()
		rendering.genericOpacityTween(flash, 0, 10, function()
			coroutine.resume(coroutine.create(function()
				rendering.genericOpacityTween(azurwhite, 1, 10)
			end))
			rendering.genericOpacityTween(flash, 1, 10, function()
				flash:Destroy()
			end)
		end)
	end))
end
