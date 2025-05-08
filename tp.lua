-- Create GUI elements
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ServerHopGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.8, 0)
button.Text = "Join Old Server"
button.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
button.TextColor3 = Color3.new(1,1,1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 24
button.Parent = screenGui


local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local PLACE_ID = game.PlaceId
local MIN_PLAYERS = 1

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

script.Parent.MouseButton1Click:Connect(function()
	script.Parent.Text = "Searching..."
	script.Parent.AutoButtonColor = false

	local serverId = findServer()
	if serverId then
		script.Parent.Text = "Joining..."
		TeleportService:TeleportToPlaceInstance(PLACE_ID, serverId, Players.LocalPlayer)
	else
		script.Parent.Text = "No Server Found"
		wait(2)
		script.Parent.Text = "Join Old Server"
		script.Parent.AutoButtonColor = true
	end
end)