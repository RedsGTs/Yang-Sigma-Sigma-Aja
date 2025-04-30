

---



-- Job ID Hub for Delta
-- Creates a simple UI to view/copy current JobId and teleport to another

local TeleportService = game:GetService("TeleportService")
local player = game.Players.LocalPlayer

-- Destroy existing GUI if rerun
if game.CoreGui:FindFirstChild("JobIDHub") then
	game.CoreGui.JobIDHub:Destroy()
end

-- Create GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "JobIDHub"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Name = "MainFrame"

local JobIdLabel = Instance.new("TextLabel", Frame)
JobIdLabel.Size = UDim2.new(1, -20, 0, 50)
JobIdLabel.Position = UDim2.new(0, 10, 0, 10)
JobIdLabel.TextColor3 = Color3.new(1, 1, 1)
JobIdLabel.BackgroundTransparency = 1
JobIdLabel.Font = Enum.Font.SourceSans
JobIdLabel.TextSize = 16
JobIdLabel.Text = "Job ID: " .. (game.JobId ~= "" and game.JobId or "Unavailable")

local JobIdBox = Instance.new("TextBox", Frame)
JobIdBox.Size = UDim2.new(1, -20, 0, 30)
JobIdBox.Position = UDim2.new(0, 10, 0, 70)
JobIdBox.PlaceholderText = "Enter Job ID..."
JobIdBox.Text = ""
JobIdBox.Font = Enum.Font.SourceSans
JobIdBox.TextSize = 16
JobIdBox.TextColor3 = Color3.new(1, 1, 1)
JobIdBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local TeleportButton = Instance.new("TextButton", Frame)
TeleportButton.Size = UDim2.new(1, -20, 0, 30)
TeleportButton.Position = UDim2.new(0, 10, 0, 110)
TeleportButton.Text = "Join Server by Job ID"
TeleportButton.Font = Enum.Font.SourceSansBold
TeleportButton.TextSize = 16
TeleportButton.TextColor3 = Color3.new(1, 1, 1)
TeleportButton.BackgroundColor3 = Color3.fromRGB(60, 100, 60)

local CopyButton = Instance.new("TextButton", Frame)
CopyButton.Size = UDim2.new(1, -20, 0, 30)
CopyButton.Position = UDim2.new(0, 10, 0, 150)
CopyButton.Text = "Copy My Job ID"
CopyButton.Font = Enum.Font.SourceSansBold
CopyButton.TextSize = 16
CopyButton.TextColor3 = Color3.new(1, 1, 1)
CopyButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)

-- Button Actions
CopyButton.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(game.JobId)
	end
end)

TeleportButton.MouseButton1Click:Connect(function()
	local jobId = JobIdBox.Text
	if jobId and jobId ~= "" then
		local placeId = game.PlaceId
		TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
	end
end)


---

