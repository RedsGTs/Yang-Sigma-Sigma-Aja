-- [PREVIOUS SETUP UNCHANGED ABOVE THIS LINE]

-- === GUI SETUP ===
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "JobIDHub"
gui.ResetOnSpawn = false

-- Toggle Icon (gear style)
local toggleIcon = Instance.new("ImageButton", gui)
toggleIcon.Size = UDim2.new(0, 50, 0, 50)
toggleIcon.Position = UDim2.new(0, 15, 0.4, 0)
toggleIcon.BackgroundTransparency = 1
toggleIcon.Image = "rbxassetid://6031094678" -- Gear icon closer to yours
toggleIcon.Name = "ToggleIcon"
toggleIcon.Active = true
toggleIcon.Draggable = true

-- Main Frame
local mainFrame = Instance.new("Frame", gui)
mainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
mainFrame.Size = UDim2.new(0, 360, 0, 270)
mainFrame.BackgroundColor3 = Color3.fromRGB(121, 63, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Name = "MainFrame"
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true

-- Title Label
local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Settings"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.Cartoon
titleLabel.TextSize = 28
titleLabel.TextStrokeTransparency = 0.7

-- Uptime Label Section
local uptimeLabel = Instance.new("TextLabel", mainFrame)
uptimeLabel.Size = UDim2.new(1, -20, 0, 20)
uptimeLabel.Position = UDim2.new(0, 10, 0, 50)
uptimeLabel.BackgroundTransparency = 1
uptimeLabel.TextColor3 = Color3.new(1, 1, 1)
uptimeLabel.Font = Enum.Font.Cartoon
uptimeLabel.TextSize = 16
uptimeLabel.Text = "Server Uptime: --:--"

-- Job ID Display
local jobIdLabel = Instance.new("TextLabel", mainFrame)
jobIdLabel.Size = UDim2.new(1, -20, 0, 30)
jobIdLabel.Position = UDim2.new(0, 10, 0, 80)
jobIdLabel.TextColor3 = Color3.new(1, 1, 1)
jobIdLabel.BackgroundColor3 = Color3.fromRGB(95, 47, 15)
jobIdLabel.Font = Enum.Font.Cartoon
jobIdLabel.TextSize = 18
jobIdLabel.Text = "Job ID: " .. (game.JobId ~= "" and game.JobId or "Unavailable")
jobIdLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Input Box
local jobIdInput = Instance.new("TextBox", mainFrame)
jobIdInput.Size = UDim2.new(1, -20, 0, 30)
jobIdInput.Position = UDim2.new(0, 10, 0, 120)
jobIdInput.PlaceholderText = "Enter Job ID..."
jobIdInput.Font = Enum.Font.Cartoon
jobIdInput.TextSize = 16
jobIdInput.TextColor3 = Color3.new(1, 1, 1)
jobIdInput.BackgroundColor3 = Color3.fromRGB(80, 40, 20)

-- Claim Style Button (Join)
local teleportBtn = Instance.new("TextButton", mainFrame)
teleportBtn.Size = UDim2.new(1, -20, 0, 30)
teleportBtn.Position = UDim2.new(0, 10, 0, 160)
teleportBtn.Text = "Join Server by Job ID"
teleportBtn.Font = Enum.Font.Cartoon
teleportBtn.TextSize = 16
teleportBtn.TextColor3 = Color3.new(1, 1, 1)
teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)

-- Copy Button
local copyBtn = Instance.new("TextButton", mainFrame)
copyBtn.Size = UDim2.new(0.5, -15, 0, 30)
copyBtn.Position = UDim2.new(0, 10, 0, 200)
copyBtn.Text = "Copy My Job ID"
copyBtn.Font = Enum.Font.Cartoon
copyBtn.TextSize = 16
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)

-- Random Button
local randomBtn = Instance.new("TextButton", mainFrame)
randomBtn.Size = UDim2.new(0.5, -15, 0, 30)
randomBtn.Position = UDim2.new(0.5, 5, 0, 200)
randomBtn.Text = "Join Random Server"
randomBtn.Font = Enum.Font.Cartoon
randomBtn.TextSize = 16
randomBtn.TextColor3 = Color3.new(1, 1, 1)
randomBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)

-- === FUNCTIONALITY (Same as original script) ===

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

toggleIcon.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Uptime Updater
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