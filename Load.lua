
-- Step 1: Create a RemoteEvent named "RequestVersionInfo" in ReplicatedStorage
-- Use Roblox Studio Explorer to add it under ReplicatedStorage

-- Step 2: Server script in ServerScriptService (e.g. VersionServerScript)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RequestVersionInfo = ReplicatedStorage:WaitForChild("RequestVersionInfo")

local SERVER_VERSION = "1.2.3"  -- Define your server version here

RequestVersionInfo.OnServerEvent:Connect(function(player)
    -- When client requests version, send it back using FireClient
    RequestVersionInfo:FireClient(player, SERVER_VERSION)
end)

-- Step 3: Create a ScreenGui with a TextLabel in StarterGui
-- Name the TextLabel "VersionLabel", set initial Text to "Version: Loading..."

-- Step 4: LocalScript inside the ScreenGui that will request and show the version info

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RequestVersionInfo = ReplicatedStorage:WaitForChild("RequestVersionInfo")
local player = game.Players.LocalPlayer
local versionLabel = script.Parent:WaitForChild("VersionLabel")

-- Request server version when the GUI loads
RequestVersionInfo:FireServer()

-- Listen for server reply with version info
RequestVersionInfo.OnClientEvent:Connect(function(version)
    versionLabel.Text = "Version: " .. version
end)