local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local placeId = game.PlaceId

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
mainFrame.Size = UDim2.new(0, 320, 0, 260)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BackgroundTransparency = 0.5
mainFrame.BorderSizePixel = 0
mainFrame.Name = "MainFrame"
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true

-- Server Uptime Label
local uptimeLabel = Instance.new("TextLabel", mainFrame)
uptimeLabel.Size = UDim2.new(0.6, 0, 0, 30)
uptimeLabel.Position = UDim2.new(0, 10, 0, 5)
uptimeLabel.BackgroundTransparency = 1
uptimeLabel.TextColor3 = Color3.new(1, 1, 1)
uptimeLabel.Font = Enum.Font.SourceSans
uptimeLabel.TextSize = 14
uptimeLabel.Text = "Uptime: --:--"

-- Server Version Label
local versionLabel = Instance.new("TextLabel", mainFrame)
versionLabel.Size = UDim2.new(0.4, -10, 0, 30)
versionLabel.Position = UDim2.new(0.6, 0, 0, 5)
versionLabel.BackgroundTransparency = 1
versionLabel.TextColor3 = Color3.fromRGB(180, 255, 180)
versionLabel.Font = Enum.Font.SourceSans
versionLabel.TextSize = 14
versionLabel.TextXAlignment = Enum.TextXAlignment.Right
versionLabel.Text = "Version: ???"

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

-- Join Oldest Server Button
local oldBtn = Instance.new("TextButton", mainFrame)
oldBtn.Size = UDim2.new(1, -20, 0, 30)
oldBtn.Position = UDim2.new(0, 10, 0, 210)
oldBtn.Text = "Join Oldest Server"
oldBtn.Font = Enum.Font.SourceSansBold
oldBtn.TextSize = 16
oldBtn.TextColor3 = Color3.new(1, 1, 1)
oldBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 80)

-- Actions
copyBtn.MouseButton1Click:Connect(function()
	if setclipboard then setclipboard(game.JobId) end
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

oldBtn.MouseButton1Click:Connect(function()
	local remote = ReplicatedStorage:FindFirstChild("GetOldestServer")
	if remote and remote:IsA("RemoteFunction") then
		local oldJobId = remote:InvokeServer()
		if oldJobId then
			TeleportService:TeleportToPlaceInstance(placeId, oldJobId, player)
		end
	end
end)

-- Toggle GUI
local shown = true
toggleIcon.MouseButton1Click:Connect(function()
	shown = not shown
	mainFrame.Visible = shown
end)

-- Uptime Updater
task.spawn(function()
	local startValue = ReplicatedStorage:WaitForChild("ServerStartTime", 5)
	if startValue then
		while true do
			local now = os.time()
			local seconds = now - startValue.Value
			local mins = math.floor(seconds / 60)
			local secs = seconds % 60
			uptimeLabel.Text = string.format("Uptime: %02d:%02d", mins, secs)
			task.wait(1)
		end
	end
end)

-- Set Version Label
task.spawn(function()
	local version = ReplicatedStorage:WaitForChild("ServerVersion", 5)
	if version then
		versionLabel.Text = "Version: " .. version.Value
	end
end)