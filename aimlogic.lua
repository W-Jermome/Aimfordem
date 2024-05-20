local dwCamera = workspace.CurrentCamera
local dwRunService = game:GetService("RunService")
local dwUIS = game:GetService("UserInputService")
local dwEntities = game:GetService("Players")
local dwLocalPlayer = dwEntities.LocalPlayer
local dwMouse = dwLocalPlayer:GetMouse()

local settings = {
    Aimbot = true,
    Aiming = false,
    Aimbot_AimPart = "Head",
    Aimbot_TeamCheck = true,
    Aimbot_FOV_Radius = 300
    Aimbot_Draw_FOV = false,
    Aimbot_FOV_Color = Color3.fromRGB(255, 255, 255)
}

local fovcircle = Drawing.new("Circle")
fovcircle.Visible = settings.Aimbot_Draw_FOV
fovcircle.Radius = settings.Aimbot_FOV_Radius
fovcircle.Color = settings.Aimbot_FOV_Color
fovcircle.Thickness = 0
fovcircle.Filled = false
fovcircle.Transparency = 1
fovcircle.Position = Vector2.new(dwCamera.ViewportSize.X / 2, dwCamera.ViewportSize.Y / 2)

local function aimAtClosestTarget()
    local dist = math.huge
    local closest_char = nil

    if settings.Aimbot then
        for _, v in ipairs(dwEntities:GetChildren()) do
            if v ~= dwLocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Humanoid").Health > 0 then
                if settings.Aimbot_TeamCheck == true and v.Team ~= dwLocalPlayer.Team or settings.Aimbot_TeamCheck == false then
                    local char = v.Character
                    local char_part_pos, is_onscreen = dwCamera:WorldToViewportPoint(char[settings.Aimbot_AimPart].Position)

                    if is_onscreen then
                        local mag = (Vector2.new(dwMouse.X, dwMouse.Y) - Vector2.new(char_part_pos.X, char_part_pos.Y)).Magnitude
                        if mag < dist and mag < settings.Aimbot_FOV_Radius then
                            dist = mag
                            closest_char = char
                        end
                    end
                end
            end
        end

        if closest_char ~= nil and closest_char:FindFirstChild("HumanoidRootPart") and closest_char:FindFirstChild("Humanoid") and closest_char:FindFirstChild("Humanoid").Health > 0 then
            dwCamera.CFrame = CFrame.new(dwCamera.CFrame.Position, closest_char[settings.Aimbot_AimPart].Position)
        end
    end
end

dwUIS.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not gameProcessed then
        settings.Aiming = true
    end
end)

dwUIS.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        settings.Aiming = false
    end
end)

dwRunService.RenderStepped:Connect(function()
    if settings.Aiming then
        aimAtClosestTarget()
    end
end)

local Logic = {}

function Logic.ToggleAimbot(state)
    settings.Aimbot = state
end

function Logic.SetAimbotFOV(value)
    settings.Aimbot_FOV_Radius = value
end

return Logic
