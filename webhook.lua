local HttpService = game:GetService("HttpService")

local url = "https://discord.com/api/webhooks/1111606979585130537/0joXFyaI312c33vvQLZ0-7M7dCOJJjIeRYQVxB2qyMg79N0ZSZokugMrbI9G9WhoOnHl"

local data = {
    content = "Player " .. game.Players.LocalPlayer.Name .. " executed a script using Delta!"
}

local success, err = pcall(function()
    http_request({
        Url = url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode(data)
    })
end)

if success then
    print("Webhook sent.")
else
    warn("Failed to send webhook:", err)
end
