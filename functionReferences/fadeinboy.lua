return function(loc)
	local proftalk = require(loc.Parent.Parent.Scenes.PreGame.ProfTalk)
	local assets = proftalk.retrieveAssets()
	local tlp = assets[1]
	local blp = assets[2]
	local trp = assets[3]
	local brp = assets[4]
	local bir = assets[5]
	local azur = assets[6]
	tlp:Destroy()
	blp:Destroy()
	trp:Destroy()
	brp:Destroy()
	bir:Destroy()
	azur:Destroy()
end
