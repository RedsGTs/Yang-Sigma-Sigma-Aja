local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local webhookUrl = "https://discord.com/api/webhooks/1111606979585130537/0joXFyaI312c33vvQLZ0-7M7dCOJJjIeRYQVxB2qyMg79N0ZSZokugMrbI9G9WhoOnHl"
local sendWebhook = ReplicatedStorage:WaitForChild("SendWebhook")

sendWebhook.OnServerEvent:Connect(function(player)
    local data = {
        ["content"] = "**" .. player.Name .. "** executed the script in the game!"
    }

    local headers = {
        ["Content-Type"] = "application/json"
    }

    local success, response = pcall(function()
        HttpService:PostAsync(
            webhookUrl,
            HttpService:JSONEncode(data),
            Enum.HttpContentType.ApplicationJson
        )
    end)

    if success then
        print("Webhook sent for", player.Name)
    else
        warn("Webhook failed:", response)
    end
end)