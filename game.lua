local pbu = require(game.ReplicatedStorage.patchbaseurl)
local inputs = require(game.ReplicatedStorage.inputs)
local fontrom = require(game.ReplicatedStorage.fontrom)

local twns = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local cntp = game:GetService("ContentProvider")
local bs = game:GetService("BadgeService")

local triggers = script.Triggers

local font3Width = fontrom.font3.width
local font3Height = fontrom.font3.height
local font3 = fontrom.font3.offsets

--[[
things to fix (at a later date):
 - logo_shine not properly masking onto pokemon_ruby.png
 - fix how goofy the title screen looks
]]

local start = false
local began = false
local skip = false

local inDialogue = false

local maxX = 240
local maxY = 160

local txtbox = 1

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

local function renderImg(filepathinpatch, x, y, sizex, sizey, anchor, callback) --returns img, x in bounds of game and out of 240. y in bounds of game and out of 160, same for sizes
	local newimg = Instance.new("ImageLabel")
	newimg.Image = pbu..filepathinpatch
	newimg.Parent = script.Parent.game.loadedassets
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

local function renderMaskImg(filepathinpatch, x, y, sizex, sizey, anchor, callback) --returns img, x in bounds of game and out of 240. y in bounds of game and out of 160, same for sizes
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
	newimg.ResampleMode = Enum.ResamplerMode.Pixelated
	pcall(function()
		callback(newf)
	end)
	return newf
end

local function renderImgInBounds(filepathinpatch, x, y, sizex, sizey, anchor, frameRectOffset, frameRectSize, callback) --returns img, x in bounds of game and out of 240. y in bounds of game and out of 160, same for sizes
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
	newimg.ResampleMode = Enum.ResamplerMode.Pixelated
	pcall(function()
		callback(newimg)
	end)
	return newimg
end

local function batchRenderFromSameLinkInBounds(list, link) --each entry follows the same as renderImgInBounds
	local allReturned = {}
	for i, v in ipairs(list) do 
		table.insert(allReturned, renderImgInBounds(link, v.x, v.y, v.sizex, v.sizey, v.anchor, v.frameRectOffset, v.frameRectSize, v.callback))
	end
	return allReturned
end

local function createMenuBox(link, x, y, lengthofmiddlex, lengthofmiddley, imgColour) --x&y is origin at top left
	local newf = Instance.new("Frame")
	newf.Size = UDim2.new(1,0,1,0)
	newf.Position = UDim2.new(0,0,0,0)
	newf.AnchorPoint = Vector2.new(0,0)
	newf.BackgroundTransparency = 1
	newf.Parent =  script.Parent.game.loadedassets
	local dictionary = {
		["topleft"] = Vector2.new(0, 0), ["topmiddle"] = Vector2.new(8, 0), ["topright"] = Vector2.new(16, 0), ["middleleft"] = Vector2.new(0, 8), ["middlemiddle"] = Vector2.new(8, 8), ["middleright"] = Vector2.new(16, 8), ["bottomleft"] = Vector2.new(0, 16), ["bottommiddle"] = Vector2.new(8, 16), ["bottomright"] = Vector2.new(16, 16), }
	local size = 8
	local function addToRender(listToRender, cx, cy, offset)
		table.insert(listToRender, {
			["x"] = cx, ["y"] = cy, ["sizex"] = size, ["sizey"] = size, ["anchor"] = Vector2.new(0, 0), ["frameRectOffset"] = offset, ["frameRectSize"] = Vector2.new(size, size), ["callback"] = function(ni) ni.ImageColor3 = imgColour ni.Parent = newf end,
		})
	end
	local function addToRenderInvis(listToRender, cx, cy, offset)
		table.insert(listToRender, {
			["x"] = cx, ["y"] = cy, ["sizex"] = size, ["sizey"] = size, ["anchor"] = Vector2.new(0, 0), ["frameRectOffset"] = offset, ["frameRectSize"] = Vector2.new(size, size), ["callback"] = function(ni) ni.ImageColor3 = imgColour ni.Parent = newf ni.ImageTransparency = 1 end,
		})
	end
	local listToRender = {}
	local cx = x+size
	local cy = y
	addToRender(listToRender, x, y, dictionary.topleft)
	for ii=1, lengthofmiddlex do addToRender(listToRender, cx, cy, dictionary.topmiddle) cx += size end
	addToRender(listToRender, cx, cy, dictionary.topright) cy += size
	for i=1, lengthofmiddley do
		cx = x
		addToRender(listToRender, cx, cy, dictionary.middleleft)
		for ii=0, lengthofmiddlex do
			cx += size
			if ii == lengthofmiddlex then
				addToRenderInvis(listToRender, cx, cy, dictionary.middlemiddle)
			else
				addToRender(listToRender, cx, cy, dictionary.middlemiddle)
			end
		end
		addToRender(listToRender, cx, cy, dictionary.middleright) cy+=size
	end
	cx = x addToRender(listToRender, cx, cy, dictionary.bottomleft) cx += size
	for ii=1, lengthofmiddlex do addToRender(listToRender, cx, cy, dictionary.bottommiddle) cx += size end
	addToRender(listToRender, cx, cy, dictionary.bottomright)
	batchRenderFromSameLinkInBounds(listToRender, link)
	return newf
end

local function drawText(font, txt, x, y, colour)
	local newf = Instance.new("Frame")
	newf.Size = UDim2.new(1,0,1,0)
	newf.Position = UDim2.new(0,0,0,0)
	newf.AnchorPoint = Vector2.new(0,0)
	newf.BackgroundTransparency = 1
	newf.Name = txt
	local cx = x
	local cy = y
	for i, v in ipairs(txt:split(`\n`)) do
		if v == "nw" then
			cy += font3Height+1
			cx = x-font3Width
		else
			renderImgInBounds("/assets/fonts/"..font..".png", cx, cy, 7, 16, Vector2.new(0,0), Vector2.new(font3[v].x, font3[v].y), Vector2.new(7, 16), function(ni)
				ni.Parent = newf
				ni.ImageColor3 = colour
			end)
			cx+=font3[v].w -1
		end
	end
	newf.Parent = script.Parent.game.loadedassets
	return newf
end

local function drawScrollingText(font, txt, x, y, colour, endable, callback)
	local newf = Instance.new("Frame")
	newf.Size = UDim2.new(1,0,1,0)
	newf.Position = UDim2.new(0,0,0,0)
	newf.AnchorPoint = Vector2.new(0,0)
	newf.BackgroundTransparency = 1
	newf.Name = txt
	local scrollTxt = coroutine.create(function()
		local cx = x
		local cy = y
		local str = txt:split(`\n`)
		for i, v in ipairs(str) do
			if v == "nw" then
				cy += font3Height+1
				cx = x
			else
				renderImgInBounds("/assets/fonts/"..font..".png", cx, cy, 7, 16, Vector2.new(0,0), Vector2.new(font3[v].x, font3[v].y), Vector2.new(7, 16), function(ni)
					ni.Parent = newf
					ni.ImageColor3 = colour
				end)
				cx+=font3[v].w -1
			end
			
			wait(0.05)
		end
	end)
	coroutine.resume(scrollTxt)
	newf.Parent = script.Parent.game.loadedassets
	return newf
end

local function dialogueBox(font, txt, endable, callback)
	inDialogue = true
	local box = createMenuBox("/assets/ui/"..txtbox..".png", 16, maxY-48, 24, 4, Color3.new(1,1,1)) --l = 208px
	local x = 24
	local y = maxY-40
	local clr = Color3.new(1,1,1)
	local newf = Instance.new("Frame")
	newf.Size = UDim2.new(1,0,1,0)
	newf.Position = UDim2.new(0,0,0,0)
	newf.AnchorPoint = Vector2.new(0,0)
	newf.BackgroundTransparency = 1
	newf.Name = txt
	local scrollTxt = coroutine.create(function()
		local cx = x
		local cy = y
		local str = txt:split(`\n`)
		for i, v in ipairs(str) do
			if v == "nw" then
				cy += font3Height+1
				cx = x
			else
				renderImgInBounds("/assets/fonts/"..font..".png", cx, cy, 7, 16, Vector2.new(0,0), Vector2.new(font3[v].x, font3[v].y), Vector2.new(7, 16), function(ni)
					ni.Parent = newf
					ni.ImageColor3 = clr
				end)
				cx+=font3[v].w -1
			end

			wait(0.05)
		end
		pcall(function()
			if endable == false then
				renderImgInBounds("/assets/fonts/down_arrow.png", cx+1, cy, 7, 16, Vector2.new(0,0), Vector2.new(0, 0), Vector2.new(8, 16), function(ni)
					ni.Parent = newf
					local a = 1
					local b = {[1] = Vector2.new(0, 0),[2] = Vector2.new(0, 16),[3] = Vector2.new(0, 32),[4] = Vector2.new(0, 48)}
					local anim = coroutine.create(function()
						while wait(0.08) do
							a+=1
							if a > 4 then a = 1 end
							ni.ImageRectOffset = b[a]
						end
					end)
					coroutine.resume(anim)
				end)
				local connect
				connect = uis.InputBegan:Connect(function(inp)
					if inp.KeyCode == inputs.scheme1.interact or inp.KeyCode == inputs.scheme1.cancel then
						playSFX("sel.wav")
						connect:Disconnect()
						callback(newf, box)
					end
				end)
			else
				local connect
				connect = uis.InputBegan:Connect(function(inp)
					if inp.KeyCode == inputs.scheme1.interact then
						connect:Disconnect()
						inDialogue = false
						callback(newf, box)
					end
				end)
			end
		end)
	end)
	coroutine.resume(scrollTxt)
	newf.Parent = script.Parent.game.loadedassets
end

--[[
local function drawHighlightBox(x, y, lengthofmiddlex, lengthofmiddley) --text boxes
	local sizex = (2+lengthofmiddlex)*8
	local sizey = (2+lengthofmiddley)*8
	x += 1
	y += 1
	sizex -= 2
	sizey -= 2
	
	print(sizex)
	
	return renderImg("/assets/titlescreen/brightwhitelight.png", x, y, sizex, sizey, topoption.Parent = newfolderVector2.new(0, 0), function(ni)
		ni.ImageTransparency = 0.5
	end)
end
--]]

local function playTheGame()
	game.ReplicatedStorage["remote events (RARE!!!!)"]["gib welcome badge"]:FireServer()
	while began == false do
		clearGraphics()
		start = false
		skip = false
		print("cycle")
		local function boot()
			if start == false then
				local newsound = Instance.new("Sound")
				newsound.SoundId = pbu.."/music/1.mp3"
				newsound.Volume = 1

				newsound.Parent = script.Parent
				newsound:Play()
				return newsound
			end
		end

		local function boot2(newsound)
			if start == false then
				newsound.SoundId = pbu.."/music/2.mp3"
				newsound:Play()
			end
		end

		local function titleScreen(newsound)
			if start == false and skip == false then
				start = true
				clearGraphics()
				newsound.SoundId = pbu.."/music/3.mp3"
				newsound:Play()
				
				script.Parent.game.overlay.BackgroundColor3 = Color3.new(1, 1, 1)
				script.Parent.game.overlay.BackgroundTransparency = 0
				
				--finaly should be ~35?
				local flash = renderImg("/assets/titlescreen/brightwhitelight.png", 0, 0, maxX, maxY, Vector2.new(0, 0))
				local title = renderMaskImg("/assets/titlescreen/title.png", maxX/2, 68, 175, 64, Vector2.new(0.5, .5))
				local shine = renderMaskImg("/assets/titlescreen/logo_shine.png", -85, 0, 85, maxY, Vector2.new(0, 0))
				shine.Parent = title
				
				flash.ImageTransparency = 1
				
				shine.maskedwithinframe.ImageTransparency = 0.5
				
				genericOpacityTween(script.Parent.game.overlay, 1, 10, function()
					shine.Position = UDim2.new(0-shine.Size.X.Scale,0,0,0)
					shine:TweenPosition(UDim2.new(1, 0, 0, 0))
					wait(1.45)
					flash.ImageTransparency = 1
					genericOpacityTween(flash, 0, 10)
					wait()
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
		local base = 40
		local space = 15
		
		local lines = batchRenderFromSameLinkInBounds({
			--[[ 2003 txt ]]{["x"] = 80-test, ["y"] = base+(space), ["sizex"] = 28, ["sizey"] = 8, ["anchor"] = Vector2.new(0.5,0.5), ["frameRectOffset"] = Vector2.new(15, 0), ["frameRectSize"] = Vector2.new(30,8), ["callback"] = "",},
			--[[ cpr symbol 1 ]]{["x"] = 70-test, ["y"] = base+(space*2), ["sizex"] = 9, ["sizey"] = 8, ["anchor"] = Vector2.new(0.5,0.5), ["frameRectOffset"] = Vector2.new(15, 0), ["frameRectSize"] = Vector2.new(9,8), ["callback"] = "",},
			--[[ cpr symbol 2 ]]{["x"] = 70-test, ["y"] = base+(space*3), ["sizex"] = 9, ["sizey"] = 8, ["anchor"] = Vector2.new(0.5,0.5), ["frameRectOffset"] = Vector2.new(15, 0), ["frameRectSize"] = Vector2.new(9,8), ["callback"] = "",},
			--[[ cpr symbol 3 ]]{["x"] = 70-test, ["y"] = base+(space*4), ["sizex"] = 9, ["sizey"] = 8, ["anchor"] = Vector2.new(0.5,0.5), ["frameRectOffset"] = Vector2.new(15, 0), ["frameRectSize"] = Vector2.new(9,8), ["callback"] = "",},
			--[[ pokemon txt ]]{["x"] = maxX/2, ["y"] = base+(space), ["sizex"] = 52, ["sizey"] = 8, ["anchor"] = Vector2.new(0,0.5), ["frameRectOffset"] = Vector2.new(49, 0), ["frameRectSize"] = Vector2.new(52,8), ["callback"] = "",},
			--[[ date txt 1 ]]{["x"] = 75-test, ["y"] = base+(space*2), ["sizex"] = 41, ["sizey"] = 8, ["anchor"] = Vector2.new(0,0.5), ["frameRectOffset"] = Vector2.new(105, 0), ["frameRectSize"] = Vector2.new(41,8), ["callback"] = "",},
			--[[ date txt 2 ]]{["x"] = 75-test, ["y"] = base+(space*3), ["sizex"] = 41, ["sizey"] = 8, ["anchor"] = Vector2.new(0,0.5), ["frameRectOffset"] = Vector2.new(105, 0), ["frameRectSize"] = Vector2.new(41,8), ["callback"] = "",},
			--[[ date txt 3 ]]{["x"] = 75-test, ["y"] = base+(space*4), ["sizex"] = 41, ["sizey"] = 8, ["anchor"] = Vector2.new(0,0.5), ["frameRectOffset"] = Vector2.new(105, 0), ["frameRectSize"] = Vector2.new(41,8), ["callback"] = "",},
			--[[ nintendo txt ]]{["x"] = 120, ["y"] = base+(space*2), ["sizex"] = 50, ["sizey"] = 8, ["anchor"] = Vector2.new(0,0.5), ["frameRectOffset"] = Vector2.new(153, 0), ["frameRectSize"] = Vector2.new(50,8), ["callback"] = "",},
			--[[ creatures txt ]]{["x"] = 120, ["y"] = base+(space*3), ["sizex"] = 61, ["sizey"] = 8, ["anchor"] = Vector2.new(0,0.5), ["frameRectOffset"] = Vector2.new(1, 9), ["frameRectSize"] = Vector2.new(61,7), ["callback"] = "",},
			--[[ gamefreak txt ]]{["x"] = 120, ["y"] = base+(space*4), ["sizex"] = 71, ["sizey"] = 8, ["anchor"] = Vector2.new(0,0.5), ["frameRectOffset"] = Vector2.new(65, 9), ["frameRectSize"] = Vector2.new(71,7), ["callback"] = "",},
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
					if inp.KeyCode == inputs.scheme1.interact or inp.KeyCode == inputs.scheme1.cancel or inp.KeyCode == inputs.scheme1.menu then
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
								--main titlescreen
								began = true
								local bg = renderImg(pbu.."/assets/titlescreen/brightwhitelight.png", 0 ,0, maxX, maxY, Vector2.new(0 ,0))
								bg.BackgroundColor3 = Color3.new(0.309804, 0.32549, 0.560784)
								bg.ImageTransparency = 1
								bg.BackgroundTransparency = 0
								script.Parent.game.overlay.BackgroundTransparency = 1
								wait(.1)
								print("dasfadf")
								local box = dialogueBox("font3_dark", "T\nh\ne\n \ni\nn\nt\ne\nr\nn\na\nl\n \nb\na\nt\nt\ne\nr\ny\n \nh\na\ns\n \nr\nu\nn\n \nd\nr\ny\n.\nnw\nT\nh\ne\n \ng\na\nm\ne\n \nc\na\nn\n \nb\ne\n \np\nl\na\ny\ne\nd\n.", false, function(txt, bx)
									txt:Destroy()
									bx:Destroy()
									local newbox = dialogueBox("font3_dark", "H\no\nw\ne\nv\ne\nr\ncomma\n \nc\nl\no\nc\nk\n-\nb\na\ns\ne\nd\n \ne\nv\ne\nn\nt\ns\n \nw\ni\nl\nl\nnw\nn\no\n \nl\no\nn\ng\ne\nr\n \no\nc\nc\nu\nr\n.", true, function(txt, bx)
										txt:Destroy()
										bx:Destroy()
										local folder = Instance.new("Folder")
										folder.Name = "btns"
										folder.Parent = script.Parent.game.loadedassets
										local function renderNew(selected)
											local newfolder = Instance.new("Folder")
											newfolder.Name = folder.Name
											newfolder.Parent = folder.Parent
											local c1 = Color3.new(0.5, 0.5, 0.5)
											local c2 = Color3.new(0.5, 0.5, 0.5)
											local c3 = Color3.new(0.5, 0.5, 0.5)
											local csn = Color3.new(1, 1, 1)
											local cnsn = Color3.new(0.5, 0.5, 0.5)
											local mcsn = Color3.new(0.129412, 0.517647, 1)
											local mcnsn = Color3.new(0.064706, 0.2588235, 0.5)
											if selected == 1 then c1 = Color3.new(1, 1, 1) end
											if selected == 2 then c2 = Color3.new(1, 1, 1) end
											if selected == 3 then c3 = Color3.new(1, 1, 1) end
											local function getclr(selectedReq, cs, cns)
												if selected == selectedReq then
													return cs
												else
													return cns
												end
											end
											local topoption = createMenuBox("/assets/ui/"..txtbox..".png", 8, 1, 26, 6, c1) topoption.Parent = newfolder
											local middleoption = createMenuBox("/assets/ui/"..txtbox..".png", 8, 65, 26 ,2, c2) middleoption.Parent = newfolder
											local bottomoption = createMenuBox("/assets/ui/"..txtbox..".png", 8, 65+32, 26 ,2, c3) bottomoption.Parent = newfolder
											local txt = drawText("font3_dark", "C\nO\nN\nT\nI\nN\nU\nE", 16, 9, getclr(1, csn, cnsn)) txt.Parent = topoption
											local plrtitle = drawText("font3_new", "P\nL\nA\nY\nE\nR", 16, 9+16, getclr(1, mcsn, mcnsn)) plrtitle.Parent = topoption
											local pkdxtitle = drawText("font3_new", "P\nO\nK\nefa\nD\nE\nX", 16, 9+32, getclr(1, mcsn, mcnsn)) pkdxtitle.Parent = topoption
											local txt2 = drawText("font3_dark", "N\nE\nW\n \nG\nA\nM\nE", 16, 73, getclr(2, csn, cnsn)) txt2.Parent = middleoption
											local txt3 = drawText("font3_dark", "O\nP\nT\nI\nO\nN\nS", 16, 65+23+8+8, getclr(3, csn, cnsn)) txt3.Parent = bottomoption
											folder:Destroy()
										end
										local selected = 1
										renderNew(selected)
										--drawScrollingText("font3_dark", "R\ne\na\nl\n \nt\ne\ns\nt\ni\nn\ng\n \nt\ne\nx\nt", 0, 0, Color3.new(1, 1, 1))
										local connection = uis.InputBegan:Connect(function(inp)
											if start == true and began == true then
												if inp.KeyCode == inputs.scheme1.up then
													selected -= 1
													if selected == 0 then selected = 3 end
													renderNew(selected)
												elseif inp.KeyCode == inputs.scheme1.down then
													selected += 1
													if selected == 4 then selected = 1 end
													renderNew(selected)
												end
											end

										end)
									end)
								end)
							end)
						end)
					end
				else
					if began == true and start == true and inDialogue == false and inp.KeyCode == inputs.scheme1.cancel then
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
						clearGraphics()
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
