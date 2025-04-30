-- Job ID Hub V3 (Delta Ready + Fixed Toggle + Shortcut Key + Glow Buttons)

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local placeId = game.PlaceId

-- Destroy existing GUI
if game.CoreGui:FindFirstChild("JobIDHub") then
	game.CoreGui.JobIDHub:Destroy()
end

-- Helper: Glow effect
local function addGlowEffect(button, color1, color2)
	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
	local tween = TweenService:Create(button, tweenInfo, { BackgroundColor3 = color2 })
	tween:Play()
	button.MouseEnter:Connect(function()
		tween:Pause()
		button.BackgroundColor3 = color1
	end)
	button.MouseLeave:Connect(function()
		tween:Play()
	end)
end

-- UI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "JobIDHub"
gui.ResetOnSpawn = false

local toggleIcon = Instance.new("TextButton", gui)
toggleIcon.Name = "ToggleIcon"
toggleIcon.Size = UDim2.new(0, 50, 0, 50)
toggleIcon.Position = UDim2.new(0, 10, 0, 10)
toggleIcon.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
toggleIcon.Text = "Reds"
toggleIcon.TextColor3 = Color3.new(1, 1, 1)
toggleIcon.TextSize = 20
addGlowEffect(toggleIcon, Color3.fromRGB(0, 120, 215), Color3.fromRGB(0, 180, 255))

toggleIcon.Active = true
toggleIcon.Draggable = true

local mainFrame = Instance.new("Frame", gui)
mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
mainFrame.Size = UDim2.new(0, 320, 0, 230)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.Name = "MainFrame"
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true

-- Server Uptime
local uptimeLabel = Instance.new("TextLabel", mainFrame)
uptimeLabel.Size = UDim2.new(1, -20, 0, 30)
uptimeLabel.Position = UDim2.new(0, 10, 0, 5)
uptimeLabel.BackgroundTransparency = 1
uptimeLabel.TextColor3 = Color3.new(1, 1, 1)
uptimeLabel.Font = Enum.Font.SourceSans
uptimeLabel.TextSize = 14
uptimeLabel.TextXAlignment = Enum.TextXAlignment.Left
uptimeLabel.Text = "Server Uptime: N/A"

-- Job ID Display
local jobIdLabel = Instance.new("TextLabel", mainFrame)
jobIdLabel.Size = UDim2.new(1, -20, 0, 40)
jobIdLabel.Position = UDim2.new(0, 10, 0, 40)
jobIdLabel.TextColor3 = Color3.new(1, 1, 1)
jobIdLabel.BackgroundTransparency = 1
jobIdLabel.Font = Enum.Font.SourceSansBold
jobIdLabel.TextSize = 16
jobIdLabel.Text = "Job ID: " .. (game.JobId ~= "" and game.JobId or "Unavailable")
jobIdLabel.Name = "JobIdLabel"

-- Input box for Job ID
local jobIdInput = Instance.new("TextBox", mainFrame)
jobIdInput.Size = UDim2.new(1, -20, 0, 30)
jobIdInput.Position = UDim2.new(0, 10, 0, 90)
jobIdInput.PlaceholderText = "Enter Job ID..."
jobIdInput.Font = Enum.Font.SourceSans
jobIdInput.TextSize = 16
jobIdInput.TextColor3 = Color3.new(1, 1, 1)
jobIdInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
jobIdInput.Name = "JobIdInput"

-- Teleport Button
local teleportBtn = Instance.new("TextButton", mainFrame)
teleportBtn.Size = UDim2.new(1, -20, 0, 30)
teleportBtn.Position = UDim2.new(0, 10, 0, 130)
teleportBtn.Text = "Join Server by Job ID"
teleportBtn.Font = Enum.Font.SourceSansBold
teleportBtn.TextSize = 16
teleportBtn.TextColor3 = Color3.new(1, 1, 1)
teleportBtn.Name = "TeleportBtn"
addGlowEffect(teleportBtn, Color3.fromRGB(0, 200, 100), Color3.fromRGB(0, 255, 150))

-- Copy Job ID Button
local copyBtn = Instance.new("TextButton", mainFrame)
copyBtn.Size = UDim2.new(0.5, -15, 0, 30)
copyBtn.Position = UDim2.new(0, 10, 0, 170)
copyBtn.Text = "Copy My Job ID"
copyBtn.Font = Enum.Font.SourceSansBold
copyBtn.TextSize = 16
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.Name = "CopyBtn"
addGlowEffect(copyBtn, Color3.fromRGB(140, 80, 200), Color3.fromRGB(180, 120, 240))

-- Join Random Server Button
local randomBtn = Instance.new("TextButton", mainFrame)
randomBtn.Size = UDim2.new(0.5, -15, 0, 30)
randomBtn.Position = UDim2.new(0.5, 5, 0, 170)
randomBtn.Text = "Join Random Server"
randomBtn.Font = Enum.Font.SourceSansBold
randomBtn.TextSize = 16
randomBtn.TextColor3 = Color3.new(1, 1, 1)
randomBtn.Name = "RandomBtn"
addGlowEffect(randomBtn, Color3.fromRGB(255, 140, 0), Color3.fromRGB(255, 180, 60))

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

-- Toggle GUI
toggleIcon.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- Shortcut key: Press "M" to toggle
UIS.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.M then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

-- Uptime Fetcher (from server start)
task.spawn(function()
	while true do
		local success, data = pcall(function()
			return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"))
		end)
		if success and data then
			for _, server in pairs(data.data) do
				if server.id == game.JobId then
					local upSeconds = math.floor(server.uptime or 0)
					uptimeLabel.Text = string.format("Server Uptime: %02d:%02d", math.floor(upSeconds / 60), upSeconds % 60)
					break
				end
			end
		end
		task.wait(15)
	end
end)
