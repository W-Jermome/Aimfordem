local dwCamera = workspace.CurrentCamera
local dwRunService = game:GetService("RunService")
local dwUIS = game:GetService("UserInputService")
local dwEntities = game:GetService("Players")
local dwLocalPlayer = dwEntities.LocalPlayer
local dwMouse = dwLocalPlayer:GetMouse()

local settings = {
    Aimbot = true,
    Aiming = false,
    ESP = true,
    HitboxExpander = false,
    Aimbot_AimPart = "Head",
    Aimbot_TeamCheck = true,
    Aimbot_Draw_FOV = false,
    Aimbot_FOV_Radius = 300,
    Aimbot_FOV_Color = Color3.fromRGB(255, 255, 255)
}

local uiVisible = false
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 200)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = uiVisible
mainFrame.Parent = screenGui

local aimbotToggle = Instance.new("TextButton")
aimbotToggle.Size = UDim2.new(1, 0, 0, 50)
aimbotToggle.Position = UDim2.new(0, 0, 0, 0)
aimbotToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
aimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
aimbotToggle.Text = "Toggle Aimbot: ON"
aimbotToggle.Parent = mainFrame

local espToggle = Instance.new("TextButton")
espToggle.Size = UDim2.new(1, 0, 0, 50)
espToggle.Position = UDim2.new(0, 0, 0, 50)
espToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
espToggle.Text = "Toggle ESP: ON"
espToggle.Parent = mainFrame

local hitboxToggle = Instance.new("TextButton")
hitboxToggle.Size = UDim2.new(1, 0, 0, 50)
hitboxToggle.Position = UDim2.new(0, 0, 0, 100)
hitboxToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hitboxToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxToggle.Text = "Toggle Hitbox Expander: OFF"
hitboxToggle.Parent = mainFrame

local fovcircle = Drawing.new("Circle")
fovcircle.Visible = settings.Aimbot_Draw_FOV
fovcircle.Radius = settings.Aimbot_FOV_Radius
fovcircle.Color = settings.Aimbot_FOV_Color
fovcircle.Thickness = 0
fovcircle.Filled = false
fovcircle.Transparency = 1
fovcircle.Position = Vector2.new(dwCamera.ViewportSize.X / 2, dwCamera.ViewportSize.Y / 2)

dwUIS.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        settings.Aiming = true
    elseif i.KeyCode == Enum.KeyCode.RightShift then
        uiVisible = not uiVisible
        mainFrame.Visible = uiVisible
    end
end)

dwUIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        settings.Aiming = false
    end
end)

aimbotToggle.MouseButton1Click:Connect(function()
    settings.Aimbot = not settings.Aimbot
    aimbotToggle.Text = "Toggle Aimbot: " .. (settings.Aimbot and "ON" or "OFF")
end)

espToggle.MouseButton1Click:Connect(function()
    settings.ESP = not settings.ESP
    espToggle.Text = "Toggle ESP: " .. (settings.ESP and "ON" or "OFF")
end)

hitboxToggle.MouseButton1Click:Connect(function()
    settings.HitboxExpander = not settings.HitboxExpander
    hitboxToggle.Text = "Toggle Hitbox Expander: " .. (settings.HitboxExpander and "ON" or "OFF")
end)

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

local function expandHitboxes()
    while settings.HitboxExpander do
        for _, v in pairs(dwEntities:GetPlayers()) do
            if v.Name ~= dwLocalPlayer.Name and v.Character then
                local parts = {"RightUpperLeg", "LeftUpperLeg", "HeadHB", "HumanoidRootPart"}
                for _, partName in ipairs(parts) do
                    local part = v.Character:FindFirstChild(partName)
                    if part then
                        part.CanCollide = false
                        part.Transparency = partName == "HumanoidRootPart" and 0.5 or 10
                        part.Size = Vector3.new(13, 13, 13)
                    end
                end
            end
        end
        wait(1)
    end
end

hitboxToggle.MouseButton1Click:Connect(function()
    settings.HitboxExpander = not settings.HitboxExpander
    hitboxToggle.Text = "Toggle Hitbox Expander: " .. (settings.HitboxExpander and "ON" or "OFF")
    if settings.HitboxExpander then
        coroutine.wrap(expandHitboxes)()
    end
end)

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

-- Initialize ESP
InitESP()
