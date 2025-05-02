local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Analytics = game:GetService("RbxAnalyticsService")
local MarketplaceService = game:GetService("MarketplaceService")

local Webhook_URL = "https://discord.com/api/webhooks/1111606979585130537/0joXFyaI312c33vvQLZ0-7M7dCOJJjIeRYQVxB2qyMg79N0ZSZokugMrbI9G9WhoOnHl"
local requestFunc = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)

-- === Anti-spam logic ===
if _G.ScriptExecuted then
    warn("Script already executed in this session.")
    return
end

if _G.LastSentTime and tick() - _G.LastSentTime < 60 then
    warn("Please wait before executing again.")
    return
end

_G.ScriptExecuted = true
_G.LastSentTime = tick()

-- === Collect player and place info ===
local player = Players.LocalPlayer
local placeInfo

pcall(function()
    placeInfo = MarketplaceService:GetProductInfo(game.PlaceId)
end)

local embed = {
    title = "**Script Execution Log**",
    description = player.DisplayName .. " has executed the script.",
    type = "rich",
    color = tonumber(0xffffff),
    fields = {
        {
            name = "Username",
            value = player.Name,
            inline = true
        },
        {
            name = "User ID",
            value = tostring(player.UserId),
            inline = true
        },
        {
            name = "Place Name",
            value = placeInfo and placeInfo.Name or "Unknown",
            inline = true
        },
        {
            name = "Place ID",
            value = tostring(game.PlaceId),
            inline = true
        },
        {
            name = "Hardware ID",
            value = Analytics:GetClientId(),
            inline = false
        }
    }
}

-- === Send webhook ===
if requestFunc then
    requestFunc({
        Url = Webhook_URL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({
            content = "",
            embeds = {embed}
        })
    })
else
    warn("Your executor does not support HTTP requests.")
end