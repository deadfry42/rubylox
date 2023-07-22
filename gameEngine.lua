local module = {}

-- includes --
local fontrom = require(game.ReplicatedStorage.fontrom)
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

-- replace later --
local textspeed = "slow"
local txtbox = 1

-- triggers --
local inDialogue = script.Parent.Triggers.inDialogue

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
			module.renderImgInBounds("/assets/fonts/"..font..".png", cx, cy, 7, 16, Vector2.new(0,0), Vector2.new(font3[v].x, font3[v].y), Vector2.new(7, 16), function(ni)
				ni.Parent = newf
				ni.ImageColor3 = colour
			end)
			cx+=font3[v].w -1
		end
	end
	newf.Parent = script.Parent.Parent.game.loadedassets
	return newf
end

module.drawScrollingText = function(font, txt, x, y, colour, endable, callback)
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
				module.renderImgInBounds("/assets/fonts/"..font..".png", cx, cy, 7, 16, Vector2.new(0,0), Vector2.new(font3[v].x, font3[v].y), Vector2.new(7, 16), function(ni)
					ni.Parent = newf
					ni.ImageColor3 = colour
				end)
				cx+=font3[v].w -1
			end

			task.wait(fontrom.scrollspeeds[textspeed])
		end
	end)
	coroutine.resume(scrollTxt)
	newf.Parent = script.Parent.Parent.game.loadedassets
	return newf
end

module.dialogueBox = function(font, txt, endable, speed, callback)
	inDialogue.Value = true
	local font3Height = fontrom.font3.height
	local font3Width = fontrom.font3.width
	local font3 = fontrom.font3.offsets
	local box = module.createMenuBox("/assets/ui/"..txtbox..".png", 16, maxY-48, 24, 4, Color3.new(1,1,1)) --l = 208px
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
				module.renderImgInBounds("/assets/fonts/"..font..".png", cx, cy, 7, 16, Vector2.new(0,0), Vector2.new(font3[v].x, font3[v].y), Vector2.new(7, 16), function(ni)
					ni.Parent = newf
					ni.ImageColor3 = clr
				end)
				cx+=font3[v].w -1
			end

			if uis:IsKeyDown(inputs.scheme1.cancel) then
				task.wait(fontrom.scrollspeeds["megascroll"])
			else
				task.wait(fontrom.scrollspeeds[textspeed])
			end
		end
		pcall(function()
			if endable == false then
				module.renderImgInBounds("/assets/fonts/down_arrow.png", cx+1, cy, 7, 16, Vector2.new(0,0), Vector2.new(0, 0), Vector2.new(8, 16), function(ni)
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
						module.playSFX("sel.wav")
						connect:Disconnect()
						callback(newf, box)
					end
				end)
			else
				local connect
				connect = uis.InputBegan:Connect(function(inp)
					if inp.KeyCode == inputs.scheme1.interact then
						connect:Disconnect()
						inDialogue.Value = false
						callback(newf, box)
					end
				end)
			end
		end)
	end)
	coroutine.resume(scrollTxt)
	newf.Parent = script.Parent.Parent.game.loadedassets
end

return module
