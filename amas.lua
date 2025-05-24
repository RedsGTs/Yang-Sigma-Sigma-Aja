-- AutoChatManual.lua
-- This LocalScript simulates manual chat interaction in Roblox:
-- It "clicks" the chat icon, types a message, and sends it.

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local chatMessage = "Halo, ini pesan otomatis!"  -- Customize your message here
local chatOpened = false

-- Function to open the chat window
local function openChat()
    -- This fires Roblox's Chat window open event
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "Chat opening simulation initiated."
    })
    -- Roblox chat window can be opened by triggering the FocusChat event.
    StarterGui:SetCore("FocusChat", true)
    chatOpened = true
end

-- Function to simulate typing and sending message
local function sendChatMessage(msg)
    -- Use Roblox's default chat system to send the message
    local ChatService = game:GetService("Chat")
    ChatService:Chat(player.Character or player.CharacterAdded:Wait(), msg, Enum.ChatColor.Blue)
end

-- Function to simulate the manual process on key press
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.K then  -- When player presses K
        -- Step 1: Open chat input box (like tapping chat icon)
        openChat()

        -- Wait a moment to simulate typing
        wait(0.5)

        -- Step 2: Send the chat message (simulate typing and press enter)
        sendChatMessage(chatMessage)
    end
end)

-- Optional: Notify player script is loaded
StarterGui:SetCore("ChatMakeSystemMessage", {
    Text = "AutoChatManual.lua script loaded. Press 'K' to send automatic chat message."
})
