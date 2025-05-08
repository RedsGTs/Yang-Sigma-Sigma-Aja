local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local PLACE_ID = 126884695634066 -- replace with the actual place ID
local MAX_SERVERS = 100
local MIN_PLAYERS = 1 -- filter: servers with at least one player

local function getServers(cursor)
	local url = "https://games.roblox.com/v1/games/" .. PLACE_ID .. "/servers/Public?limit=100"
	if cursor then
		url = url .. "&cursor=" .. cursor
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(game:HttpGet(url))
	end)

	if success and result then
		return result
	end
	return nil
end

local function findServer()
	local cursor = nil
	repeat
		local data = getServers(cursor)
		if not data then break end

		for _, server in pairs(data.data) do
			if server.playing >= MIN_PLAYERS and server.id ~= game.JobId then
				return server.id
			end
		end
		cursor = data.nextPageCursor
	until not cursor

	return nil
end

local serverId = findServer()
if serverId then
	TeleportService:TeleportToPlaceInstance(PLACE_ID, serverId, game.Players.LocalPlayer)
else
	warn("No suitable server found.")
end