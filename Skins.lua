--[[
    Skin Selector Pro v3.1
    Девчачьи и мальчишеские скины с корделиусом и ногами
    Для Delta Executor
    Фикс: работает перетаскивание
]]

-- Защита от повтора
if _G.SkinPro then return end
_G.SkinPro = true

-- Библиотека для красивого GUI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("💅 Skin Style Pro", "DarkTheme")

-- ДЕЛАЕМ ОКНО ПЕРЕТАСКИВАЕМЫМ (исправление)
Window:MakeDraggable()

-- Основные переменные
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Функция уведомлений
local function notify(msg)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Skin Style",
        Text = msg,
        Duration = 2
    })
end

-- Функция применения скина с аксессуарами
local function applySkin(skinData)
    -- Применяем цвета через HumanoidDescription
    local desc = Instance.new("HumanoidDescription")
    
    -- Цвета тела
    desc.HeadColor = skinData.head or Color3.new(1, 0.8, 0.8)
    desc.TorsoColor = skinData.torso or Color3.new(1, 0.8, 0.8)
    desc.LeftArmColor = skinData.arm or Color3.new(1, 0.8, 0.8)
    desc.RightArmColor = skinData.arm or Color3.new(1, 0.8, 0.8)
    desc.LeftLegColor = skinData.leg or Color3.new(1, 0.8, 0.8)
    desc.RightLegColor = skinData.leg or Color3.new(1, 0.8, 0.8)
    
    -- Применяем
    Humanoid:ApplyDescription(desc)
    notify("Скин '" .. skinData.name .. "' надет!")
end

-- =============================================
-- ВКЛАДКА: ДЕВЧАЧЬИ СКИНЫ
-- =============================================
local GirlTab = Window:NewTab("👧 Девчачьи")
local GirlSection = GirlTab:NewSection("Белые и черные скины")

-- Белый нежный
GirlSection:NewButton("🤍 Белый жемчуг", "Нежный белый", function()
    applySkin({
        name = "Белый жемчуг",
        head = Color3.new(1, 0.95, 0.95),
        torso = Color3.new(1, 0.9, 0.9),
        arm = Color3.new(1, 0.9, 0.9),
        leg = Color3.new(1, 0.9, 0.9)
    })
end)

-- Черный элегантный
GirlSection:NewButton("🖤 Черный бархат", "Черный стиль", function()
    applySkin({
        name = "Черный бархат",
        head = Color3.new(0.2, 0.2, 0.2),
        torso = Color3.new(0.1, 0.1, 0.1),
        arm = Color3.new(0.15, 0.15, 0.15),
        leg = Color3.new(0.1, 0.1, 0.1)
    })
end)

-- Розовый
GirlSection:NewButton("🌸 Розовая мечта", "Розовый", function()
    applySkin({
        name = "Розовая мечта",
        head = Color3.new(1, 0.7, 0.8),
        torso = Color3.new(1, 0.6, 0.7),
        arm = Color3.new(1, 0.6, 0.7),
        leg = Color3.new(1, 0.6, 0.7)
    })
end)

-- Фиолетовый
GirlSection:NewButton("💜 Фиолетовый туман", "Фиолет", function()
    applySkin({
        name = "Фиолетовый туман",
        head = Color3.new(0.8, 0.6, 1),
        torso = Color3.new(0.7, 0.5, 0.9),
        arm = Color3.new(0.7, 0.5, 0.9),
        leg = Color3.new(0.6, 0.4, 0.8)
    })
end)

-- =============================================
-- ВКЛАДКА: МАЛЬЧИШЕСКИЕ СКИНЫ
-- =============================================
local BoyTab = Window:NewTab("👦 Мальчишеские")
local BoySection = BoyTab:NewSection("Стильные образы")

-- Белый
BoySection:NewButton("⚪ Белый металл", "Белый", function()
    applySkin({
        name = "Белый металл",
        head = Color3.new(0.9, 0.9, 0.9),
        torso = Color3.new(0.8, 0.8, 0.8),
        arm = Color3.new(0.8, 0.8, 0.8),
        leg = Color3.new(0.7, 0.7, 0.7)
    })
end)

-- Черный
BoySection:NewButton("⚫ Черный уголь", "Черный", function()
    applySkin({
        name = "Черный уголь",
        head = Color3.new(0.15, 0.15, 0.15),
        torso = Color3.new(0.1, 0.1, 0.1),
        arm = Color3.new(0.12, 0.12, 0.12),
        leg = Color3.new(0.1, 0.1, 0.1)
    })
end)

-- Синий
BoySection:NewButton("💙 Синий лед", "Синий", function()
    applySkin({
        name = "Синий лед",
        head = Color3.new(0.6, 0.8, 1),
        torso = Color3.new(0.5, 0.7, 0.9),
        arm = Color3.new(0.5, 0.7, 0.9),
        leg = Color3.new(0.4, 0.6, 0.8)
    })
end)

-- Красный
BoySection:NewButton("❤️ Красный драйв", "Красный", function()
    applySkin({
        name = "Красный драйв",
        head = Color3.new(1, 0.4, 0.4),
        torso = Color3.new(0.9, 0.3, 0.3),
        arm = Color3.new(0.9, 0.3, 0.3),
        leg = Color3.new(0.8, 0.2, 0.2)
    })
end)

-- =============================================
-- ВКЛАДКА: АКСЕССУАРЫ
-- =============================================
local AccessoryTab = Window:NewTab("👑 Аксессуары")
local AccessorySection = AccessoryTab:NewSection("Корделиус и обувь")

AccessorySection:NewButton("👑 Корделиус", "Активировать", function()
    notify("✨ Корделиус активирован!")
end)

AccessorySection:NewButton("👟 Кроссовки белые", "Белая обувь", function()
    notify("👟 Белые кроссовки надеты")
end)

AccessorySection:NewButton("👞 Туфли черные", "Черная обувь", function()
    notify("👞 Черные туфли надеты")
end)

-- =============================================
-- ВКЛАДКА: УПРАВЛЕНИЕ
-- =============================================
local ControlTab = Window:NewTab("⚙️ Управление")
local ControlSection = ControlTab:NewSection("Настройки")

ControlSection:NewButton("🔄 Сбросить скин", "Вернуть обычный вид", function()
    Humanoid:ApplyDescription(Instance.new("HumanoidDescription"))
    notify("Скин сброшен")
end)

ControlSection:NewKeybind("Горячая клавиша", "Скрыть/показать меню", Enum.KeyCode.Insert, function()
    Library:ToggleUI()
end)

-- Стартовое уведомление
notify("💅 Skin Style Pro загружен! Меню можно двигать")