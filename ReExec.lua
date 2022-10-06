-- A Roblox module for handling functions and signals

-- Usage :
--   ReExec.new(<string> HandlerName) -- Creates or a handler with the name HandlerName, returns existing handler with the name HandlerName if exists
--   Handler:Add(<RBXScriptConnection, function> Object) -- Adds the object for the Handler to handle
--   Handler.AddIndex = <RBXScriptConnection, function> Object -- Handler:Add but uses the __newindex method
--   Handler:Cleanup(<void>) -- Cleans up all object the current Handler is handling

local ReExec = {}
local Existing = {}
ReExec.__index = ReExec
ReExec.__newindex = newcclosure(function(self, key, value)
	if self ~= ReExec and key == "AddIndex" then	
		self:Add(value)
	end
end)

function ReExec.new(String)
	if Existing[String] then
		return Existing[String]
	end
	local Thing = {
		Connections = {},
		Threads = {}
	}
    Existing[String] = Thing
	return setmetatable(Thing, ReExec)
end

function ReExec:Add(Thing)
	local Type = typeof(Thing)
	if Type == "RBXScriptConnection" then
		table.insert(self.Connections, Thing)
	elseif Type == "function" then
		local Thread
		local Wrapped = coroutine.wrap(newcclosure(function()
			Thread = coroutine.running()
			Thing()
		end))
		task.spawn(Wrapped)
		table.insert(self.Threads, Thread)
	end
end

function ReExec:Cleanup()
	for i,v in pairs(self.Connections) do
		v:Disconnect()
	end
	for i,v in pairs(self.Threads) do
		pcall(task.cancel, v)
	end
end

getgenv().ReExec = ReExec
