--[[
   ▄████████  ▄█     █▄   ▄█        ▄█        ▄██████▄     ███        ▄█    █▄    
  ███    ███ ███     ███ ███       ███       ███    ███ ▀█████████▄   ███    ███   
  ███    █▀  ███     ███ ███       ███       ███    ███    ▀███▀▀██   ███    ███   
  ███        ███     ███ ███       ███       ███    ███     ███   ▀  ▄███▄▄▄▄███▄  
▀███████████ ███     ███ ███       ███       ███    ███     ███     ▀▀███▀▀▀▀███▀  
         ███ ███     ███ ███       ███       ███    ███     ███       ███    ███   
   ▄█    ███ ███ ▄█▄ ███ ███▌    ▄ ███▌    ▄ ███    ███     ███       ███    ███   
 ▄████████▀   ▀███▀███▀  █████▄▄██ █████▄▄██  ▀██████▀     ▄████▀     ███    █▀    
                          ▀         ▀                                            
]]

local _G = getgenv() or {}
_G.D88 = {
    Version = "7.0",
    DeviceDetection = {
        ["iOS"] = false,
        ["Android"] = false,
        ["PC"] = false,
        ["Console"] = false
    },
    Language = "Auto",
    SeaSpecific = {
        ["Sea1"] = {},
        ["Sea2"] = {},
        ["Sea3"] = {}
    }
}

-- نظام كشف الجهاز التلقائي
local function DetectDevice()
    local UserInputService = game:GetService("UserInputService")
    if UserInputService.TouchEnabled then
        if UserInputService.KeyboardEnabled then
            _G.D88.DeviceDetection["iOS"] = true
        else
            _G.D88.DeviceDetection["Android"] = true
        end
    else
        _G.D88.DeviceDetection["PC"] = true
    end
end

-- نظام اللغات المتعدد
local Languages = {
    ["English"] = {
        ["Farm"] = "Auto Farm",
        ["Boss"] = "Boss Hunter"
    },
    ["Arabic"] = {
        ["Farm"] = "فارم تلقائي",
        ["Boss"] = "صيد البوسات"
    },
    ["French"] = {
        ["Farm"] = "Farm Automatique",
        ["Boss"] = "Chasseur de Boss"
    }
}

-- نظام تحميل العالم التلقائي
local function LoadSeaSpecific()
    local Sea = game:GetService("Players").LocalPlayer.Data.Sea.Value
    if Sea == 1 then
        _G.D88.SeaSpecific.Sea1 = {
            Swords = {"Katana", "Cutlass"},
            Bosses = {"The Gorilla King", "Bobby"}
        }
    elseif Sea == 2 then
        _G.D88.SeaSpecific.Sea2 = {
            Swords = {"Saber", "Pole"},
            Bosses = {"The Saw", "Order"}
        }
    elseif Sea == 3 then
        _G.D88.SeaSpecific.Sea3 = {
            Swords = {"Zweihander", "Dragon Trident"},
            Bosses = ["Dragon King", "Cake Queen"]
        }
    end
end

-- الواجهة الرئيسية (بدون شروحات داخلية)
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Window = Rayfield:CreateWindow({
    Name = "D88 Ultimate",
    LoadingTitle = "Initializing...",
    LoadingSubtitle = "Loading premium features",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "D88Config",
        FileName = "D88Settings"
    },
    Discord = {
        Enabled = true,
        Invite = "discord.gg/d88",
        RememberJoins = true
    }
})

-- تبويب الفارم
local FarmTab = Window:CreateTab("Farming", "rbxassetid://4483362458")
local FarmSection = FarmTab:CreateSection("Auto Farm Settings")

FarmSection:AddToggle("Auto Farm", {
    CurrentValue = false,
    Callback = function(Value)
        _G.D88.AutoFarm = Value
    end
})

-- تبويب البوسات
local BossTab = Window:CreateTab("Bosses", "rbxassetid://4483362458")
local BossSection = BossTab:CreateSection("Boss Hunter")

BossSection:AddDropdown("Select Boss", {
    Values = _G.D88.SeaSpecific["Sea"..game:GetService("Players").LocalPlayer.Data.Sea.Value].Bosses,
    CurrentOption = "Select",
    Callback = function(Value)
        _G.D88.SelectedBoss = Value
    end
})

-- نظام التنفيذ
DetectDevice()
LoadSeaSpecific()

-- تحسينات الأداء
if _G.D88.DeviceDetection["Android"] or _G.D88.DeviceDetection["iOS"] then
    setfpscap(60)
    game:GetService("RunService"):Set3dRenderingEnabled(false)
else
    setfpscap(240)
end

-- التحديث التلقائي
task.spawn(function()
    while task.wait(300) do
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/v9tar/D88-BloxFruits/main/VersionCheck.lua"))()
        end)
    end
end)

-- حقوق الملكية
_G.D88.Copyright = {
    Owner = "D88 Technologies",
    Year = 2024,
    License = "Premium",
    Protection = "SecureBoot"
}
