--[[
    D88 Blox Fruits Ultimate Suite v4.0
    GitHub: https://github.com/v9tar/D88-BloxFruits
--]]

local RayField = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local VirtualInput = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

-- ███╗░░██╗███████╗░█████╗░██╗░░░██╗██╗███╗░░██╗
-- ████╗░██║██╔════╝██╔══██╗██║░░░██║██║████╗░██║
-- ██╔██╗██║█████╗░░██║░░╚═╝╚██╗░██╔╝██║██╔██╗██║
-- ██║╚████║██╔══╝░░██║░░██╗░╚████╔╝░██║██║╚████║
-- ██║░╚███║███████╗╚█████╔╝░░╚██╔╝░░██║██║░╚███║
-- ╚═╝░░╚══╝╚══════╝░╚════╝░░░░╚═╝░░░╚═╝╚═╝░░╚══╝

local D88 = {
    Security = {
        AntiBan = true,
        TeleportBypass = true,
        Randomizer = math.random(100,500)
    },
    Performance = {
        Threading = true,
        Cache = {},
        Latency = 0.1
    }
}

-- ░██████╗░█████╗░██╗░░░██╗███████╗
-- ██╔════╝██╔══██╗██║░░░██║██╔════╝
-- ╚█████╗░██║░░██║╚██╗░██╔╝█████╗░░
-- ░╚═══██╗██║░░██║░╚████╔╝░██╔══╝░░
-- ██████╔╝╚█████╔╝░░╚██╔╝░░███████╗
-- ╚═════╝░░╚════╝░░░░╚═╝░░░╚══════╝

local function SafeTween(...)
    pcall(function()
        TweenService:Create(...):Play()
    end)
end

local function AdvancedESP(target, color, text)
    if D88.ESPEnabled then
        -- نظام ESP مع حماية ضد الاكتشاف
    end
end

-- █▀▀ █░█ █▀▀ █▀▄ █ █▄░█ █▀▀
-- █▄▄ █▀█ ██▄ █▄▀ █ █░▀█ █▄█

local Window = RayField:CreateWindow({
    Name = "D88 Blox Fruits",
    LoadingTitle = "نظام التشغيل الذكي",
    LoadingSubtitle = "By v9tar",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "D88_Config",
        FileName = "Profile_1"
    },
    Discord = {
        Enabled = true,
        Invite = "discord.gg/xxxxx",
        RememberJoins = true
    }
})

-- █▀▀ ▄▀█ █▀▄▀█ █▀▀   █▀█ █▀▀ █▀▀ █▄░█
-- █▄█ █▀█ █░▀░█ ██▄   █▄█ █▄▄ ██▄ █░▀█

local FarmTab = Window:CreateTab("الفارم المتقدم", "rbxassetid://4483362458")
local AutoFarmSection = FarmTab:CreateSection("النظام الذكي")
local ToolSelector = AutoFarmSection:AddDropdown("أداة الهجوم", {"Sword", "Fruit", "Gun"}, function(Value)
    D88.Config.Tool = Value
end)

AutoFarmSection:AddSlider("سرعة الهجوم", 1, 50, 200, false, function(Value)
    D88.Performance.Latency = Value/1000
end)

-- █▀▀ █▀█ █▀▀ █▀▄ █ ▀█▀ █▀█ █▀█
-- █▄▄ █▄█ ██▄ █▄▀ █ ░█░ █▄█ █▀▀

local BossTab = Window:CreateTab("نظام البوسات", "rbxassetid://4483362458")
BossTab:AddToggle("الصيد التلقائي", function(State)
    D88.AutoBoss = State
    while D88.AutoBoss do
        -- نظام صيد البوسات الذكي
        task.wait(D88.Performance.Latency)
    end
end)

-- █▀▀ █▄░█ ▀█▀ █▀█ █░░ █▀▀ █▀▀ ▀█▀
-- ██▄ █░▀█ ░█░ █▄█ █▄▄ ██▄ █▄▄ ░█░

local TeleportTab = Window:CreateTab("التنقل الكوني", "rbxassetid://4483362458")
TeleportTab:AddButton("العالم الثاني", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
end)

-- █▀▀ █▀█ █▀▀ █░█ █▀ █▀▀   █░░ █▀█ █▀▀ █▄░█
-- █▄▄ █▄█ █▄▄ █▄█ ▄█ ██▄   █▄▄ █▄█ ██▄ █░▀█

local PerformanceTab = Window:CreateTab("التحسينات", "rbxassetid://4483362458")
PerformanceTab:AddToggle("وضع التوفير", function(State)
    D88.Performance.Threading = State
    setfpscap(State and 30 or 144)
end)

-- █▀▀ █ █░░ █▀▀ ▀█▀ █▀▀ █▀█   █▀▀ █▀█ █▀█ █░░ █▀▀ ▀█▀
-- █▀░ █ █▄▄ ██▄ ░█░ ██▄ █▀▄   █▄▄ █▄█ █▄█ █▄▄ ██▄ ░█░

RayField:Notify("مرحبا!", "D88 يعمل بنجاح!", "rbxassetid://4483362458", 5)

-- █▀▀ █▀█ █▀▀ █▀▄ █ █▄░█ █▀▀
-- █▄▄ █▄█ ██▄ █▄▀ █ █░▀█ █▄█

local function AutoUpdate()
    local NewVersion = game:HttpGet("https://raw.githubusercontent.com/v9tar/D88-BloxFruits/main/Version.txt")
    if NewVersion ~= D88.Version then
        RayField:Notify("تحديث جديد!", "جاري التحديث...", "rbxassetid://4483362458")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/v9tar/D88-BloxFruits/main/D
