local Signal = loadstring(game:HttpGet("https://gist.githubusercontent.com/stravant/b75a322e0919d60dde8a0316d1f09d2f/raw/f6a8900676185457211ec25d22d681c20ee792cb/GoodSignal.lua"))()
local LocalPlayer = game:GetService("Players").LocalPlayer

local PseudoRemote = {}
PseudoRemote.__index = PseudoRemote

PseudoRemote.new = function()
	local Remote = {
		OnServerEvent = Signal.new(),
		OnClientEvent = Signal.new()
	}
	return setmetatable(Remote, PseudoRemote)
end

function PseudoRemote:FireServer(...)
	self.OnServerEvent:Fire(...)
end

function PseudoRemote:FireClient(Player, ...)
	if Player == LocalPlayer then
		self.OnClientEvent:Fire(...)
	end
end

function PseudoRemote:FireAllClients(...)
	self.OnClientEvent:Fire(...)
end

return PseudoRemote
