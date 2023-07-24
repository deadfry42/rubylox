local sgui = game:GetService("StarterGui")
sgui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

local resetBindable = Instance.new("BindableEvent")
resetBindable.Event:connect(function()
	local plr = game.Players.LocalPlayer
	local pgui = plr.PlayerGui
	pgui.gameplay:Destroy()
	local newgp = game.StarterGui.gameplay:Clone()
	newgp.Parent = pgui
end)

while wait() do
	local s, e = pcall(function()
		sgui:SetCore("ResetButtonCallback", resetBindable)
	end)
	if s then
		break
	end
end
