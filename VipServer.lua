--[[
    VIP Server Creator - РАБОЧАЯ ВЕРСИЯ
    Для Escape Tsunami Brainrot
]]

-- ЗАЩИТА
if _G.VipWorking then return end
_G.VipWorking = true

-- ОСНОВНАЯ ФУНКЦИЯ
local function createVip()
    local player = game.Players.LocalPlayer
    local placeId = game.PlaceId
    
    -- Проверка
    if not player then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "❌ Ошибка",
            Text = "Игрок не найден",
            Duration = 2
        })
        return
    end
    
    -- Уведомление
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🔄 Создание VIP",
        Text = "Пожалуйста подождите...",
        Duration = 2
    })
    
    -- ПРОСТЕЙШИЙ СПОСОБ
    local success = pcall(function()
        local TeleportService = game:GetService("TeleportService")
        
        -- Пробуем зарезервировать сервер
        local serverId = TeleportService:ReserveServer(placeId)
        
        if serverId then
            -- Телепортируемся
            TeleportService:TeleportToPrivateServer(placeId, serverId, {player})
        else
            -- Если не получилось, пробуем телепорт в обычный сервер (как запасной вариант)
            TeleportService:Teleport(placeId, player)
        end
    end)
    
    if not success then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "❌ Ошибка",
            Text = "Не удалось создать VIP",
            Duration = 3
        })
    end
end

-- ПРОСТОЙ ИНТЕРФЕЙС
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.Name = "VipMenu"
gui.ResetOnSpawn = false

local button = Instance.new("TextButton")
button.Parent = gui
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.8, 0)
button.BackgroundColor3 = Color3.new(0, 0.5, 0)
button.TextColor3 = Color3.new(1, 1, 1)
button.Text = "🔐 VIP ТЕЛЕПОРТ"
button.Font = Enum.Font.GothamBold
button.TextScaled = true
button.Draggable = true

button.MouseButton1Click:Connect(createVip)

-- Уведомление
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "✅ Готово",
    Text = "Нажми кнопку для VIP",
    Duration = 2
})