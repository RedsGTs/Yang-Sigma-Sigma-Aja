local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local webhookUrl = "https://discord.com/api/webhooks/1111606979585130537/0joXFyaI312c33vvQLZ0-7M7dCOJJjIeRYQVxB2qyMg79N0ZSZokugMrbI9G9WhoOnHl" -- Replace with your actual webhook
local sendWebhook = ReplicatedStorage:WaitForChild("SendWebhook")

sendWebhook.OnServerEvent:Connect(function(player)
    local data = {
        ["content"] = "**" .. player.Name .. "** just executed the script in game."
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
        warn("Failed to send webhook:", response)
    end
end)