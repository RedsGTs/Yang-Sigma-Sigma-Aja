-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local placeId = game.PlaceId

-- Server Start Time Setup
if not ReplicatedStorage:FindFirstChild("ServerStartTime") then
    local serverStartTime = Instance.new("NumberValue")
    serverStartTime.Name = "ServerStartTime"
    serverStartTime.Value = os.time()
    serverStartTime.Parent = ReplicatedStorage
end

-- Cleanup existing GUI
if game.CoreGui:FindFirstChild("JobIDHub") then
    game.CoreGui.JobIDHub:Destroy()
end

-- Create GUI
local gui = Instance.new("ScreenGui")
guim.Name = "JobIDHub"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- Toggle Gear Icon
local toggleIcon = Instance.new("ImageButton")
toggleIcon.Size = UDim2.new(0, 50, 0, 50)
toggleIcon.Position = UDim2.new(0, 10, 0.4, 0)
toggleIcon.Image = "rbxassetid://6031091002"
toggleIcon.BackgroundColor3 = Color3.fromRGB(20, 40, 40)
toggleIcon.ImageColor3 = Color3.new(1, 1, 1)
toggleIcon.BorderSizePixel = 0
toggleIcon.AutoButtonColor = false
toggleIcon.Name = "ToggleIcon"
toggleIcon.Parent = gui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = toggleIcon

-- Main Frame (Styled like Lego brick UI)
local mainFrame = Instance.new("Frame")
mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
mainFrame.Size = UDim2.new(0, 340, 0, 260)
mainFrame.BackgroundColor3 = Color3.fromRGB(105, 60, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Parent = gui
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(150, 80, 40)
title.Text = "Settings"
title.Font = Enum.Font.FredokaOne
title.TextSize = 28
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = mainFrame
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

-- Server Uptime
local uptimeLabel = Instance.new("TextLabel")
uptimeLabel.Size = UDim2.new(1, -20, 0, 30)
uptimeLabel.Position = UDim2.new(0, 10, 0, 50)
uptimeLabel.BackgroundTransparency = 1
uptimeLabel.TextColor3 = Color3.new(1, 1, 1)
uptimeLabel.Font = Enum.Font.SourceSansBold
uptimeLabel.TextSize = 16
uptimeLabel.TextXAlignment = Enum.TextXAlignment.Left
uptimeLabel.Text = "Server Uptime: --:--"
uptimeLabel.Parent = mainFrame

-- Job ID Display
local jobIdLabel = Instance.new("TextLabel")
jobIdLabel.Size = UDim2.new(1, -20, 0, 30)
jobIdLabel.Position = UDim2.new(0, 10, 0, 85)
jobIdLabel.BackgroundTransparency = 1
jobIdLabel.TextColor3 = Color3.new(1, 1, 1)
jobIdLabel.Font = Enum.Font.SourceSansBold
jobIdLabel.TextSize = 16
jobIdLabel.Text = "Job ID: " .. (game.JobId ~= "" and game.JobId or "Unavailable")
jobIdLabel.Parent = mainFrame

-- Job ID Input
local jobIdInput = Instance.new("TextBox")
jobIdInput.Size = UDim2.new(1, -20, 0, 30)
jobIdInput.Position = UDim2.new(0, 10, 0, 120)
jobIdInput.PlaceholderText = "Enter Job ID..."
jobIdInput.Font = Enum.Font.SourceSans
jobIdInput.TextSize = 16
jobIdInput.TextColor3 = Color3.new(1, 1, 1)
jobIdInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
jobIdInput.Parent = mainFrame

-- Teleport Button
local teleportBtn = Instance.new("TextButton")
teleportBtn.Size = UDim2.new(1, -20, 0, 30)
teleportBtn.Position = UDim2.new(0, 10, 0, 160)
teleportBtn.Text = "Join Server by Job ID"
teleportBtn.Font = Enum.Font.SourceSansBold
teleportBtn.TextSize = 16
teleportBtn.TextColor3 = Color3.new(1, 1, 1)
teleportBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
teleportBtn.Parent = mainFrame

-- Copy Button
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.5, -15, 0, 30)
copyBtn.Position = UDim2.new(0, 10, 0, 200)
copyBtn.Text = "Copy My Job ID"
copyBtn.Font = Enum.Font.SourceSansBold
copyBtn.TextSize = 16
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
copyBtn.Parent = mainFrame

-- Random Button
local randomBtn = Instance.new("TextButton")
randomBtn.Size = UDim2.new(0.5, -15, 0, 30)
randomBtn.Position = UDim2.new(0.5, 5, 0, 200)
randomBtn.Text = "Join Random Server"
randomBtn.Font = Enum.Font.SourceSansBold
randomBtn.TextSize = 16
randomBtn.TextColor3 = Color3.new(1, 1, 1)
randomBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 60)
randomBtn.Parent = mainFrame

-- Toggle Function
local shown = true
toggleIcon.MouseButton1Click:Connect(function()
    shown = not shown
    mainFrame.Visible = shown
end)

-- Uptime Updater
local startValue = ReplicatedStorage:WaitForChild("ServerStartTime")
task.spawn(function()
    while true do
        local now = os.time()
        local seconds = now - startValue.Value
        local mins = math.floor(seconds / 60)
        local secs = seconds % 60
        uptimeLabel.Text = string.format("Server Uptime: %02d:%02d", mins, secs)
        task.wait(1)
    end
end)

-- Button Actions
copyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(game.JobId)
    end
end)

teleportBtn.MouseButton1Click:Connect(function()
    local inputJob = jobIdInput.Text
    if inputJob and inputJob ~= "" then
        TeleportService:TeleportToPlaceInstance(placeId, inputJob, player)
    end
end)

randomBtn.MouseButton1Click:Connect(function()
    local servers = HttpService:JSONDecode(
        game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")
    )
    for _, server in pairs(servers.data) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(placeId, server.id, player)
            break
        end
    end
end)
