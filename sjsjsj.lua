local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local placeId = game.PlaceId

-- CONFIG SYSTEM
local ConfigKey = "JobIDHub_Config"
local configDefaults = {
    AutoHop = true,
    PreferOldServers = true,
    ShowPrompts = true
}
local function loadConfig()
    local data
    pcall(function()
        data = HttpService:JSONDecode(getgenv()[ConfigKey] or "")
    end)
    if typeof(data) == "table" then
        for k, v in pairs(configDefaults) do
            if data[k] == nil then data[k] = v end
        end
        return data
    else
        return configDefaults
    end
end
local function saveConfig(cfg)
    local json = HttpService:JSONEncode(cfg)
    getgenv()[ConfigKey] = json
end
local config = loadConfig()

-- === GUI CLEANUP ===
if game.CoreGui:FindFirstChild("JobIDHub") then
    game.CoreGui.JobIDHub:Destroy()
end

-- === GUI SETUP ===
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "JobIDHub"
gui.ResetOnSpawn = false

local toggleIcon = Instance.new("ImageButton", gui)
toggleIcon.Size = UDim2.new(0, 40, 0, 40)
toggleIcon.Position = UDim2.new(0, 10, 0.4, 0)
toggleIcon.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleIcon.BackgroundTransparency = 0.2
toggleIcon.Image = "rbxassetid://6031091002"
toggleIcon.Name = "ToggleIcon"
toggleIcon.Active = true
toggleIcon.Draggable = true

local mainFrame = Instance.new("Frame", gui)
mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
mainFrame.Size = UDim2.new(0, 320, 0, 360)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BackgroundTransparency = 0.5
mainFrame.BorderSizePixel = 0
mainFrame.Name = "MainFrame"
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true

local jobIdLabel = Instance.new("TextLabel", mainFrame)
jobIdLabel.Size = UDim2.new(1, -20, 0, 40)
jobIdLabel.Position = UDim2.new(0, 10, 0, 10)
jobIdLabel.TextColor3 = Color3.new(1, 1, 1)
jobIdLabel.BackgroundTransparency = 1
jobIdLabel.Font = Enum.Font.SourceSansBold
jobIdLabel.TextSize = 16
jobIdLabel.Text = "Job ID: " .. (game.JobId ~= "" and game.JobId or "Unavailable")

local versionLabel = Instance.new("TextLabel", mainFrame)
versionLabel.Size = UDim2.new(1, -20, 0, 20)
versionLabel.Position = UDim2.new(0, 10, 0, 40)
versionLabel.TextColor3 = Color3.new(1, 1, 1)
versionLabel.BackgroundTransparency = 1
versionLabel.Font = Enum.Font.SourceSans
versionLabel.TextSize = 14
versionLabel.Text = "Version: " .. tostring(game.PlaceVersion)

local jobIdInput = Instance.new("TextBox", mainFrame)
jobIdInput.Size = UDim2.new(1, -20, 0, 30)
jobIdInput.Position = UDim2.new(0, 10, 0, 70)
jobIdInput.PlaceholderText = "Enter Job ID..."
jobIdInput.Font = Enum.Font.SourceSans
jobIdInput.TextSize = 16
jobIdInput.TextColor3 = Color3.new(1, 1, 1)
jobIdInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local teleportBtn = Instance.new("TextButton", mainFrame)
teleportBtn.Size = UDim2.new(1, -20, 0, 30)
teleportBtn.Position = UDim2.new(0, 10, 0, 110)
teleportBtn.Text = "Join Server by Job ID"
teleportBtn.Font = Enum.Font.SourceSansBold
teleportBtn.TextSize = 16
teleportBtn.TextColor3 = Color3.new(1, 1, 1)
teleportBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 60)

local copyBtn = Instance.new("TextButton", mainFrame)
copyBtn.Size = UDim2.new(0.5, -15, 0, 30)
copyBtn.Position = UDim2.new(0, 10, 0, 150)
copyBtn.Text = "Copy My Job ID"
copyBtn.Font = Enum.Font.SourceSansBold
copyBtn.TextSize = 16
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)

local randomBtn = Instance.new("TextButton", mainFrame)
randomBtn.Size = UDim2.new(0.5, -15, 0, 30)
randomBtn.Position = UDim2.new(0.5, 5, 0, 150)
randomBtn.Text = "Join Random Server"
randomBtn.Font = Enum.Font.SourceSansBold
randomBtn.TextSize = 16
randomBtn.TextColor3 = Color3.new(1, 1, 1)
randomBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 60)

local function notify(text)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "JobID Hub",
            Text = text,
            Duration = 4
        })
    end)
end

copyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(game.JobId)
        notify("Copied Job ID")
    end
end)

teleportBtn.MouseButton1Click:Connect(function()
    local inputJob = jobIdInput.Text
    if inputJob and inputJob ~= "" then
        TeleportService:TeleportToPlaceInstance(placeId, inputJob, player)
    end
end)

-- Blood Moon Check
local function checkBloodMoon()
    local shrine = workspace:FindFirstChild("Interaction") and workspace.Interaction:FindFirstChild("UpdateItems") and workspace.Interaction.UpdateItems:FindFirstChild("BloodMoonShrine")
    if shrine and shrine:IsA("Model") then
        local part = shrine.PrimaryPart or shrine:FindFirstChildWhichIsA("BasePart")
        if part then
            return (part.Position - Vector3.new(-83.157, 0.3, -11.295)).Magnitude < 0.1
        end
    end
    return false
end

-- Server Hop Logic
local function hopToOldServer()
    local servers = HttpService:JSONDecode(
        game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true")
    )
    for _, server in ipairs(servers.data) do
        if server.id ~= game.JobId and server.playing < server.maxPlayers then
            if config.PreferOldServers and server.placeVersion and server.placeVersion <= game.PlaceVersion then
                TeleportService:TeleportToPlaceInstance(placeId, server.id, player)
                return
            elseif not config.PreferOldServers then
                TeleportService:TeleportToPlaceInstance(placeId, server.id, player)
                return
            end
        end
    end
    notify("No suitable servers found.")
end

randomBtn.MouseButton1Click:Connect(function()
    hopToOldServer()
end)

-- Auto Hop Logic
task.defer(function()
    if config.AutoHop then
        task.wait(3)
        if config.PreferOldServers and game.PlaceVersion > 1233 then
            notify("New Server Detected. Hopping...")
            hopToOldServer()
        elseif not checkBloodMoon() and config.ShowPrompts then
            notify("No Blood Moon. Hopping...")
            hopToOldServer()
        end
    end
end)

-- Create Toggles
local function createToggle(parent, label, key, yOffset)
    local toggle = Instance.new("TextButton", parent)
    toggle.Size = UDim2.new(1, -20, 0, 25)
    toggle.Position = UDim2.new(0, 10, 0, yOffset)
    toggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.Font = Enum.Font.SourceSansBold
    toggle.TextSize = 14
    toggle.Text = label .. ": " .. (config[key] and "ON" or "OFF")
    toggle.MouseButton1Click:Connect(function()
        config[key] = not config[key]
        toggle.Text = label .. ": " .. (config[key] and "ON" or "OFF")
        saveConfig(config)
    end)
end

createToggle(mainFrame, "Auto Hop", "AutoHop", 190)
createToggle(mainFrame, "Prefer Old Servers", "PreferOldServers", 220)
createToggle(mainFrame, "Show Prompts", "ShowPrompts", 250)

-- Toggle Main Panel
local shown = true
toggleIcon.MouseButton1Click:Connect(function()
    shown = not shown
    mainFrame.Visible = shown
end)