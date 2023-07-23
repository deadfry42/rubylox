local menuscreen = {}
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
menuscreen.run = function()
	inputs.wipeAllFuncs()
	rendering.clearGraphics()
	rendering.genericColorTween(script.Parent.Parent.Parent.Parent.gry.overlay, Color3.new(0.501961, 0.596078, 0.784314), 10, function()
		wait(.1)
		rendering.genericColorTween(script.Parent.Parent.Parent.Parent.gry.overlay, Color3.new(0.309804, 0.32549, 0.560784), 2)
		--main titlescreen
		local bg = rendering.renderImg(pbu.."/assets/titlescreen/brightwhitelight.png", 0 ,0, maxX, maxY, Vector2.new(0 ,0))
		bg.BackgroundColor3 = Color3.new(0.309804, 0.32549, 0.560784)
		bg.ImageTransparency = 1
		bg.BackgroundTransparency = 0
		script.Parent.Parent.Parent.Parent.gry.overlay.BackgroundTransparency = 1
		wait(.1)
		local save = savefile.checkForSave()
		local me = savefile.pullFromSaveData("me", false)
		local txtbox = savefile.pullFromSaveData("options.txtbx", 1)
		local box = engine.dialogueBox("font3_dark", "T\nh\ne\n \ni\nn\nt\ne\nr\nn\na\nl\n \nb\na\nt\nt\ne\nr\ny\n \nh\na\ns\n \nr\nu\nn\n \nd\nr\ny\n.\nnw\nT\nh\ne\n \ng\na\nm\ne\n \nc\na\nn\n \nb\ne\n \np\nl\na\ny\ne\nd\n.", false, false, txtbox, function(txt, bx)
			txt:Destroy()
			bx:Destroy()
			local newbox = engine.dialogueBox("font3_dark", "H\no\nw\ne\nv\ne\nr\ncomma\n \nc\nl\no\nc\nk\n-\nb\na\ns\ne\nd\n \ne\nv\ne\nn\nt\ns\n \nw\ni\nl\nl\nnw\nn\no\n \nl\no\nn\ng\ne\nr\n \no\nc\nc\nu\nr\n.", true, false, txtbox, function(txt, bx)
				txt:Destroy()
				bx:Destroy()
				local folder = Instance.new("Folder")
				folder.Name = "btns"
				folder.Parent = script.Parent.Parent.Parent.Parent.gry.loadedassets
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
					if save then
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
				local selFuncTable = {
					["1"] = function()-- continue --

					end,
					["2"] = function() -- newgame --
						inputs.wipeAllFuncs()
						script.Parent.Parent.Parent.Parent.gry.overlay.BackgroundTransparency = 1
						script.Parent.Parent.Parent.Parent.gry.overlay.BackgroundColor3 = Color3.new(0, 0, 0)
						rendering.genericOpacityTween(script.Parent.Parent.Parent.Parent.gry.overlay, 0, 10, function()
							rendering.clearGraphics()
						end)
					end,
					["3"] = function() -- options --
						inputs.wipeAllFuncs()
						script.Parent.Parent.Parent.Parent.gry.overlay.BackgroundTransparency = 1
						script.Parent.Parent.Parent.Parent.gry.overlay.BackgroundColor3 = Color3.new(0, 0, 0)
						rendering.genericOpacityTween(script.Parent.Parent.Parent.Parent.gry.overlay, 0, 10, function()
							rendering.clearGraphics()
							local bg = rendering.renderImg(pbu.."/assets/titlescreen/brightwhitelight.png", 0 ,0, maxX, maxY, Vector2.new(0 ,0))
							bg.BackgroundColor3 = Color3.new(0.309804, 0.32549, 0.560784)
							bg.ImageTransparency = 1
							bg.BackgroundTransparency = 0
							wait(0.25)
							rendering.genericOpacityTween(script.Parent.Parent.Parent.Parent.gry.overlay, 1, 10, function()
								--inputs.assignKeyToFunc(ctrls.scheme1.cancel, "exit", doTHEWORK, true)
							end)
						end)
					end,
					["4"] = function() -- mystery event --

					end,
				}
				local selected = 2
				if save then selected = 1 end
				renderNew(selected)
				--drawScrollingText("font3_dark", "R\ne\na\nl\n \nt\ne\ns\nt\ni\nn\ng\n \nt\ne\nx\nt", 0, 0, Color3.new(1, 1, 1))
				local min = 2
				local max = 3
				if save then min = 1 end
				if me then max = 4 end
				inputs.assignKeyToFunc(ctrls.scheme1.up, "menu", function()
					selected -= 1
					if selected == min-1 then selected = max end
					renderNew(selected)
				end, false)
				inputs.assignKeyToFunc(ctrls.scheme1.down, "menu", function()
					selected += 1
					if selected == max+1 then selected = min end
					renderNew(selected)
				end, false)
				inputs.assignKeyToFunc(ctrls.scheme1.interact, "menu", function()
					rendering.playSFX("sel.wav")
					selFuncTable[selected..""]()
				end, false)
				inputs.assignKeyToFunc(ctrls.scheme1.cancel, "menu", function()
					inputs.wipeAllFuncs()
					rendering.playSFX("sel.wav")
					script.Parent.Parent.Parent.Parent.gry.overlay.BackgroundTransparency = 0
					script.Parent.Parent.Parent.Parent.gry.overlay.BackgroundColor3 = Color3.new(0.309804, 0.32549, 0.560784)
					rendering.genericColorTween(script.Parent.Parent.Parent.Parent.gry.overlay, Color3.new(1, 1, 1), 5)
					wait(0.2)
					rendering.clearGraphics()
					scenes.openscene("PreGame.Titlescreen")
				end, true)
			end)
		end)
	end)
end

return menuscreen
