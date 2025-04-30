-- Job ID Hub V2 (Delta Ready)

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local placeId = game.PlaceId
local joinTime = tick()

-- Destroy existing GUI
if game.CoreGui:FindFirstChild("JobIDHub") then
	game.CoreGui.JobIDHub:Destroy()
end

-- UI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "JobIDHub"
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
mainFrame.Size = UDim2.new(0, 320, 0, 230)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Name = "MainFrame"
mainFrame.Active = true
mainFrame.Draggable = true

-- Minimize Button
local minimizeBtn = Instance.new("TextButton", mainFrame)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 5)
minimizeBtn.Text = "-"
minimizeBtn.TextScaled = true
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

-- Server Uptime
local uptimeLabel = Instance.new("TextLabel", mainFrame)
uptimeLabel.Size = UDim2.new(0, 120, 0, 30)
uptimeLabel.Position = UDim2.new(1, -160, 0, 5)
uptimeLabel.BackgroundTransparency = 1
uptimeLabel.TextColor3 = Color3.new(1, 1, 1)
uptimeLabel.Font = Enum.Font.SourceSans
uptimeLabel.TextSize = 14
uptimeLabel.Text = "Uptime: 0s"
uptimeLabel.TextXAlignment = Enum.TextXAlignment.Right

-- Job ID Display
local jobIdLabel = Instance.new("TextLabel", mainFrame)
jobIdLabel.Size = UDim2.new(1, -20, 0, 40)
jobIdLabel.Position = UDim2.new(0, 10, 0, 40)
jobIdLabel.TextColor3 = Color3.new(1, 1, 1)
jobIdLabel.BackgroundTransparency = 1
jobIdLabel.Font = Enum.Font.SourceSansBold
jobIdLabel.TextSize = 16
jobIdLabel.Text = "Job ID: " .. (game.JobId ~= "" and game.JobId or "Unavailable")

-- Input box for Job ID
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

-- Copy Job ID
copyBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(game.JobId)
	end
end)

-- Teleport to input Job ID
teleportBtn.MouseButton1Click:Connect(function()
	local inputJob = jobIdInput.Text
	if inputJob and inputJob ~= "" then
		TeleportService:TeleportToPlaceInstance(placeId, inputJob, player)
	end
end)

-- Join Random Server
randomBtn.MouseButton1Click:Connect(function()
	local servers = game.HttpService:JSONDecode(
		game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")
	)
	for _, server in pairs(servers.data) do
		if server.playing < server.maxPlayers and server.id ~= game.JobId then
			TeleportService:TeleportToPlaceInstance(placeId, server.id, player)
			break
		end
	end
end)

-- Minimize toggle
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _, v in pairs(mainFrame:GetChildren()) do
		if v:IsA("GuiObject") and v.Name ~= "MinimizeButton" then
			v.Visible = not minimized
		end
	end
	minimizeBtn.Text = minimized and "+" or "-"
	mainFrame.Size = minimized and UDim2.new(0, 200, 0, 40) or UDim2.new(0, 320, 0, 230)
end)

-- Server Uptime Timer
task.spawn(function()
	while true do
		local seconds = math.floor(tick() - joinTime)
		local mins = math.floor(seconds / 60)
		local secs = seconds % 60
		uptimeLabel.Text = string.format("Uptime: %02d:%02d", mins, secs)
		task.wait(1)
	end
end)