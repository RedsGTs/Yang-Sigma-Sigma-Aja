local button = script.Parent

button.MouseButton1Click:Connect(function()
    local textChatService = game:GetService("TextChatService")
    local generalChannel = textChatService.TextChannels:FindFirstChild("RBXGeneral")

    if generalChannel then
        generalChannel:DisplaySystemMessage("This is a system message!")
    else
        warn("RBXGeneral channel not found.")
    end
end)