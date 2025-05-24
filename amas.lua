-- Script Auto-Chat Roblox (Tombol Tunggal)
-- Mengirim 1 pesan setiap kali tombol diklik

local Player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Konfigurasi (sesuaikan pesan yang ingin dikirim)
local MESSAGE = "Halo! Ini pesan otomatis"

-- Fungsi untuk simulasi input keyboard
local function simulateKeyPress(keyCode, isKeyDown)
    local input = Instance.new("InputObject")
    input.UserInputType = Enum.UserInputType.Keyboard
    input.KeyCode = keyCode
    input.Position = Vector3.new(0, 0, 0)
    input.UserInputState = isKeyDown and Enum.UserInputState.Begin or Enum.UserInputState.End
    UserInputService:ProcessInput(input)
end

-- Fungsi utama untuk mengirim 1 pesan
local function sendSingleMessage()
    -- Buka chat dengan simulasi tekan tombol "/"
    simulateKeyPress(Enum.KeyCode.Slash, true)
    simulateKeyPress(Enum.KeyCode.Slash, false)
    
    wait(0.2) -- Tunggu chat terbuka
    
    -- Ketik pesan
    for i = 1, #MESSAGE do
        local char = string.sub(MESSAGE, i, i)
        local keyCode
        
        if char == " " then
            keyCode = Enum.KeyCode.Space
        else
            keyCode = Enum.KeyCode[string.upper(char)] or Enum.KeyCode.Unknown
        end
        
        if keyCode ~= Enum.KeyCode.Unknown then
            simulateKeyPress(keyCode, true)
            simulateKeyPress(keyCode, false)
            wait(0.03) -- Delay ketik
        end
    end
    
    -- Kirim pesan dengan Enter
    simulateKeyPress(Enum.KeyCode.Return, true)
    simulateKeyPress(Enum.KeyCode.Return, false)
    
    print("Pesan terkirim: "..MESSAGE)
end

-- Buat GUI sederhana
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")

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
SendButton.Parent = Frame

-- Hubungkan fungsi ke tombol
SendButton.MouseButton1Click:Connect(function()
    sendSingleMessage()
end)

print("Tombol pengirim pesan siap digunakan!")