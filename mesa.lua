-- Robust Roblox Lua script for sending public messages in chat
-- For use in Delta Executor Mobile or other Roblox executors

local message = "Hello from Delta Executor! This is a public message."

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ChatService = game:GetService("Chat")

local localPlayer = Players.LocalPlayer
if not localPlayer then
    error("LocalPlayer not found!")
end

-- Wait for chat events
local function waitForChatEvents()
    local chatEvents
    for i = 1, 10 do
        chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if chatEvents then break end
        wait(1)
    end
    return chatEvents
end

-- Try to send message using DefaultChatSystemChatEvents
local function sendViaDefaultChat(msg)
    local chatEvents = waitForChatEvents()
    if not chatEvents then
        warn("DefaultChatSystemChatEvents not found in ReplicatedStorage.")
        return false
    end

    local sayMessageEvent = chatEvents:FindFirstChild("SayMessageRequest")
    if not sayMessageEvent then
        warn("SayMessageRequest event not found in chat events.")
        return false
    end

    -- Fire the server event to send the message in public chat
    sayMessageEvent:FireServer(msg, "All")
    return true
end

-- Fallback: Use Chat:Chat to make message bubble (not always public chat)
local function sendViaChatService(msg)
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    if character and character:FindFirstChild("Head") then
        ChatService:Chat(character.Head, msg, Enum.ChatColor.Blue)
        return true
    end
    warn("Could not find character or Head for Chat:Chat fallback.")
    return false
end

-- Try sending message via DefaultChatSystemChatEvents first
local success = sendViaDefaultChat(message)

-- If that failed, fallback to Chat:Chat method
if not success then
    sendViaChatService(message)
end
