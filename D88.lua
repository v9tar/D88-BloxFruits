--[[
    ██████╗  ██████╗ ██████╗   الإصدار الذهبي - النسخة المحسنة
    ██╔══██╗██╔═══██╗██╔══██╗  Blox Fruits Script - الأفضل في العالم
    ██║  ██║██║   ██║██████╔╝  مطور بواسطة: D88 Team
    ██║  ██║██║   ██║██╔══██╗  ضد الحظر المتقدم مع تقنيات عصرية
    ██████╔╝╚██████╔╝██║  ██║  Arabic UI v3.0 - محسّن
    ╚═════╝  ╚═════╝ ╚═╝  ╚═╝
    
    ملاحظات:
    - تأكد من استخدام Executor يدعم HttpGet وloadstring (مثل Synapse X أو Krnl).
    - تم إضافة تحسينات لنظام الحماية وبعض الفعالية في الزراعة.
    - الوظائف مثل (FindNearestEnemy, TweenTo, AttackEnemy, TeleportToSea) هي أمثلة افتراضية؛ يجب تعديلها وفقاً لاحتياجات اللعبة.
]]

-- تحميل مكتبة الواجهة
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("D88 - بلوكس فروت", "DarkTheme")

--━━━━━━━━━━━━━━ [ تبويب المزرعة ] ━━━━━━━━━━━━━━
local FarmTab = Window:NewTab("المزرعة")
local FarmSection = FarmTab:NewSection("الإعدادات الأساسية")

-- زر لتفعيل المزرعة التلقائية لرفع المستوى
FarmSection:NewToggle("مزرعة تلقائية للمستوى", "يرفع المستوى تلقائياً", function(state)
    _G.AutoLevel = state
    if state then
        spawn(function() AutoLevelFunc() end)
    end
end)

-- زر لمهاجمة أقرب الأعداء
FarmSection:NewToggle("مزرعة أقرب الأعداء", "يهاجم الأعداء القريبين", function(state)
    _G.AutoNearest = state
end)

-- منزلق لضبط مسافة الزراعة
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
    -- مثال: تشغيل دالة هجوم الزعيم (يجب تعريفها وفق متطلباتك)
    if state then
        spawn(function()
            while _G.AutoBoss do
                -- AttackBoss() مثال لدالة هجوم الزعيم
                wait(1)
            end
        end)
    end
end)

--━━━━━━━━━━━━━━ [ تبويب الفواكه ] ━━━━━━━━━━━━━━
local FruitTab = Window:NewTab("الفواكه")
local FruitSection = FruitTab:NewSection("إدارة الفواكه الذكية")

FruitSection:NewToggle("جمع الفواكه تلقائياً", "يجلب جميع الفواكه في الخريطة", function(state)
    _G.AutoCollectFruits = state
    if state then
        spawn(function()
            while _G.AutoCollectFruits do
                -- CollectFruits() يجب تعريف دالة لجمع الفواكه
                wait(2)
            end
        end)
    end
end)

FruitSection:NewToggle("شراء فواكه عشوائية", "كل ساعتين تلقائياً", function(state)
    _G.AutoBuyFruits = state
    if state then
        spawn(function()
            while _G.AutoBuyFruits do
                -- BuyRandomFruit() يجب تعريف دالة شراء الفواكه
                wait(7200) -- ساعتين
            end
        end)
    end
end)

--━━━━━━━━━━━━━━ [ تبويب التنقل ] ━━━━━━━━━━━━━━
local TeleportTab = Window:NewTab("التنقل")
local TeleportSection = TeleportTab:NewSection("الانتقال بين العوالم")

TeleportSection:NewDropdown("العالم المستهدف", "اختر وجهتك", {"العالم الأول", "العالم الثاني", "العالم الثالث"}, function(selected)
    -- مثال: دالة الانتقال بين العوالم (يجب تعديلها حسب احتياجات اللعبة)
    TeleportToSea(selected)
end)

TeleportSection:NewButton("الانتقال إلى جزيرة الشيطان", "إحداثيات مخصصة", function()
    local lp = game.Players.LocalPlayer
    if lp and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = CFrame.new(2850, 150, -5020)
    end
end)

--━━━━━━━━━━━━━━ [ تبويب الإحصائيات ] ━━━━━━━━━━━━━━
local StatsTab = Window:NewTab("الإحصائيات")
local StatsSection = StatsTab:NewSection("معلومات اللاعب الحيوية")

-- تحديث الإحصائيات بشكل دوري
spawn(function()
    while wait(5) do
        local player = game.Players.LocalPlayer
        if player and player:FindFirstChild("Data") then
            local level = player.Data:FindFirstChild("Level") and player.Data.Level.Value or "غير متوفر"
            local beli = player.Data:FindFirstChild("Beli") and player.Data.Beli.Value or "غير متوفر"
            local fruits = #player.Backpack:GetChildren()
            StatsSection:NewLabel("المستوى: " .. tostring(level))
            StatsSection:NewLabel("البلي: " .. tostring(beli))
            StatsSection:NewLabel("الفواكه: " .. tostring(fruits))
        end
    end
end)

--━━━━━━━━━━━━━━ [ تبويب الحماية ] ━━━━━━━━━━━━━━
local SecurityTab = Window:NewTab("الحماية")
local SecuritySection = SecurityTab:NewSection("نظام مكافحة الحظر")

SecuritySection:NewToggle("تفعيل الحماية الذكية", "تقنيات متقدمة ضد الاكتشاف", function(state)
    _G.AntiBan = state
    if state then
        spawn(function() AdvancedAntiBan() end)
    end
end)

SecuritySection:NewSlider("مستوى الحماية", "من 1 إلى 5", 1, 5, function(val)
    _G.AntiBanLevel = val
end)

--━━━━━━━━━━━━━━ [ الدوال المساعدة ] ━━━━━━━━━━━━━━

-- نظام الحماية المتقدم مع مزيد من العشوائية وإجراءات الحماية
function AdvancedAntiBan()
    while _G.AntiBan do
        wait(math.random(5, 15))
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(math.random(1, 100), math.random(1, 100)))
        -- المزيد من الإجراءات بناءً على مستوى الحماية
        if _G.AntiBanLevel and _G.AntiBanLevel >= 5 then
            -- مثال لتغيير هوية الخيط بشكل عشوائي (قد يتطلب صلاحيات معينة)
            pcall(function() setthreadidentity(math.random(1, 7)) end)
        end
    end
end

-- نظام الزراعة التلقائي مع فحص حالة اللاعب
function AutoLevelFunc()
    while _G.AutoLevel do
        local target = FindNearestEnemy() -- يجب تعريف هذه الدالة لإيجاد أقرب عدو
        if target and target:FindFirstChild("HumanoidRootPart") then
            TweenTo(target.HumanoidRootPart.CFrame * CFrame.new(0, 0, _G.FarmDistance or 20))
            AttackEnemy() -- يجب تعريف دالة الهجوم على العدو
        end
        wait(math.random(0.5, 1.5))
    end
end

-- دوال افتراضية (Placeholder) يجب تعديلها حسب متطلبات اللعبة
function FindNearestEnemy()
    -- مثال بسيط: البحث في جميع اللاعبين باستثناء اللاعب المحلي
    local lp = game.Players.LocalPlayer
    local nearest, distance = nil, math.huge
    for i, player in pairs(game.Players:GetPlayers()) do
        if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude
            if dist < distance then
                distance = dist
                nearest = player.Character
            end
        end
    end
    return nearest
end

function TweenTo(cframeTarget)
    local lp = game.Players.LocalPlayer
    if lp and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local TweenService = game:GetService("TweenService")
        local info = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(lp.Character.HumanoidRootPart, info, {CFrame = cframeTarget})
        tween:Play()
        tween.Completed:Wait()
    end
end

function AttackEnemy()
    -- مثال على هجوم بسيط: إرسال أمر هجوم (يجب تعديله وفقاً للعبة)
    print("هجوم على العدو!")
end

function TeleportToSea(destination)
    -- مثال افتراضي للانتقال بين العوالم بناءً على الاختيار
    local coords = {
        ["العالم الأول"] = CFrame.new(100, 50, 200),
        ["العالم الثاني"] = CFrame.new(500, 60, -300),
        ["العالم الثالث"] = CFrame.new(-250, 70, 400)
    }
    local lp = game.Players.LocalPlayer
    if lp and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and coords[destination] then
        lp.Character.HumanoidRootPart.CFrame = coords[destination]
    end
end

--━━━━━━━━━━━━━━ [ تشغيل الواجهة ] ━━━━━━━━━━━━━━
Library:Init() -- بدء الواجهة

print("تم تحميل سكربت D88 بنجاح! | الإصدار العربي v3.0 - النسخة المحسنة")
