-- Job ID Hub with Icon Minimize System

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local placeId = game.PlaceId
local joinTime = tick()

-- Cleanup
if game.CoreGui:FindFirstChild("JobIDHub") then
	game.CoreGui.JobIDHub:Destroy()
end

-- UI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "JobIDHub"
gui.ResetOnSpawn = false

-- Main UI Frame
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
minimizeBtn.Name = "MinimizeBtn"

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

-- Job ID
local jobIdLabel = Instance.new("TextLabel", mainFrame)
jobIdLabel.Size = UDim2.new(1, -20, 0, 40)
jobIdLabel.Position = UDim2.new(0, 10, 0, 40)
jobIdLabel.TextColor3 = Color3.new(1, 1, 1)
jobIdLabel.BackgroundTransparency = 1
jobIdLabel.Font = Enum.Font.SourceSansBold
jobIdLabel.TextSize = 16
jobIdLabel.Text = "Job ID: " .. (game.JobId ~= "" and game.JobId or "Unavailable")

-- Job ID Input
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

-- Copy Button
local copyBtn = Instance.new("TextButton", mainFrame)
copyBtn.Size = UDim2.new(0.5, -15, 0, 30)
copyBtn.Position = UDim2.new(0, 10, 0, 170)
copyBtn.Text = "Copy My Job ID"
copyBtn.Font = Enum.Font.SourceSansBold
copyBtn.TextSize = 16
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)

-- Random Button
local randomBtn = Instance.new("TextButton", mainFrame)
randomBtn.Size = UDim2.new(0.5, -15, 0, 30)
randomBtn.Position = UDim2.new(0.5, 5, 0, 170)
randomBtn.Text = "Join Random Server"
randomBtn.Font = Enum.Font.SourceSansBold
randomBtn.TextSize = 16
randomBtn.TextColor3 = Color3.new(1, 1, 1)
randomBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 60)

-- Icon for minimized state
local iconBtn = Instance.new("TextButton", gui)
iconBtn.Size = UDim2.new(0, 80, 0, 30)
iconBtn.Position = UDim2.new(0, 10, 0, 10)
iconBtn.Text = "JobID Hub"
iconBtn.Visible = false
iconBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
iconBtn.TextColor3 = Color3.new(1,1,1)
iconBtn.Font = Enum.Font.SourceSansBold
iconBtn.TextSize = 14
iconBtn.Name = "IconBtn"
iconBtn.Active = true
iconBtn.Draggable = true

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

-- Toggle to Icon
minimizeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	iconBtn.Visible = true
end)

-- Restore UI from icon
iconBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
	iconBtn.Visible = false
end)

-- Uptime Counter
task.spawn(function()
	while true do
		local seconds = math.floor(tick() - joinTime)
		local mins = math.floor(seconds / 60)
		local secs = seconds % 60
		uptimeLabel.Text = string.format("Uptime: %02d:%02d", mins, secs)
		task.wait(1)
	end
end)