local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local airJumpEnabled = true
local jumpCount = 0
local maxJumps = 2 -- how often u can jump

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.Space and airJumpEnabled then
        if Humanoid:GetState() == Enum.HumanoidStateType.Freefall and jumpCount < maxJumps then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            jumpCount = jumpCount + 1
        end
    end
end)

Humanoid.StateChanged:Connect(function(_, newState)
    if newState == Enum.HumanoidStateType.Landed then
        jumpCount = 0
    end
end)
