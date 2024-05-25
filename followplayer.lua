local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Replace TargetPlayerName with the name of the player you want to follow
local targetPlayerName = "Target"

local localPlayer = Players.LocalPlayer
local targetPlayer = Players:FindFirstChild(targetPlayerName)

local function followPlayer()
    if targetPlayer and targetPlayer.Character and localPlayer.Character then
        local targetRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local localRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")

        if targetRootPart and localRootPart then
            -- Move the local player to the target player's position
            localRootPart.CFrame = CFrame.new(targetRootPart.Position + Vector3.new(3, 0, 0)) -- Follow 3 studs behind the target
        end
    end
end

RunService.RenderStepped:Connect(followPlayer)
