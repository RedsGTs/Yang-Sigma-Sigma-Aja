-- Roblox Lua script to send a public chat message
-- Compatible with Roblox executors (like Delta Executor Mobile)

local message = "Hello" -- Customize this message

-- Function to send a chat message via the default chat event
local function sendPublicMessage(msg)
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local localPlayer = Players.LocalPlayer
    if not localPlayer then
        error("LocalPlayer not found!")
        return
    end

    -- The 'DefaultChatSystemChatEvents' is the common event used to send chat messages
    local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if not chatEvents then
        error("Chat events not found in ReplicatedStorage!")
        return
    end

    local sayMessageEvent = chatEvents:FindFirstChild("SayMessageRequest")
    if not sayMessageEvent then
        error("SayMessageRequest event not found!")
        return
    end

    -- Fire the server event to send the message to public chat
    sayMessageEvent:FireServer(msg, "All")
end

sendPublicMessage(message)
