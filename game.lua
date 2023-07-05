local pbu = require(game.ReplicatedStorage.patchbaseurl)
local inputs = require(game.ReplicatedStorage.inputs)

local twns = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local cntp = game:GetService("ContentProvider")

local triggers = script.Triggers

--[[
things to fix (at a later date):
 - logo_shine not properly masking onto pokemon_ruby.png
 - fix how goofy the title screen looks
]]

local start = false
local began = false
local skip = false

local maxX = 240
local maxY = 144

local function clearGraphics()
	for i, v in ipairs(script.Parent.game.loadedassets:GetChildren()) do
		v:Destroy()
	end
end

local function genericColorTween(obj, newclr, clk, callback)
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

local function genericPosXTween(obj, newx, clk, callback)
	local base = {} base.x = (obj.Position.X.Scale)
	for i=1, clk do
		wait()
		print((newx/maxX))
		local cx = ((newx/maxX)-base.x)/clk
		print(cx)
		obj.Position = obj.Position + UDim2.new(cx, 0, 0, 0)
	end
	pcall(callback)
end

local function genericOpacityTween(obj, newopac, clk, callback)
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
end

local function batchGenericOpacityTween(objs, oldopac, newopac, clk, callback)
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

local function playSFX(sfxnameinfolder, vol)
	local newsfx = Instance.new("Sound")
	newsfx.SoundId = pbu.."/soundeffects/"..sfxnameinfolder
	newsfx.Parent = script.Parent
	newsfx.PlayOnRemove = true
	newsfx:Destroy()
end

local function renderImg(filepathinpatch, x, y, sizex, sizey, anchor) --returns img, x in bounds of game and out of 240. y in bounds of game and out of 144, same for sizes
	local newimg = Instance.new("ImageLabel")
	newimg.Image = pbu..filepathinpatch
	newimg.Parent = script.Parent.game.loadedassets
	newimg.AnchorPoint = anchor
	newimg.BorderSizePixel = 0
	newimg.BackgroundTransparency = 1
	newimg.Position = UDim2.new((x/maxX), 0, (y/maxY), 0)
	newimg.Size = UDim2.new((sizex/maxX), 0, (sizey/maxY), 0)
	return newimg
end

local function renderMaskImg(filepathinpatch, x, y, sizex, sizey, anchor) --returns img, x in bounds of game and out of 240. y in bounds of game and out of 144, same for sizes
	local newf = Instance.new("Frame")
	newf.Name = filepathinpatch
	newf.BackgroundTransparency = 1
	newf.Position = UDim2.new((x/maxX), 0, (y/maxY), 0)
	newf.Size = UDim2.new((sizex/maxX), 0, (sizey/maxY), 0)
	newf.AnchorPoint = anchor
	newf.ClipsDescendants = true
	newf.Parent = script.Parent.game.loadedassets
	local newimg = Instance.new("ImageLabel")
	newimg.Name = "maskedwithinframe"
	newimg.Image = pbu..filepathinpatch
	newimg.Parent = newf
	newimg.AnchorPoint = Vector2.new(0.5, 0.5)
	newimg.BorderSizePixel = 0
	newimg.BackgroundTransparency = 1
	newimg.Position = UDim2.new(0.5, 0, 0.5, 0)
	newimg.Size = UDim2.new(1, 0, 1, 0)
	return newf
end

local function renderImgInBounds(filepathinpatch, x, y, sizex, sizey, anchor, frameRectOffset, frameRectSize) --returns img, x in bounds of game and out of 240. y in bounds of game and out of 144, same for sizes
	local newimg = Instance.new("ImageLabel")
	newimg.Image = pbu..filepathinpatch
	newimg.Parent = script.Parent.game.loadedassets
	newimg.AnchorPoint = anchor
	newimg.BorderSizePixel = 0
	newimg.BackgroundTransparency = 1
	newimg.ImageRectOffset = frameRectOffset
	newimg.ImageRectSize = frameRectSize
	newimg.Position = UDim2.new((x/maxX), 0, (y/maxY), 0)
	newimg.Size = UDim2.new((sizex/maxX), 0, (sizey/maxY), 0)
	return newimg
end

local function batchRenderFromSameLinkInBounds(list, link) --each entry follows the same as renderImgInBounds
	local allReturned = {}
	for i, v in ipairs(list) do 
		table.insert(allReturned, renderImgInBounds(link, v.x, v.y, v.sizex, v.sizey, v.anchor, v.frameRectOffset, v.frameRectSize))
	end
	return allReturned
end

local function playTheGame()
	while began == false do
		clearGraphics()
		start = false
		skip = false
		print("cycle")
		local function boot()
			local newsound = Instance.new("Sound")
			newsound.SoundId = pbu.."/music/1.mp3"
			newsound.Volume = 1

			newsound.Parent = script.Parent
			newsound:Play()
			return newsound
		end

		local function boot2(newsound)
			newsound.SoundId = pbu.."/music/2.mp3"
			newsound:Play()
		end

		local function titleScreen(newsound)
			if start == false and skip == false then
				start = true
				newsound.SoundId = pbu.."/music/3.mp3"
				newsound:Play()
				
				script.Parent.game.overlay.BackgroundColor3 = Color3.new(1, 1, 1)
				script.Parent.game.overlay.BackgroundTransparency = 0
				
				--finaly should be ~35?
				local flash = renderImg("/assets/titlescreen/brightwhitelight.png", 0, 0, maxX, maxY, Vector2.new(0, 0))
				local title = renderMaskImg("/assets/titlescreen/title.png", maxX/2, 45, 175, 64, Vector2.new(0.5, 0.5))
				local shine = renderMaskImg("/assets/titlescreen/logo_shine.png", -85, 0, 85, 144, Vector2.new(0, 0))
				shine.Parent = title
				
				flash.ImageTransparency = 1
				
				shine.maskedwithinframe.ImageTransparency = 0.5
				
				genericOpacityTween(script.Parent.game.overlay, 1, 10, function()
					shine.Position = UDim2.new(0-shine.Size.X.Scale,0,0,0)
					shine:TweenPosition(UDim2.new(1, 0, 0, 0))
					wait(1.4)
					flash.ImageTransparency = 1
					genericOpacityTween(flash, 0.2, 10)
					wait(.05)
					shine.Position = UDim2.new(0-shine.Size.X.Scale,0,0,0)
					shine:TweenPosition(UDim2.new(1, 0, 0, 0))
					wait(0.05)
					genericOpacityTween(flash, 1, 20)
					wait(0.6)
					genericOpacityTween(flash, 0, 10)
					shine.Position = UDim2.new(0-shine.Size.X.Scale,0,0,0)
					wait(0.05)
					shine:TweenPosition(UDim2.new(1, 0, 0, 0))
					genericOpacityTween(flash, 1, 20)
				end)
				
				newsound.Ended:Wait()
			end
		end
		
		script.Parent.game.overlay.BackgroundColor3 = Color3.new(1,1,1)
		script.Parent.game.overlay.BackgroundTransparency = 0
		--offset 15. get to 28px. lineheight 4
		
		local test = 3
		local base = 30
		local space = 15
		
		local lines = batchRenderFromSameLinkInBounds({
			--[[ 2003 txt ]]{["x"] = 80-test, ["y"] = base+(space), ["sizex"] = 28, ["sizey"] = 8, ["anchor"] = Vector2.new(0.5,0.5), ["frameRectOffset"] = Vector2.new(15, 0), ["frameRectSize"] = Vector2.new(30,8)},
			--[[ cpr symbol 1 ]]{["x"] = 70-test, ["y"] = base+(space*2), ["sizex"] = 9, ["sizey"] = 8, ["anchor"] = Vector2.new(0.5,0.5), ["frameRectOffset"] = Vector2.new(15, 0), ["frameRectSize"] = Vector2.new(9,8)},
			--[[ cpr symbol 2 ]]{["x"] = 70-test, ["y"] = base+(space*3), ["sizex"] = 9, ["sizey"] = 8, ["anchor"] = Vector2.new(0.5,0.5), ["frameRectOffset"] = Vector2.new(15, 0), ["frameRectSize"] = Vector2.new(9,8)},
			--[[ cpr symbol 3 ]]{["x"] = 70-test, ["y"] = base+(space*4), ["sizex"] = 9, ["sizey"] = 8, ["anchor"] = Vector2.new(0.5,0.5), ["frameRectOffset"] = Vector2.new(15, 0), ["frameRectSize"] = Vector2.new(9,8)},
			--[[ pokemon txt ]]{["x"] = maxX/2, ["y"] = base+(space), ["sizex"] = 52, ["sizey"] = 8, ["anchor"] = Vector2.new(0,0.5), ["frameRectOffset"] = Vector2.new(49, 0), ["frameRectSize"] = Vector2.new(52,8)},
			--[[ date txt 1 ]]{["x"] = 75-test, ["y"] = base+(space*2), ["sizex"] = 41, ["sizey"] = 8, ["anchor"] = Vector2.new(0,0.5), ["frameRectOffset"] = Vector2.new(105, 0), ["frameRectSize"] = Vector2.new(41,8)},
			--[[ date txt 2 ]]{["x"] = 75-test, ["y"] = base+(space*3), ["sizex"] = 41, ["sizey"] = 8, ["anchor"] = Vector2.new(0,0.5), ["frameRectOffset"] = Vector2.new(105, 0), ["frameRectSize"] = Vector2.new(41,8)},
			--[[ date txt 3 ]]{["x"] = 75-test, ["y"] = base+(space*4), ["sizex"] = 41, ["sizey"] = 8, ["anchor"] = Vector2.new(0,0.5), ["frameRectOffset"] = Vector2.new(105, 0), ["frameRectSize"] = Vector2.new(41,8)},
			--[[ nintendo txt ]]{["x"] = 120, ["y"] = base+(space*2), ["sizex"] = 50, ["sizey"] = 8, ["anchor"] = Vector2.new(0,0.5), ["frameRectOffset"] = Vector2.new(153, 0), ["frameRectSize"] = Vector2.new(50,8)},
			--[[ creatures txt ]]{["x"] = 120, ["y"] = base+(space*3), ["sizex"] = 61, ["sizey"] = 8, ["anchor"] = Vector2.new(0,0.5), ["frameRectOffset"] = Vector2.new(1, 9), ["frameRectSize"] = Vector2.new(61,7)},
			--[[ gamefreak txt ]]{["x"] = 120, ["y"] = base+(space*4), ["sizex"] = 71, ["sizey"] = 8, ["anchor"] = Vector2.new(0,0.5), ["frameRectOffset"] = Vector2.new(65, 9), ["frameRectSize"] = Vector2.new(71,7)},
		}, "/assets/titlescreen/copyright.png")
		genericOpacityTween(script.Parent.game.overlay, 1, 10)
		
		wait(2.5)
		batchGenericOpacityTween(lines, 0, 1, 10)
		wait(.5)
		clearGraphics()
		
		local newsound = boot()

		uis.InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.Keyboard then
				if start == true and began == false then
					if inp.KeyCode == inputs.scheme1.advance then
						began = true
						local twni = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
						local gA = {} gA.Volume = 0
						
						twns:Create(newsound, twni, gA):Play()
						script.Parent.game.overlay.BackgroundTransparency = 1
						script.Parent.game.overlay.BackgroundColor3 = Color3.new(1,1,1)
						genericOpacityTween(script.Parent.game.overlay, 0, 10, function()
							clearGraphics()
							genericColorTween(script.Parent.game.overlay, Color3.new(0.501961, 0.596078, 0.784314), 10, function()
								wait(.1)
								genericColorTween(script.Parent.game.overlay, Color3.new(0.309804, 0.32549, 0.560784), 2)
							end)
						end)
					end
				else
					if began == true and start == true and inp.KeyCode == inputs.scheme1.cancel then
						playSFX("sel.wav")
						newsound:Stop()
						newsound.Volume = 1
						script.Parent.game.overlay.BackgroundTransparency = 0
						script.Parent.game.overlay.BackgroundColor3 = Color3.new(0.309804, 0.32549, 0.560784)
						genericColorTween(script.Parent.game.overlay, Color3.new(1, 1, 1), 5)
						start = false
						skip = false
						began = false
						wait(0.2)
						titleScreen(newsound)
					elseif start == false and began == false then
						titleScreen(newsound)
					end
					
				end
				
			end
		end)
		
		triggers.RestartMainTitleLoop.Changed:Connect(function(newval)
			skip = true
			newsound.TimePosition = 100000
			clearGraphics()
		end)
		
		newsound.Ended:Wait()
		print("sssdasfd")
		if start == true then triggers.RestartMainTitleLoop.Value = not triggers.RestartMainTitleLoop.Value end
		boot2(newsound)
		newsound.Ended:Wait()
		print("wefwrgger")
		titleScreen(newsound)
	end
end

cntp:PreloadAsync({pbu.."/confirmation/has_patch.png"}, function(assetID, assetwhatevermajiggy) 
	if assetwhatevermajiggy == Enum.AssetFetchStatus.Success then
		script.Parent.game.Error.Visible = false
		local success, errmsg = pcall(function()
			playTheGame()
		end)
		if errmsg then
			print(errmsg)
			while wait(math.random(.8, 1.3)) do
				local newerrorimg = Instance.new("ImageLabel")
				newerrorimg.Image = "rbxassetid://1847653031"
				newerrorimg.BackgroundTransparency = 1
				newerrorimg.Size = UDim2.new(0.05, 0, 0.05, 0)
				newerrorimg.Position = UDim2.new(math.random(1,1000)/1000, 0, math.random(1,1000)/1000, 0)
				local uiconstraint = Instance.new("UIAspectRatioConstraint")
				uiconstraint.Parent = newerrorimg
				newerrorimg.Parent = script.Parent
				local sfx = Instance.new("Sound")
				sfx.SoundId = "rbxassetid://9066167010"
				sfx.PlayOnRemove = true
				sfx.Parent = script.Parent
				sfx:Destroy()
			end
		end
	else
		script.Parent.game.Error.Visible = true
		print("Please join the discord.")
	end
end)