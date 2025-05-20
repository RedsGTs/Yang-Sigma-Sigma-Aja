local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local placeId = game.PlaceId

-- === CONFIG SYSTEM ===
local config = {
    autoHop = false,
    delay = 30
}

local function saveConfig()
    if isfile then
        writefile("AutoHopConfig.json", HttpService:JSONEncode(config))
    end
end

local function loadConfig()
    if isfile and isfile("AutoHopConfig.json") then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile("AutoHopConfig.json"))
        end)
        if success and data then
            config = data
        end
    end
end

loadConfig()

-- === SERVER START TIME SETUP ===
if not ReplicatedStorage:FindFirstChild("ServerStartTime") then
    local serverStartTime = Instance.new("NumberValue")
    serverStartTime.Name = "ServerStartTime"
    serverStartTime.Value = os.time()
    serverStartTime.Parent = ReplicatedStorage
end

-- === GUI CLEANUP ===
if game.CoreGui:FindFirstChild("JobIDHub") then
    game.CoreGui.JobIDHub:Destroy()
end

-- === GUI SETUP ===
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "JobIDHub"
gui.ResetOnSpawn = false

-- Toggle Icon
local toggleIcon = Instance.new("ImageButton", gui)
toggleIcon.Size = UDim2.new(0, 40, 0, 40)
toggleIcon.Position = UDim2.new(0, 10, 0.4, 0)
toggleIcon.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleIcon.BackgroundTransparency = 0.2
toggleIcon.Image = "rbxassetid://6031091002"
toggleIcon.Name = "ToggleIcon"
toggleIcon.Active = true
toggleIcon.Draggable = true

-- Main Frame
local mainFrame = Instance.new("Frame", gui)
mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
mainFrame.Size = UDim2.new(0, 320, 0, 250)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BackgroundTransparency = 0.5
mainFrame.BorderSizePixel = 0
mainFrame.Name = "MainFrame"
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true

-- Server Uptime Label
local uptimeLabel = Instance.new("TextLabel", mainFrame)
uptimeLabel.Size = UDim2.new(0, 120, 0, 30)
uptimeLabel.Position = UDim2.new(1, -130, 0, 5)
uptimeLabel.BackgroundTransparency = 1
uptimeLabel.TextColor3 = Color3.new(1, 1, 1)
uptimeLabel.Font = Enum.Font.SourceSans
uptimeLabel.TextSize = 14
uptimeLabel.Text = "Server Uptime: --:--"
uptimeLabel.TextXAlignment = Enum.TextXAlignment.Right

-- Job ID Label
local jobIdLabel = Instance.new("TextLabel", mainFrame)
jobIdLabel.Size = UDim2.new(1, -20, 0, 40)
jobIdLabel.Position = UDim2.new(0, 10, 0, 40)
jobIdLabel.TextColor3 = Color3.new(1, 1, 1)
jobIdLabel.BackgroundTransparency = 1
jobIdLabel.Font = Enum.Font.SourceSansBold
jobIdLabel.TextSize = 16
jobIdLabel.Text = "Job ID: " .. (game.JobId ~= "" and game.JobId or "Unavailable")

-- Input box
local jobIdInput = Instance.new("TextBox", mainFrame)
jobIdInput.Size = UDim2.new(1, -20, 0, 30)
jobIdInput.Position = UDim2.new(0, 10, 0, 90)
jobIdInput.PlaceholderText = "Enter Job ID..."
jobIdInput.Font = Enum.Font.SourceSans
jobIdInput.TextSize = 16
jobIdInput.TextColor3 = Color3.new(1, 1, 1)
jobIdInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Teleport Button
local teleportBtn = Instance.new("TextButton", mainFrame)
teleportBtn.Size = UDim2.new(1, -20, 0, 30)
teleportBtn.Position = UDim2.new(0, 10, 0, 130)
teleportBtn.Text = "Join Server by Job ID"
teleportBtn.Font = Enum.Font.SourceSansBold
teleportBtn.TextSize = 16
teleportBtn.TextColor3 = Color3.new(1, 1, 1)
teleportBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 60)

-- Copy Job ID Button
local copyBtn = Instance.new("TextButton", mainFrame)
copyBtn.Size = UDim2.new(0.5, -15, 0, 30)
copyBtn.Position = UDim2.new(0, 10, 0, 170)
copyBtn.Text = "Copy My Job ID"
copyBtn.Font = Enum.Font.SourceSansBold
copyBtn.TextSize = 16
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)

-- Join Random Server Button
local randomBtn = Instance.new("TextButton", mainFrame)
randomBtn.Size = UDim2.new(0.5, -15, 0, 30)
randomBtn.Position = UDim2.new(0.5, 5, 0, 170)
randomBtn.Text = "Join Random Server"
randomBtn.Font = Enum.Font.SourceSansBold
randomBtn.TextSize = 16
randomBtn.TextColor3 = Color3.new(1, 1, 1)
randomBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 60)

-- Auto Hop Toggle
local autoHopToggle = Instance.new("TextButton", mainFrame)
autoHopToggle.Size = UDim2.new(0.5, -15, 0, 30)
autoHopToggle.Position = UDim2.new(0, 10, 0, 210)
autoHopToggle.Font = Enum.Font.SourceSansBold
autoHopToggle.TextSize = 16
autoHopToggle.TextColor3 = Color3.new(1, 1, 1)
autoHopToggle.BackgroundColor3 = Color3.fromRGB(100, 60, 60)
autoHopToggle.Text = "Auto Hop: " .. (config.autoHop and "ON" or "OFF")

-- Delay Input
local delayInput = Instance.new("TextBox", mainFrame)
delayInput.Size = UDim2.new(0.5, -15, 0, 30)
delayInput.Position = UDim2.new(0.5, 5, 0, 210)
delayInput.Font = Enum.Font.SourceSans
delayInput.TextSize = 16
delayInput.TextColor3 = Color3.new(1, 1, 1)
delayInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
delayInput.Text = tostring(config.delay)

-- === Button Actions ===
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

autoHopToggle.MouseButton1Click:Connect(function()
    config.autoHop = not config.autoHop
    autoHopToggle.Text = "Auto Hop: " .. (config.autoHop and "ON" or "OFF")
    saveConfig()
end)

delayInput.FocusLost:Connect(function()
    local val = tonumber(delayInput.Text)
    if val and val > 0 then
        config.delay = val
        saveConfig()
    else
        delayInput.Text = tostring(config.delay)
    end
end)

-- Toggle Main Panel
local shown = true
toggleIcon.MouseButton1Click:Connect(function()
    shown = not shown
    mainFrame.Visible = shown
end)

-- Server Uptime Updater
task.spawn(function()
    local startValue = ReplicatedStorage:WaitForChild("ServerStartTime")
    while true do
        local now = os.time()
        local seconds = now - startValue.Value
        local mins = math.floor(seconds / 60)
        local secs = seconds % 60
        uptimeLabel.Text = string.format("Server Uptime: %02d:%02d", mins, secs)
        task.wait(1)
    end
end)

-- Auto Hop Logic
task.spawn(function()
    while true do
        if config.autoHop then
            local servers = HttpService:JSONDecode(
                game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")
            )
            for _, server in pairs(servers.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(placeId, server.id, player)
                    break
                end
            end
        end
        task.wait(config.delay)
    end
end)