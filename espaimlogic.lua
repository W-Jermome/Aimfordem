local dwCamera = workspace.CurrentCamera
local dwRunService = game:GetService("RunService")
local dwEntities = game:GetService("Players")
local dwLocalPlayer = dwEntities.LocalPlayer
local dwMouse = dwLocalPlayer:GetMouse()
local dwUserInputService = game:GetService("UserInputService")

local airJumpEnabled = true
local jumpCount = 0
local maxJumps = 2

local settings = {
    Aimbot = true,
    Aiming = true,
    ESP = true,
    Aimbot_AimPart = "Head",
    Aimbot_TeamCheck = true,
    Aimbot_Draw_FOV = false,
    Aimbot_FOV_Radius = 300,
    Aimbot_FOV_Color = Color3.fromRGB(255, 255, 255),
}

local function CreateBoxEsp(v)
    local lplr = game.Players.LocalPlayer
    local camera = game:GetService("Workspace").CurrentCamera
    local CurrentCamera = workspace.CurrentCamera
    local worldToViewportPoint = CurrentCamera.worldToViewportPoint

    local HeadOff = Vector3.new(0, 0.5, 0)
    local LegOff = Vector3.new(0, 3, 0)

    local BoxOutline = Drawing.new("Square")
    BoxOutline.Visible = false
    BoxOutline.Color = Color3.new(0, 0, 0)
    BoxOutline.Thickness = 3
    BoxOutline.Transparency = 1
    BoxOutline.Filled = false

    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.new(1, 1, 1)
    Box.Thickness = 1
    Box.Transparency = 1
    Box.Filled = false

    game:GetService("RunService").RenderStepped:Connect(function()
        if settings.ESP and v.Character ~= nil and v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("HumanoidRootPart") ~= nil and v ~= lplr and v.Character.Humanoid.Health > 0 then
            local Vector, onScreen = camera:worldToViewportPoint(v.Character.HumanoidRootPart.Position)

            local RootPart = v.Character.HumanoidRootPart
            local Head = v.Character.Head
            local RootPosition, RootVis = worldToViewportPoint(CurrentCamera, RootPart.Position)
            local HeadPosition = worldToViewportPoint(CurrentCamera, Head.Position + HeadOff)
            local LegPosition = worldToViewportPoint(CurrentCamera, RootPart.Position - LegOff)

            if onScreen then
                BoxOutline.Size = Vector2.new(1000 / RootPosition.Z, HeadPosition.Y - LegPosition.Y)
                BoxOutline.Position = Vector2.new(RootPosition.X - BoxOutline.Size.X / 2, RootPosition.Y - BoxOutline.Size.Y / 2)
                BoxOutline.Visible = true

                Box.Size = Vector2.new(1000 / RootPosition.Z, HeadPosition.Y - LegPosition.Y)
                Box.Position = Vector2.new(RootPosition.X - Box.Size.X / 2, RootPosition.Y - Box.Size.Y / 2)
                Box.Visible = true

                if v.TeamColor == lplr.TeamColor then
                    BoxOutline.Visible = false
                    Box.Visible = false
                else
                    BoxOutline.Visible = true
                    Box.Visible = true
                end

            else
                BoxOutline.Visible = false
                Box.Visible = false
            end
        else
            BoxOutline.Visible = false
            Box.Visible = false
        end
    end)
end

local function InitESP()
    for _, v in pairs(dwEntities:GetChildren()) do
        if v ~= dwLocalPlayer then
            CreateBoxEsp(v)
        end
    end

    dwEntities.PlayerAdded:Connect(function(v)
        if v ~= dwLocalPlayer then
            CreateBoxEsp(v)
        end
    end)
end

local function TeleportToRandomEnemy()
    local enemies = {}
    for _, v in ipairs(dwEntities:GetChildren()) do
        if v ~= dwLocalPlayer and v.Team ~= dwLocalPlayer.Team and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(enemies, v)
        end
    end

    if #enemies > 0 then
        local randomEnemy = enemies[math.random(1, #enemies)]
        dwLocalPlayer.Character.HumanoidRootPart.CFrame = randomEnemy.Character.HumanoidRootPart.CFrame
    end
end

dwRunService.RenderStepped:Connect(function()
    local dist = math.huge
    local closest_char = nil

    if settings.Aiming and settings.Aimbot then
        for _, v in ipairs(dwEntities:GetChildren()) do
            if v ~= dwLocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Humanoid").Health > 0 then
                if settings.Aimbot_TeamCheck == true and v.Team ~= dwLocalPlayer.Team or settings.Aimbot_TeamCheck ==
                false then
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
end)

-- Mouse input event handling
dwMouse.Button1Down:Connect(function()
    settings.Aiming = true
end)

dwMouse.Button1Up:Connect(function()
    settings.Aiming = false
end)



-- Key press event handling
dwUserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.V then
        TeleportToRandomEnemy()
    end
end)

-- Initialize ESP
InitESP()

