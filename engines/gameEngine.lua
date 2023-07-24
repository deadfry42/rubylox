local module = {}

-- includes --
local fontrom = require(game.ReplicatedStorage.fontrom)
local pbu = require(game.ReplicatedStorage.patchbaseurl)
local ctrls = require(game.ReplicatedStorage.inputs)
local rendering = require(script.Parent.renderingEngine)
local savefile = require(script.Parent.savingEngine)
local inputs = require(script.Parent.inputEngine)

-- compile vars --
local folder = game.ReplicatedStorage.compileSettings
---
local maxX = folder.maxX.Value
local maxY = folder.maxY.Value
local defaultScrollSpeed = folder.defaultScrollSpeed.Value

-- services --
local twns = game:GetService("TweenService")

--[[
module.drawText = function(font, txt, x, y, colour)
	local font3Height = fontrom.font3.height
	local font3Width = fontrom.font3.width
	local font3 = fontrom.font3.offsets
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
			rendering.renderImgInBounds("/assets/fonts/"..font..".png", cx, cy, 7, 16, Vector2.new(0,0), Vector2.new(font3[v].x, font3[v].y), Vector2.new(7, 16), function(ni)
				ni.Parent = newf
				ni.ImageColor3 = colour
			end)
			cx+=font3[v].w -1
		end
	end
	newf.Parent = script.Parent.Parent.Parent.gry.loadedassets
	return newf
end
]]

module.drawText = function(font, txt, x, y, colour)
	local font3Height = fontrom.font3.height
	local font3Width = fontrom.font3.width
	local font3 = fontrom.font3.offsets
	local newf = Instance.new("Frame")
	newf.Size = UDim2.new(1,0,1,0)
	newf.Position = UDim2.new(0,0,0,0)
	newf.AnchorPoint = Vector2.new(0,0)
	newf.BackgroundTransparency = 1
	newf.Name = txt
	local cx = x
	local cy = y
	local sections = txt:split("|")
	--returns {(So it), (apos), (s ), (plrname), (?)}
	for i, v in ipairs(sections) do
		local towrite = {}
		if v:sub(1,1) == "`" then
			local code = v:sub(2, -1)
			--letters
			if code == "nw" then
				cy += font3Height+1
				cx = x
			else
				table.insert(towrite, code)
			end
		elseif v:sub(1,1) == "``" then
			local code = v:sub(3, -1)
			--functions
			if code == "plrname" then
				local name = savefile.pullFromSaveData("trainer.name", "")
				for letter in name:gmatch(".") do
					table.insert(towrite,letter)
				end
			elseif code:match("func", 1) then
				--function, run now
				local detect = code:split("(")
				local scriptname = detect[2]:sub(1, #detect[2]-1)
				local run = require(game.ReplicatedStorage.functionReferences[scriptname])
				run()
			end
		else
			for letter in v:gmatch(".") do
				table.insert(towrite,letter)
			end
		end
		if towrite ~= nil and towrite ~= {} then
			for i, letter in towrite do
				rendering.renderImgInBounds("/assets/fonts/"..font..".png", cx, cy, 7, 16, Vector2.new(0,0), Vector2.new(font3[letter].x, font3[letter].y), Vector2.new(7, 16), function(ni)
					ni.Parent = newf
					ni.ImageColor3 = colour
				end)
				cx += (font3[letter].w - 1)
			end
		end
	end
	newf.Parent = script.Parent.Parent.Parent.gry.loadedassets
	return newf
end

module.drawScrollingText = function(font, txt, x, y, colour, endable, callback)
	local textspeed = savefile.pullFromSaveData("options.txtspd", defaultScrollSpeed) 
	local font3Height = fontrom.font3.height
	local font3Width = fontrom.font3.width
	local font3 = fontrom.font3.offsets
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
				rendering.renderImgInBounds("/assets/fonts/"..font..".png", cx, cy, 7, 16, Vector2.new(0,0), Vector2.new(font3[v].x, font3[v].y), Vector2.new(7, 16), function(ni)
					ni.Parent = newf
					ni.ImageColor3 = colour
				end)
				cx+=font3[v].w -1
			end

			task.wait(fontrom.scrollspeeds[textspeed])
		end
	end)
	coroutine.resume(scrollTxt)
	newf.Parent = script.Parent.Parent.Parent.gry.loadedassets
	return newf
end

module.createMenuBox = function(link, x, y, lengthofmiddlex, lengthofmiddley, imgColour) --x&y is origin at top left
	local newf = Instance.new("Frame")
	newf.Size = UDim2.new(1,0,1,0)
	newf.Position = UDim2.new(0,0,0,0)
	newf.AnchorPoint = Vector2.new(0,0)
	newf.BackgroundTransparency = 1
	newf.Parent =  script.Parent.Parent.Parent.gry.loadedassets
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
	rendering.batchRenderFromSameLinkInBounds(listToRender, link)
	return newf
end

module.dialogueBox = function(font, inps, prev, txt, endable, y, txtbox, callback)
	local inputAllowed = inps
	local PreviousTxt = prev
	if PreviousTxt == nil then PreviousTxt = "" end
	if inputAllowed == nil then inputAllowed = true end
	local s, e = pcall(function()
		local textspeed = savefile.pullFromSaveData("options.txtspd", defaultScrollSpeed) 
		inputs.wipeAllFuncs()
		local font3Height = fontrom.font3.height
		local font3Width = fontrom.font3.width
		local font3 = fontrom.font3.offsets
		local box = module.createMenuBox("/assets/ui/"..txtbox..".png", 16, y-8, 24, 4, Color3.new(1,1,1)) --l = 208px
		local x = 24
		local clr = Color3.new(1,1,1)
		local newf = Instance.new("Frame")
		newf.Size = UDim2.new(1,0,1,0)
		newf.Position = UDim2.new(0,0,0,0)
		newf.AnchorPoint = Vector2.new(0,0)
		newf.BackgroundTransparency = 1
		newf.Name = txt
		coroutine.resume(coroutine.create(function()
			local cx = x
			local cy = y
			local sections = PreviousTxt:split("|")
			for i, v in ipairs(sections) do
				local towrite = {}
				if v:sub(1,1) == "`" and v:sub(1,2) ~= "``" then
					local code = v:sub(2, -1)
					--letters
					if code == "nw" then
						cy += font3Height+1
						cx = x
					else
						table.insert(towrite, code)
					end
				elseif v:sub(1,2) == "``" then
					local code = v:sub(3, -1)
					--functions
					if code:match("save") then
						local path = v:sub(5,-1)
						path:sub(1, #path-1)
						local data = savefile.pullFromSaveData(path, "")
						for letter in data:gmatch(".") do
							table.insert(towrite,letter)
						end
					end
				else
					for letter in v:gmatch(".") do
						table.insert(towrite,letter)
					end
				end
				if towrite ~= nil and towrite ~= {} then
					for i, letter in towrite do
						rendering.renderImgInBounds("/assets/fonts/"..font..".png", cx, cy, 7, 16, Vector2.new(0,0), Vector2.new(font3[letter].x, font3[letter].y), Vector2.new(7, 16), function(ni)
							ni.Parent = newf
							ni.ImageColor3 = clr
						end)
						cx += (font3[letter].w - 1)
					end
				end
			end
			-- actual typing








			local sections = txt:split("|")
			for i, v in ipairs(sections) do
				local towrite = {}
				if v:sub(1,1) == "`" and v:sub(1,2) ~= "``" then
					local code = v:sub(2, -1)
					--letters
					if code == "nw" then
						cy += font3Height+1
						cx = x
					else
						table.insert(towrite, code)
					end
				elseif v:sub(1,2) == "``" then
					local code = v:sub(3, -1)
					--functions
					if code:match("save") then
						local path = v:sub(8,#v-1)
						local data = savefile.pullFromSaveData(path, "")
						for letter in data:gmatch(".") do
							table.insert(towrite,letter)
						end
						print(towrite)
					elseif code:match("func") then
						--function, run now
						local detect = code:split("(")
						local scriptname = detect[2]:sub(1, #detect[2]-1)
						table.insert(towrite, "func=>"..scriptname)
					end
				else
					for letter in v:gmatch(".") do
						table.insert(towrite,letter)
					end
				end
				if towrite ~= nil and towrite ~= {} then
					for i, letter in towrite do
						if letter:sub(1,6) == "func=>" then
							local s, e = pcall(function()
								local scriptname = letter:sub(7, -1)
								local run = require(game.ReplicatedStorage.functionReferences[scriptname])
								run(script)
							end)
							if e then print(e) end
						else
							rendering.renderImgInBounds("/assets/fonts/"..font..".png", cx, cy, 7, 16, Vector2.new(0,0), Vector2.new(font3[letter].x, font3[letter].y), Vector2.new(7, 16), function(ni)
								ni.Parent = newf
								ni.ImageColor3 = clr
							end)
							cx += (font3[letter].w - 1)
						end

						if inputAllowed then
							if inputs.isKeyDown(ctrls.scheme1.cancel) or inputs.isKeyDown(ctrls.scheme1.interact) then
								task.wait(fontrom.scrollspeeds["megascroll"])
							else
								task.wait(fontrom.scrollspeeds[textspeed])
							end
						else
							task.wait(fontrom.scrollspeeds[textspeed])
						end
					end
				end
			end
			pcall(function()
				if endable == false then
					rendering.renderImgInBounds("/assets/fonts/down_arrow.png", cx+1, cy, 7, 16, Vector2.new(0,0), Vector2.new(0, 0), Vector2.new(8, 16), function(ni)
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
					if inputAllowed then
						local function advance()
							rendering.playSFX("sel.wav")
							callback(newf, box)
						end
						inputs.assignKeyToFunc(ctrls.scheme1.interact, "advancetxt", advance, true)
						inputs.assignKeyToFunc(ctrls.scheme1.cancel, "advancetxt", advance, true)
					else
						callback(newf, box)
					end
				else
					if inputAllowed then
						local function finish()
							callback(newf, box)
						end
						inputs.assignKeyToFunc(ctrls.scheme1.interact, "advancetxt", finish, true)
					else
						callback(newf, box)
					end
				end
			end)
		end))
		newf.Parent = script.Parent.Parent.Parent.gry.loadedassets
	end)
	if e then error(e) end
end

module.drawOutline = function(x, y, sizex, sizey, colour, callback)
	local parentFrame = Instance.new("Frame")
	parentFrame.Position = UDim2.new(0,0,0,0)
	parentFrame.AnchorPoint = Vector2.new(0,0)
	parentFrame.Size = UDim2.new(1,0,1,0)
	parentFrame.BackgroundTransparency = 1
	parentFrame.Parent = script.Parent.Parent.Parent.gry.loadedassets
	
	local leftSide = Instance.new("Frame")
	leftSide.BackgroundColor3 = colour
	leftSide.BorderSizePixel = 0
	leftSide.Size = UDim2.new(1/maxX, 0, (sizey-3)/maxY, 0)
	leftSide.Position = UDim2.new(x/maxX, 0, (y+1)/maxY, 0)
	leftSide.Parent = parentFrame
	
	local rightSide = leftSide:Clone()
	rightSide.Position += UDim2.new((sizex-2)/maxX, 0, 0, 0)
	rightSide.Parent = parentFrame
	
	local topSide = Instance.new("Frame")
	topSide.BackgroundColor3 = colour
	topSide.BorderSizePixel = 0
	topSide.Size = UDim2.new((sizex-3)/maxX, 0, 1/maxY, 0)
	topSide.Position = UDim2.new((x+1)/maxX, 0, y/maxY, 0)
	topSide.Parent = parentFrame
	
	local bottomSide = topSide:Clone()
	bottomSide.Position += UDim2.new(0, 0, (sizey-2)/maxY, 0)
	bottomSide.Parent = parentFrame
	
	pcall(function()
		callback(parentFrame)
	end)
	
	return parentFrame
end

return module
