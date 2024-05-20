local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Logic = loadstring(game:HttpGet('https://raw.githubusercontent.com/W-Jermome/aimfordem/main/aimlogic.lua'))()

local Window = Rayfield:CreateWindow({
    Name = "LuiHub",
    LoadingTitle = "LuiHub",
    LoadingSubtitle = "by Jermome",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "LuiHub"
    },
})

local Tab = Window:CreateTab("Aimbot")
local Tab2 = Window:CreateTab("ESP")

local Button = Tab:CreateButton({
    Name = "Unload",
    Callback = function()
        Rayfield:Destroy()
    end,
})


local AimToggle = Tab:CreateToggle({
    Name = "Enable/Disable Aimbot",
    CurrentValue = false,
    Flag = "Toggle1", 
    Callback = function(Value)
        Logic.ToggleAimbot(Value)
    end,
})

local Slider = Tab:CreateSlider({
    Name = "Aimbot FOV",
    Range = {0, 1000},
    Increment = 10,
    Suffix = "FOV",
    CurrentValue = 300,
    Flag = "Slider1", 
    Callback = function(Value)
        Logic.SetAimbotFOV(Value)
    end,
})
