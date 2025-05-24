-- Script Auto-Chat Roblox (Tombol Tunggal)
-- Mengirim 1 pesan setiap kali tombol diklik

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer

-- Konfigurasi (ubah sesuai kebutuhan)
local MESSAGE = "Halo! Ini pesan otomatis"

-- Fungsi untuk mengirim pesan chat
local function sendSingleMessage()
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[AutoChat] " .. MESSAGE,
        Color = Color3.fromRGB(0, 255, 0),
        Font = Enum.Font.SourceSansBold,
        FontSize = Enum.FontSize.Size24
    })

    -- Kirim ke chat publik
    game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(MESSAGE, "All")
end

-- Buat GUI sederhana
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 60)
Frame.Position = UDim2.new(0.5, -100, 0.5, -30)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Parent = ScreenGui

local SendButton = Instance.new("TextButton")
SendButton.Size = UDim2.new(0.8, 0, 0.7, 0)
SendButton.Position = UDim2.new(0.1, 0, 0.15, 0)
SendButton.Text = "Kirim 1 Pesan"
SendButton.TextColor3 = Color3.new(1, 1, 1)
SendButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
SendButton.Font = Enum.Font.SourceSansBold
SendButton.TextScaled = true
SendButton.Parent = Frame

-- Hubungkan fungsi ke tombol
SendButton.MouseButton1Click:Connect(sendSingleMessage)

print("Tombol pengirim pesan siap digunakan!")