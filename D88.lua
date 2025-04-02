--[[
    ██████╗  ██████╗ ██████╗   الإصدار الذهبي
    ██╔══██╗██╔═══██╗██╔══██╗  Blox Fruits Script
    ██║  ██║██║   ██║██████╔╝  مطور بواسطة: D88 Team
    ██║  ██║██║   ██║██╔══██╗  ضد الحظر المتقدم
    ██████╔╝╚██████╔╝██║  ██║  Arabic UI v3.0
    ╚═════╝  ╚═════╝ ╚═╝  ╚═╝
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("D88 - بلوكس فروت", "DarkTheme")

-- █▀▀ █░█ ▄▀█ █▀▄ █▀█ █▀█   █▀▀ █▀█ █▀▄▀█ █▀▀
-- █▄▄ █▀█ █▀█ █▄▀ █▄█ █▀▄   █▄▄ █▄█ █░▀░█ ██▄

--━━━━━━━━━━━━━━ [ تبويب المزرعة ] ━━━━━━━━━━━━━━
local FarmTab = Window:NewTab("المزرعة")
local FarmSection = FarmTab:NewSection("الإعدادات الأساسية")

FarmSection:NewToggle("مزرعة تلقائية للمستوى", "يرفع المستوى تلقائياً", function(state)
    _G.AutoLevel = state
    AutoLevelFunc() -- دالة الزراعة المخصصة
end)

FarmSection:NewToggle("مزرعة أقرب الأعداء", "يهاجم الأعداء القريبين", function(state)
    _G.AutoNearest = state
end)

FarmSection:NewSlider("مسافة المزرعة", "تحديد المسافة المثلى", 10, 50, function(val)
    _G.FarmDistance = val
end)

--━━━━━━━━━━━━━━ [ تبويب الزعماء ] ━━━━━━━━━━━━━━
local BossTab = Window:NewTab("الزعماء")
local BossSection = BossTab:NewSection("نظام الزعماء المتقدم")

BossSection:NewDropdown("اختر زعيماً", "القائمة المحدثة", {"السيف", "إله الرعد", "الشيطان الأحمر"}, function(selected)
    _G.SelectedBoss = selected
end)

BossSection:NewToggle("هجوم أوتوماتيكي", "يقتل الزعيم المحدد", function(state)
    _G.AutoBoss = state
end)

--━━━━━━━━━━━━━━ [ تبويب الفواكه ] ━━━━━━━━━━━━━━
local FruitTab = Window:NewTab("الفواكه")
local FruitSection = FruitTab:NewSection("إدارة الفواكه الذكية")

FruitSection:NewToggle("جمع الفواكه تلقائياً", "يجلب جميع الفواكه في الخريطة", function(state)
    _G.AutoCollectFruits = state
end)

FruitSection:NewToggle("شراء فواكه عشوائية", "كل ساعتين تلقائياً", function(state)
    _G.AutoBuyFruits = state
end)

--━━━━━━━━━━━━━━ [ تبويب التنقل ] ━━━━━━━━━━━━━━
local TeleportTab = Window:NewTab("التنقل")
local TeleportSection = TeleportTab:NewSection("الانتقال بين العوالم")

TeleportSection:NewDropdown("العالم المستهدف", "اختر وجهتك", {"العالم الأول", "العالم الثاني", "العالم الثالث"}, function(selected)
    TeleportToSea(selected)
end)

TeleportSection:NewButton("الانتقال إلى جزيرة الشيطان", "إحداثيات مخصصة", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2850, 150, -5020)
end)

--━━━━━━━━━━━━━━ [ تبويب الإحصائيات ] ━━━━━━━━━━━━━━
local StatsTab = Window:NewTab("الإحصائيات")
local StatsSection = StatsTab:NewSection("معلومات اللاعب الحيوية")

StatsSection:NewLabel("المستوى: "..game.Players.LocalPlayer.Data.Level.Value)
StatsSection:NewLabel("البلي: "..game.Players.LocalPlayer.Data.Beli.Value)
StatsSection:NewLabel("الفواكه: "..#game:GetService("Players").LocalPlayer.Backpack:GetChildren())

--━━━━━━━━━━━━━━ [ تبويب الحماية ] ━━━━━━━━━━━━━━
local SecurityTab = Window:NewTab("الحماية")
local SecuritySection = SecurityTab:NewSection("نظام مكافحة الحظر")

SecuritySection:NewToggle("تفعيل الحماية الذكية", "تقنيات متقدمة ضد الاكتشاف", function(state)
    _G.AntiBan = state
    AdvancedAntiBan() -- نظام الحماية المخصص
end)

SecuritySection:NewSlider("مستوى الحماية", "من 1 إلى 5", 1, 5, function(val)
    _G.AntiBanLevel = val
end)

-- █▀▀ █▀█ █▀▀ █▀▀ █ ▄▀█ █░░   █▀▀ █▀█ █▀▄▀█ █▀▀
-- █▄▄ █▀▄ ██▄ █▄▄ █ █▀█ █▄▄   █▄▄ █▄█ █░▀░█ ██▄

-- نظام الحماية المتقدم
function AdvancedAntiBan()
    while _G.AntiBan do
        wait(math.random(5,15))
        -- محاكاة حركات بشرية
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new(math.random(1,100), math.random(1,100))
        
        -- تشويش على الذاكرة
        if _G.AntiBanLevel == 5 then
            setthreadidentity(2)
        end
    end
end

-- نظام الزراعة التلقائي
function AutoLevelFunc()
    while _G.AutoLevel do
        local target = FindNearestEnemy()
        if target then
            TweenTo(target.HumanoidRootPart.CFrame * CFrame.new(0,0,_G.FarmDistance))
            AttackEnemy()
        end
        wait(math.random(0.5,1.5))
    end
end

--━━━━━━━━━━━━━━ [ الواجهة الجرافيكية ] ━━━━━━━━━━━━━━
Library:Init() -- تشغيل الواجهة

print("تم تحميل سكربت D88 بنجاح! | الإصدار العربي v3.0")
