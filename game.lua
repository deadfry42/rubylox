--includes
local pbu = require(game.ReplicatedStorage.patchbaseurl)
local inputs = require(game.ReplicatedStorage.inputs)
local fontrom = require(game.ReplicatedStorage.fontrom)
local engine = require(script.engine)

--services
local twns = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local cntp = game:GetService("ContentProvider")
local bs = game:GetService("BadgeService")

--game settings compiled at runtime
local folder = game.ReplicatedStorage.compileSettings
---
local versionPng = folder.versionPng.Value
local maxX = folder.maxX.Value
local maxY = folder.maxY.Value

--settings
local textspeed = "slow"
local txtbox = 1

--other
local triggers = script.Triggers

local font3Width = fontrom.font3.width
local font3Height = fontrom.font3.height
local font3 = fontrom.font3.offsets

--[[
things to fix (at a later date):
 - logo_shine not properly masking onto logo
 - add the funny cutscene at the start of the game booting
 - fix how goofy the title screen looks
 - make the continue option actually work
 - fix weird looping issues
]]

--the 'keeptrackers'
local start = false
local began = false
local skip = false
local inDialogue = script.Triggers.inDialogue.Value



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
		engine.clearGraphics()
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
				engine.clearGraphics()
				newsound.SoundId = pbu.."/music/3.mp3"
				newsound:Play()
				
				script.Parent.game.overlay.BackgroundColor3 = Color3.new(1, 1, 1)
				script.Parent.game.overlay.BackgroundTransparency = 0
				
				--finaly should be ~35?
				local flash = engine.renderImg("/assets/titlescreen/brightwhitelight.png", 0, 0, maxX, maxY, Vector2.new(0, 0))
				local title = engine.renderMaskImg("/assets/titlescreen/title.png", maxX/2, 68, 175, 64, Vector2.new(0.5, .5))
				local shine = engine.renderMaskImg("/assets/titlescreen/logo_shine.png", -85, 0, 85, maxY, Vector2.new(0, 0))
				local versxbase = (maxX/2)-(64/2)
				local vers = engine.createElemFromBatchImgs({
					{["x"] = versxbase, ["y"] = 10, ["sizex"] = 46, ["sizey"] = 28, ["anchor"] = Vector2.new(0,0), ["frameRectOffset"] = Vector2.new(18, 2), ["frameRectSize"] = Vector2.new(46,28), ["callback"] = (function(ni) ni.ImageTransparency = 1 end),},
					{["x"] = versxbase+46, ["y"] = 10, ["sizex"] = 35, ["sizey"] = 28, ["anchor"] = Vector2.new(0,0), ["frameRectOffset"] = Vector2.new(0, 34), ["frameRectSize"] = Vector2.new(45,28), ["callback"] = (function(ni) ni.ImageTransparency = 1 end),}
				}, "/assets/titlescreen/version.png")
				shine.Parent = title
				
				flash.ImageTransparency = 1
				
				shine.maskedwithinframe.ImageTransparency = 0.5
				
				engine.genericOpacityTween(script.Parent.game.overlay, 1, 10, function()
					shine.Position = UDim2.new(0-shine.Size.X.Scale,0,0,0)
					shine:TweenPosition(UDim2.new(1, 0, 0, 0))
					wait(1.45)
					flash.ImageTransparency = 1
					engine.genericOpacityTween(flash, 0, 10, function()
						wait()
						shine.Position = UDim2.new(0-shine.Size.X.Scale,0,0,0)
						shine:TweenPosition(UDim2.new(1, 0, 0, 0))
						wait(0.05)
						engine.genericOpacityTween(flash, 1, 20, function()
							wait(0.6)
							engine.genericOpacityTween(flash, 0, 10, function()
								shine.Position = UDim2.new(0-shine.Size.X.Scale,0,0,0)
								wait(0.05)
								shine:TweenPosition(UDim2.new(1, 0, 0, 0))
								engine.genericOpacityTween(flash, 1, 20, function()
									wait(0.5)
									for i, v in ipairs(vers:GetChildren()) do
										engine.genericOpacityTween(v, 0, 30)
										engine.genericPosTween(v, v.Position.X.Scale*maxX, 55, 1)
									end
									engine.genericPosTween(title, maxX/2, 35, 1, function()
										wait(1)
										print("maintitlescreen")
										shine:Destroy()
										flash:Destroy()
										local bubles = engine.renderImgInBounds("/assets/titlescreen/debugmonster.png", -1, 0, 32, 32, Vector2.new(0, 0), Vector2.new(7, 0), Vector2.new(32, 32))
										local prevY = 0
										for i=1, 5 do
											local prevX = -(31/maxX)
											for i=1, 8 do
												local clon = bubles:Clone()
												clon.Position += UDim2.new(prevX+(31/maxX), 0, prevY, 0)
												clon.ZIndex = -10
												clon.Parent = script.Parent.game.loadedassets
												prevX = clon.Position.X.Scale
											end
											prevY+=(32/maxY)
										end
										bubles:Destroy()
									end)
								end)
							end)
						end)
					end)
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
		
		local lines = engine.batchRenderFromSameLinkInBounds({
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
		engine.genericOpacityTween(script.Parent.game.overlay, 1, 10)
		
		wait(2.5)
		engine.batchGenericOpacityTween(lines, 0, 1, 10)
		wait(.5)
		engine.clearGraphics()
		
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
						engine.genericOpacityTween(script.Parent.game.overlay, 0, 10, function()
							engine.clearGraphics()
							engine.genericColorTween(script.Parent.game.overlay, Color3.new(0.501961, 0.596078, 0.784314), 10, function()
								wait(.1)
								engine.genericColorTween(script.Parent.game.overlay, Color3.new(0.309804, 0.32549, 0.560784), 2)
								--main titlescreen
								began = true
								local bg = engine.renderImg(pbu.."/assets/titlescreen/brightwhitelight.png", 0 ,0, maxX, maxY, Vector2.new(0 ,0))
								bg.BackgroundColor3 = Color3.new(0.309804, 0.32549, 0.560784)
								bg.ImageTransparency = 1
								bg.BackgroundTransparency = 0
								script.Parent.game.overlay.BackgroundTransparency = 1
								wait(.1)
								local savefile = false
								local me = false
								pcall(function()
									if game.Players.LocalPlayer.save.trainer.sid.Value > 0 then
										savefile = true
									end
								end)
								pcall(function()
									if game.Players.LocalPlayer.save.me.Value == true then
										me = true
									end
								end)
								local box = engine.dialogueBox("font3_dark", "T\nh\ne\n \ni\nn\nt\ne\nr\nn\na\nl\n \nb\na\nt\nt\ne\nr\ny\n \nh\na\ns\n \nr\nu\nn\n \nd\nr\ny\n.\nnw\nT\nh\ne\n \ng\na\nm\ne\n \nc\na\nn\n \nb\ne\n \np\nl\na\ny\ne\nd\n.", false, false, function(txt, bx)
									txt:Destroy()
									bx:Destroy()
									local newbox = engine.dialogueBox("font3_dark", "H\no\nw\ne\nv\ne\nr\ncomma\n \nc\nl\no\nc\nk\n-\nb\na\ns\ne\nd\n \ne\nv\ne\nn\nt\ns\n \nw\ni\nl\nl\nnw\nn\no\n \nl\no\nn\ng\ne\nr\n \no\nc\nc\nu\nr\n.", true, false, function(txt, bx)
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
											local c4 = Color3.new(0.5, 0.5, 0.5)
											local csn = Color3.new(1, 1, 1)
											local cnsn = Color3.new(0.5, 0.5, 0.5)
											local mcsn = Color3.new(0.129412, 0.517647, 1)
											local mcnsn = Color3.new(0.064706, 0.2588235, 0.5)
											if selected == 1 then c1 = Color3.new(1, 1, 1) end
											if selected == 2 then c2 = Color3.new(1, 1, 1) end
											if selected == 3 then c3 = Color3.new(1, 1, 1) end
											if selected == 4 then c4 = Color3.new(1, 1, 1) end
											local function getclr(selectedReq, cs, cns)
												if selected == selectedReq then
													return cs
												else
													return cns
												end
											end
											local motop = 0
											if savefile then
												motop = 65
												local topoption = engine.createMenuBox("/assets/ui/"..txtbox..".png", 8, 1, 26, 6, c1) topoption.Parent = newfolder
												local txt = engine.drawText("font3_dark", "C\nO\nN\nT\nI\nN\nU\nE", 16, 9, getclr(1, csn, cnsn)) txt.Parent = topoption
												local plrtitle = engine.drawText("font3_new", "P\nL\nA\nY\nE\nR", 16, 9+16, getclr(1, mcsn, mcnsn)) plrtitle.Parent = topoption
												local pkdxtitle = engine.drawText("font3_new", "P\nO\nK\nefa\nD\nE\nX", 16, 9+32, getclr(1, mcsn, mcnsn)) pkdxtitle.Parent = topoption
												local timetitle = engine.drawText("font3_new", "T\nI\nM\nE", maxX/2+5, 9+16, getclr(1, mcsn, mcnsn)) timetitle.Parent = topoption
												local badgetext = engine.drawText("font3_new", "B\nA\nD\nG\nE\nS", maxX/2+5, 9+32, getclr(1, mcsn, mcnsn)) badgetext.Parent = topoption
											end
											
											local middleoption = engine.createMenuBox("/assets/ui/"..txtbox..".png", 8, motop, 26 ,2, c2) middleoption.Parent = newfolder
											local txt2 = engine.drawText("font3_dark", "N\nE\nW\n \nG\nA\nM\nE", 16, motop+8, getclr(2, csn, cnsn)) txt2.Parent = middleoption
											
											local bottomoption = engine.createMenuBox("/assets/ui/"..txtbox..".png", 8, motop+32, 26 ,2, c3) bottomoption.Parent = newfolder
											local txt3 = engine.drawText("font3_dark", "O\nP\nT\nI\nO\nN\nS", 16, motop+23+8+8, getclr(3, csn, cnsn)) txt3.Parent = bottomoption
											
											if me then
												local bottomeroption = engine.createMenuBox("/assets/ui/"..txtbox..".png", 8, motop+32+32, 26 ,2, c4) bottomeroption.Parent = newfolder
												local txt4 = engine.drawText("font3_dark", "M\nY\nS\nT\nE\nR\nY\n \nE\nV\nE\nN\nT", 16, motop+23+8+8+32, getclr(4, csn, cnsn)) txt4.Parent = bottomeroption
											end
											folder:Destroy()
											folder = newfolder
										end
										local selected = 2
										if savefile then selected = 1 end
										renderNew(selected)
										--drawScrollingText("font3_dark", "R\ne\na\nl\n \nt\ne\ns\nt\ni\nn\ng\n \nt\ne\nx\nt", 0, 0, Color3.new(1, 1, 1))
										local min = 2
										local max = 3
										if savefile then min = 1 end
										if me then max = 4 end
										local connection
										connection = uis.InputBegan:Connect(function(inp)
											if start == true and began == true then
												if inp.KeyCode == inputs.scheme1.up then
													selected -= 1
													if selected == min-1 then selected = max end
													renderNew(selected)
												elseif inp.KeyCode == inputs.scheme1.down then
													selected += 1
													if selected == max+1 then selected = min end
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
						engine.playSFX("sel.wav")
						newsound:Stop()
						newsound.Volume = 1
						script.Parent.game.overlay.BackgroundTransparency = 0
						script.Parent.game.overlay.BackgroundColor3 = Color3.new(0.309804, 0.32549, 0.560784)
						engine.genericColorTween(script.Parent.game.overlay, Color3.new(1, 1, 1), 5)
						start = false
						skip = false
						began = false
						wait(0.2)
						engine.clearGraphics()
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
			engine.clearGraphics()
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
		cntp:PreloadAsync({pbu.."/confirmation/"..versionPng}, function(assetID2, assetwhatevermajiggy2)
			if assetwhatevermajiggy2 == Enum.AssetFetchStatus.Success then
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
				script.Parent.game.Error.Text = "Your patch is out of date! Please re-install the patch."
				script.Parent.game.Error.Visible = true
			end
		end)
	else
		script.Parent.game.Error.Visible = true
		print("Please join the discord.")
	end
end)
