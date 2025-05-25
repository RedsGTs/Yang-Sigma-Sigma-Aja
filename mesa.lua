-- Roblox Lua script to simulate typing a public message by manipulating chat UI
-- This approach tries to type message in the default chat input box and press Enter
-- Works only if executor supports UserInput simulation and the default chat UI is active

local message = "Hello from Delta Executor! This message should be visible."

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
if not localPlayer then
    error("LocalPlayer not found!")
end

-- Wait for PlayerGui and Chat input bar availability
local playerGui = localPlayer:WaitForChild("PlayerGui", 10)
if not playerGui then
    error("PlayerGui not found!")
end

local chatFrame = playerGui:FindFirstChild("Chat", true) -- recursive search for Chat
if not chatFrame then
    warn("Chat GUI not found, trying to open chat...")
    -- Press "/" key to open chat
    UserInputService:SetKeyDelay(0.1)
    UserInputService:SendKeyEvent(true, Enum.KeyCode.Slash.Name, false, game)
    UserInputService:SendKeyEvent(false, Enum.KeyCode.Slash.Name, false, game)
    wait(0.5)
    chatFrame = playerGui:FindFirstChild("Chat", true)
    if not chatFrame then
        error("Chat GUI still not found")
    end
end

-- Find the chat bar TextBox
local chatBar = nil
for _, gui in pairs(chatFrame:GetDescendants()) do
    if gui:IsA("TextBox") and gui.Name == "ChatBar" then
        chatBar = gui
        break
    end
end

if not chatBar then
    error("ChatBar TextBox not found")
end

-- Function to simulate typing the message
local function simulateTyping(msg)
    chatBar:CaptureFocus()
    chatBar.Text = ""
    for i = 1, #msg do
        chatBar.Text = chatBar.Text .. msg:sub(i,i)
        RunService.RenderStepped:Wait()
    end
end

-- Function to simulate Enter key press to send message
local function simulateEnter()
    -- Fire the FocusLost event with enter pressed = true to send message
    chatBar:ReleaseFocus(true)
end

-- Simulate typing and sending the message
simulateTyping(message)
wait(0.2) -- small delay before sending
simulateEnter()

print("Message sent by simulating chat input")
