-- Roblox Lua script for sending a public chat message
-- For use in Delta Executor Mobile

local message = "Hello, this is a public message from Delta Executor!" -- Customize this message

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer
if not localPlayer then
    error("LocalPlayer not found!")
end

-- Function to send a chat message via the DefaultChatSystemChatEvents
local function sendPublicMessage(msg)
    local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if not chatEvents then
        warn("DefaultChatSystemChatEvents not found in ReplicatedStorage.")
        return false
    end

    local sayMessageEvent = chatEvents:FindFirstChild("SayMessageRequest")
    if not sayMessageEvent then
        warn("SayMessageRequest event not found!")
        return false
    end

    -- Fire the server event to send the message to public chat
    sayMessageEvent:FireServer(msg, "All")
    return true
end

-- Attempt to send the public message
local success = sendPublicMessage(message)

if success then
    print("Public message sent successfully.")
else
    print("Failed to send public message. Check if the game uses a custom chat system.")
end