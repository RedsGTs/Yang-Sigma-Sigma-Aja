local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- UI references
local gui = script.Parent
local jobIdLabel = gui:WaitForChild("JobIdLabel")
local jobIdInput = gui:WaitForChild("JobIdInput")
local teleportButton = gui:WaitForChild("TeleportButton")
local copyButton = gui:WaitForChild("CopyButton")

-- Place ID (change this to your game's PlaceId)
local placeId = game.PlaceId

-- Display the current Job ID
jobIdLabel.Text = "Current Job ID: " .. (game.JobId ~= "" and game.JobId or "N/A")

-- Copy to clipboard
copyButton.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(game.JobId)
	end
end)

-- Teleport to Job ID
teleportButton.MouseButton1Click:Connect(function()
	local targetJobId = jobIdInput.Text
	if targetJobId and targetJobId ~= "" then
		TeleportService:TeleportToPlaceInstance(placeId, targetJobId, player)
	end
end)