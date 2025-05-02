HttpService = game:GetService("HttpService")
Webhook_URL = "https://discord.com/api/webhooks/1111606979585130537/0joXFyaI312c33vvQLZ0-7M7dCOJJjIeRYQVxB2qyMg79N0ZSZokugMrbI9G9WhoOnHl"

local responce=syn request(
{
    Url = Webhook_URL,
    Method = 'POST',
    Headers = {
        ['Content-Type'] = 'application/json'
    },
    Body = HttpService:JSONEncode({
        ["content"] = "",
        ["embeds"] = ({
            ["title"] = "**Ambanutt**",
            ["description"] = game.Players.LocalPlayer.DisplayName.."has executed the script.",
            ["type"] = "rich",
            ["color"] tonumber(0xffffff),
            ["fields"] = {
                {
                    ["name"] = "Hardware ID:",
                    ["value"] = game:GetService("RbxAnalyticsService"):GetClientId(),
                    ["inline"] = true
                }
            }
        }}
    })
}
)