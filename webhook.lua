-- Roblox script to send the player's username to a Discord webhook
-- Place this Script inside ServerScriptService
-- Replace WEBHOOK_URL with your Discord webhook URL

local HttpService = game:GetService("HttpService")

local WEBHOOK_URL = "https://discord.com/api/webhooks/1111606979585130537/0joXFyaI312c33vvQLZ0-7M7dCOJJjIeRYQVxB2qyMg79N0ZSZokugMrbI9G9WhoOnHl" -- CHANGE THIS to your webhook URL

local function sendUsernameToWebhook(player)
    local username = player.Name
    local data = {
        ["content"] = "Player executed the script: **" .. username .. "**"
    }
    
    local jsonData = HttpService:JSONEncode(data)
    
    local success, response = pcall(function()
        return HttpService:PostAsync(WEBHOOK_URL, jsonData, Enum.HttpContentType.ApplicationJson)
    end)
    
    if success then
        print("Successfully sent username to webhook for player:", username)
    else
        warn("Failed to send username to webhook:", response)
    end
end

-- Connect to PlayerAdded event or run for existing players
game.Players.PlayerAdded:Connect(function(player)
    -- Send username to webhook when player joins (or you can trigger manually)
    sendUsernameToWebhook(player)
end)

-- For existing players if script runs after players joined
for _, player in pairs(game.Players:GetPlayers()) do
    sendUsernameToWebhook(player)
end
