-- Tunggu GUI chat muncul
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Buka chat UI agar TextBox aktif
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)

-- Fungsi auto-chat (khusus sistem TextChatService)
local function autoChat(message)
	local ChatInputBar = player.PlayerGui:FindFirstChild("Chat") and player.PlayerGui.Chat:FindFirstChild("TextBoxContainer") and player.PlayerGui.Chat.TextBoxContainer:FindFirstChildWhichIsA("TextBox")

	if ChatInputBar then
		ChatInputBar.Text = message
		ChatInputBar:CaptureFocus() -- Fokus ke chat
		wait(0.2)
		-- Kirim enter key
		local VirtualInputManager = game:GetService("VirtualInputManager")
		VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
		VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
	end
end

-- Kirim berkali-kali
while true do
	autoChat("Halo semua dari auto chat Delta!")
	wait(5)
end