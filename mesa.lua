local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer
local button = script.Parent
local frame = button.Parent

-- Pesan yang akan dikirim
local pesan = "Halo semua! Ini pesan otomatis."

-- Fungsi untuk mengirim pesan
local function kirimPesan()
    -- Coba gunakan TextChatService
    local success, err = pcall(function()
        local generalChannel = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")
        generalChannel:DisplaySystemMessage(pesan)
    end)

    if not success then
        -- Jika gagal, tampilkan pesan di atas kepala karakter
        if player.Character and player.Character:FindFirstChild("Head") then
            game:GetService("Chat"):Chat(player.Character.Head, pesan, Enum.ChatColor.Blue)
        end
    end
end

-- Event saat tombol diklik
button.MouseButton1Click:Connect(kirimPesan)

-- Fungsi untuk membuat frame dapat digeser
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                               startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or
       input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)