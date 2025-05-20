--!strict
-- ServerManagerClient.lua

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

local GetServerVersion = ReplicatedStorage:WaitForChild("GetServerVersion")

-- UI references
local gui = script.Parent
local versionLabel = gui:WaitForChild("ServerVersion")
local copyButton = gui:WaitForChild("CopyJobId")
local inputBox = gui:WaitForChild("InputJobId")
local teleportButton = gui:WaitForChild("TeleportToJobId")
local hopButton = gui:WaitForChild("HopServer")

-- Get server version from server
local success, version = pcall(function()
	return GetServerVersion:InvokeServer()
end)

if success and version then
	versionLabel.Text = "Server Version\n" .. version
else
	versionLabel.Text = "Server Version\nN/A"
end

-- Copy JobId
copyButton.MouseButton1Click:Connect(function()
	local jobId = game.JobId
	if setclipboard then
		setclipboard(jobId)
	end
end)

-- Teleport to input JobId
teleportButton.MouseButton1Click:Connect(function()
	local jobId = inputBox.Text
	if jobId and jobId ~= "" then
		TeleportService:TeleportToPlaceInstance(PlaceId, jobId, LocalPlayer)
	end
end)

-- Server hop (join a new public server)
hopButton.MouseButton1Click:Connect(function()
	TeleportService:Teleport(PlaceId, LocalPlayer)
end)