local module = {}

-- includes --
local pbu = require(game.ReplicatedStorage.patchbaseurl)
local inputs = require(game.ReplicatedStorage.inputs)

-- compile vars --
local folder = game.ReplicatedStorage.compileSettings
---
local maxX = folder.maxX.Value
local maxY = folder.maxY.Value

-- services --
local twns = game:GetService("TweenService")
local uis = game:GetService("UserInputService")

module.clearGraphics = function()
	for i, v in ipairs(script.Parent.Parent.game.loadedassets:GetChildren()) do
		v:Destroy()
	end
end

module.genericColorTween = function(obj, newclr, clk, callback)
	local base = {} base.r = obj.BackgroundColor3.R
	base.g = obj.BackgroundColor3.G
	base.b = obj.BackgroundColor3.B
	for i=1, clk do
		wait()
		local cx = (newclr.R-base.r)/clk
		local cy = (newclr.G-base.g)/clk
		local cz = (newclr.B-base.b)/clk
		obj.BackgroundColor3 = Color3.new(base.r+(cx*i), base.g+(cy*i), base.b+(cz*i))
	end
	pcall(callback)
end

module.genericPosTween = function(obj, newx, newy, timeToSpend, callback)
	local a = coroutine.create(function()
		local new = UDim2.new(newx/maxX, 0, newy/maxY, 0)
		local tweeninfo = TweenInfo.new(timeToSpend, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
		local g = {}
		g.Position = new
		local tween = twns:Create(obj, tweeninfo, g)
		tween:Play()
		wait(timeToSpend)
		pcall(function() callback() end)
	end)
	coroutine.resume(a)
end

module.genericOpacityTween = function(obj, newopac, clk, callback)
	coroutine.resume(coroutine.create(function()
		if obj:IsA("Frame") then
			local base = {} base.opac = obj.BackgroundTransparency
			for i=1, clk do
				wait()
				local c = (newopac - base.opac)/clk
				obj.BackgroundTransparency += c
			end
		elseif obj:IsA("ImageLabel") then
			local base = {} base.opac = obj.ImageTransparency
			for i=1, clk do
				wait()
				local c = (newopac - base.opac)/clk
				obj.ImageTransparency += c
			end
		end
		pcall(callback)
	end))
end

module.batchGenericOpacityTween = function(objs, oldopac, newopac, clk, callback)
	for i=1, clk do
		for ii, obj in ipairs(objs) do
			if obj:IsA("Frame") then
				local c = (newopac - oldopac)/clk
				obj.BackgroundTransparency += c
			elseif obj:IsA("ImageLabel") then
				local c = (newopac - oldopac)/clk
				obj.ImageTransparency += c
			end
		end
		wait()
	end
	pcall(callback)
end

module.playSFX = function(sfxnameinfolder, vol)
	local newsfx = Instance.new("Sound")
	newsfx.SoundId = pbu.."/soundeffects/"..sfxnameinfolder
	newsfx.Parent = script.Parent
	newsfx.PlayOnRemove = true
	newsfx:Destroy()
end

module.renderImg = function(filepathinpatch, x, y, sizex, sizey, anchor, callback) --returns img, x in bounds of game and out of 240. y in bounds of game and out of 160, same for sizes
	local newimg = Instance.new("ImageLabel")
	newimg.Image = pbu..filepathinpatch
	newimg.Parent = script.Parent.Parent.game.loadedassets
	newimg.AnchorPoint = anchor
	newimg.BorderSizePixel = 0
	newimg.BackgroundTransparency = 1
	newimg.Position = UDim2.new((x/maxX), 0, (y/maxY), 0)
	newimg.Size = UDim2.new((sizex/maxX), 0, (sizey/maxY), 0)
	newimg.ResampleMode = Enum.ResamplerMode.Pixelated
	pcall(function()
		callback(newimg)
	end)
	return newimg
end

module.renderMaskImg = function(filepathinpatch, x, y, sizex, sizey, anchor, callback) --returns img, x in bounds of game and out of 240. y in bounds of game and out of 160, same for sizes
	local newf = Instance.new("Frame")
	newf.Name = filepathinpatch
	newf.BackgroundTransparency = 1
	newf.Position = UDim2.new((x/maxX), 0, (y/maxY), 0)
	newf.Size = UDim2.new((sizex/maxX), 0, (sizey/maxY), 0)
	newf.AnchorPoint = anchor
	newf.ClipsDescendants = true
	newf.Parent = script.Parent.Parent.game.loadedassets
	local newimg = Instance.new("ImageLabel")
	newimg.Name = "maskedwithinframe"
	newimg.Image = pbu..filepathinpatch
	newimg.Parent = newf
	newimg.AnchorPoint = Vector2.new(0.5, 0.5)
	newimg.BorderSizePixel = 0
	newimg.BackgroundTransparency = 1
	newimg.Position = UDim2.new(0.5, 0, 0.5, 0)
	newimg.Size = UDim2.new(1, 0, 1, 0)
	newimg.ResampleMode = Enum.ResamplerMode.Pixelated
	pcall(function()
		callback(newf)
	end)
	return newf
end

module.renderImgInBounds = function(filepathinpatch, x, y, sizex, sizey, anchor, frameRectOffset, frameRectSize, callback) --returns img, x in bounds of game and out of 240. y in bounds of game and out of 160, same for sizes
	local newimg = Instance.new("ImageLabel")
	newimg.Image = pbu..filepathinpatch
	newimg.Parent = script.Parent.Parent.game.loadedassets
	newimg.AnchorPoint = anchor
	newimg.BorderSizePixel = 0
	newimg.BackgroundTransparency = 1
	newimg.ImageRectOffset = frameRectOffset
	newimg.ImageRectSize = frameRectSize
	newimg.Position = UDim2.new((x/maxX), 0, (y/maxY), 0)
	newimg.Size = UDim2.new((sizex/maxX), 0, (sizey/maxY), 0)
	newimg.ResampleMode = Enum.ResamplerMode.Pixelated
	pcall(function()
		callback(newimg)
	end)
	return newimg
end

module.batchRenderFromSameLinkInBounds = function(list, link) --each entry follows the same as renderImgInBounds
	local allReturned = {}
	for i, v in ipairs(list) do 
		table.insert(allReturned, module.renderImgInBounds(link, v.x, v.y, v.sizex, v.sizey, v.anchor, v.frameRectOffset, v.frameRectSize, v.callback))
	end
	return allReturned
end

module.createElemFromBatchImgs = function(list, link)
	local frame = Instance.new("Frame")
	frame.BackgroundTransparency = 1
	frame.Position = UDim2.new(0,0,0,0)
	frame.AnchorPoint = Vector2.new(0,0)
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.Parent = script.Parent.Parent.game.loadedassets
	local elems = module.batchRenderFromSameLinkInBounds(list, link)
	for i, v in ipairs(elems) do
		v.Parent = frame
	end
	return frame
end

module.drawHighlightBox = function(x, y, lengthofmiddlex, lengthofmiddley) --text boxes
	local sizex = (2+lengthofmiddlex)*8
	local sizey = (2+lengthofmiddley)*8
	x += 1
	y += 1
	sizex -= 2
	sizey -= 2

	print(sizex)

	return module.renderImg("/assets/titlescreen/brightwhitelight.png", x, y, sizex, sizey, Vector2.new(0, 0), function(ni)
		ni.ImageTransparency = 0.5
	end)
end

return module
