
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local placeId = game.PlaceId

-- === CLEANUP EXISTING GUI ===
if CoreGui:FindFirstChild("JobIDHub") then
    CoreGui.JobIDHub:Destroy()
end

-- === GUI SETUP ===
local gui = Instance.new("ScreenGui", CoreGui)
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
mainFrame.Size = UDim2.new(0, 320, 0, 270)
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

-- Server Version Label
local versionLabel = Instance.new("TextLabel", mainFrame)
versionLabel.Size = UDim2.new(1, -20, 0, 30)
versionLabel.Position = UDim2.new(0, 10, 0, 40)
versionLabel.BackgroundTransparency = 1
versionLabel.TextColor3 = Color3.new(1, 1, 1)
versionLabel.Font = Enum.Font.SourceSansBold
versionLabel.TextSize = 16
versionLabel.Text = "Server Version: Loading..."

-- Job ID Label
local jobIdLabel = Instance.new("TextLabel", mainFrame)
jobIdLabel.Size = UDim2.new(1, -20, 0, 30)
jobIdLabel.Position = UDim2.new(0, 10, 0, 75)
jobIdLabel.TextColor3 = Color3.new(1, 1, 1)
jobIdLabel.BackgroundTransparency = 1
jobIdLabel.Font = Enum.Font.SourceSansBold
jobIdLabel.TextSize = 16
jobIdLabel.Text = "Job ID: " .. (game.JobId ~= "" and game.JobId or "Unavailable")

-- Input box for Job ID
local jobIdInput = Instance.new("TextBox", mainFrame)
jobIdInput.Size = UDim2.new(1, -20, 0, 30)
jobIdInput.Position = UDim2.new(0, 10, 0, 110)
jobIdInput.PlaceholderText = "Enter Job ID..."
jobIdInput.Font = Enum.Font.SourceSans
jobIdInput.TextSize = 16
jobIdInput.TextColor3 = Color3.new(1, 1, 1)
jobIdInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Teleport Button
local teleportBtn = Instance.new("TextButton", mainFrame)
teleportBtn.Size = UDim2.new(1, -20, 0, 30)
teleportBtn.Position = UDim2.new(0, 10, 0, 150)
teleportBtn.Text = "Join Server by Job ID"
teleportBtn.Font = Enum.Font.SourceSansBold
teleportBtn.TextSize = 16
teleportBtn.TextColor3 = Color3.new(1, 1, 1)
teleportBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 60)

-- Copy Job ID Button
local copyBtn = Instance.new("TextButton", mainFrame)
copyBtn.Size = UDim2.new(0.5, -15, 0, 30)
copyBtn.Position = UDim2.new(0, 10, 0, 190)
copyBtn.Text = "Copy My Job ID"
copyBtn.Font = Enum.Font.SourceSansBold
copyBtn.TextSize = 16
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)

-- Join Random Server Button
local randomBtn = Instance.new("TextButton", mainFrame)
randomBtn.Size = UDim2.new(0.5, -15, 0, 30)
randomBtn.Position = UDim2.new(0.5, 5, 0, 190)
randomBtn.Text = "Join Random Server"
randomBtn.Font = Enum.Font.SourceSansBold
randomBtn.TextSize = 16
randomBtn.TextColor3 = Color3.new(1, 1, 1)
randomBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 60)

-- Auto Hop Toggle
local autoHopToggle = Instance.new("TextButton", mainFrame)
autoHopToggle.Size = UDim2.new(1, -20, 0, 30)
autoHopToggle.Position = UDim2.new(0, 10, 0, 230)
autoHopToggle.Text = "Auto Hop: OFF"
autoHopToggle.Font = Enum.Font.SourceSansBold
autoHopToggle.TextSize = 16
autoHopToggle.TextColor3 = Color3.new(1, 1, 1)
autoHopToggle.BackgroundColor3 = Color3.fromRGB(80, 40, 40)

-- Delay input
local delayInput = Instance.new("TextBox", mainFrame)
delayInput.Size = UDim2.new(1, -20, 0, 30)
delayInput.Position = UDim2.new(0, 10, 0, 270)
delayInput.PlaceholderText = "Delay Hop (seconds)"
delayInput.Font = Enum.Font.SourceSans
delayInput.TextSize = 16
delayInput.TextColor3 = Color3.new(1, 1, 1)
delayInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
delayInput.Text = "10"

-- Variables
local autoHopEnabled = false
local autoHopDelay = 10

-- Save/load config (using saved Roblox settings)
local HttpService = HttpService
local configKey = "JobIDHubConfig"

local function saveConfig()
    local config = {
        autoHopEnabled = autoHopEnabled,
        autoHopDelay = autoHopDelay
    }
    pcall(function()
        writefile(configKey, HttpService:JSONEncode(config))
    end)
end

local function loadConfig()
    if isfile(configKey) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(configKey))
        end)
        if success and data then
            autoHopEnabled = data.autoHopEnabled
            autoHopDelay = data.autoHopDelay
            delayInput.Text = tostring(autoHopDelay)
            autoHopToggle.Text = "Auto Hop: " .. (autoHopEnabled and "ON" or "OFF")
        end
    end
end

loadConfig()

-- Button connections
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