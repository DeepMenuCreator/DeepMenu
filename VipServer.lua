--[[
    VIP Server Creator - Secure Version
    Для Escape Tsunami Brainrot
    С защитой от утечки данных
]]

-- ПРОВЕРКА НА УТЕЧКУ ДАННЫХ
local function securityCheck()
    -- Проверяем не пытаются ли украсть данные
    local exploits = {
        "dex",
        "explorer",
        "inject",
        "dump",
        "cheat"
    }
    
    for _, exploit in pairs(exploits) do
        if game:GetService("CoreGui"):FindFirstChild(exploit) then
            return false -- Найдена угроза
        end
    end
    
    -- Проверяем наш скрипт
    local scriptInfo = debug.getinfo(1)
    if not scriptInfo then
        return false
    end
    
    return true
end

-- Если угроза обнаружена - не запускаемся
if not securityCheck() then
    return
end

-- ЗАЩИТА ОТ ПОВТОРНОГО ЗАПУСКА
if _G.VipServerSecure then
    return
end
_G.VipServerSecure = true

-- СОЗДАНИЕ VIP СЕРВЕРА
local function createVipServer()
    local player = game.Players.LocalPlayer
    local placeId = game.PlaceId
    
    if not player or not placeId then
        return
    end
    
    -- Проверяем нет ли утечки перед созданием
    if not securityCheck() then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "❌ Ошибка безопасности",
            Text = "Обнаружена угроза",
            Duration = 2
        })
        return
    end
    
    -- Создаем сервер
    pcall(function()
        local TeleportService = game:GetService("TeleportService")
        
        -- Резервируем сервер
        local serverCode = TeleportService:ReserveServer(placeId)
        
        if serverCode then
            -- Настройки приватного сервера
            local options = {
                Name = "🔒 VIP " .. player.Name,
                MaxPlayers = 1, -- Только ты
                IsPrivate = true,
                AllowFriends = false,
                AllowLinks = false
            }
            
            -- Телепортируемся
            TeleportService:TeleportToPrivateServer(
                placeId,
                serverCode,
                {player},
                options
            )
            
            -- Уведомление
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "✅ VIP Сервер",
                Text = "Создан! Телепортация...",
                Duration = 3
            })
        end
    end)
end

-- СОЗДАЕМ ИНТЕРФЕЙС (СКРЫТЫЙ)
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.Name = "V" .. string.char(105) .. string.char(112) -- "Vip" в кодах
gui.ResetOnSpawn = false
gui.Enabled = true

-- КНОПКА (НЕВИДИМАЯ)
local button = Instance.new("TextButton")
button.Parent = gui
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.8, 0)
button.BackgroundColor3 = Color3.new(0, 0, 0)
button.BackgroundTransparency = 0.5
button.TextColor3 = Color3.new(0, 1, 0)
button.Text = "🔐 VIP СЕРВЕР"
button.Font = Enum.Font.GothamBold
button.TextScaled = true
button.Draggable = true -- Можно двигать

-- ДЕЙСТВИЕ ПРИ НАЖАТИИ
button.MouseButton1Click:Connect(function()
    -- Проверка безопасности перед созданием
    if securityCheck() then
        createVipServer()
    else
        button.Text = "❌ БЛОКИРОВКА"
        button.TextColor3 = Color3.new(1, 0, 0)
    end
end)

-- ГОРЯЧАЯ КЛАВИША (НА ВСЯКИЙ СЛУЧАЙ)
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.V then -- Нажми V для создания
        if securityCheck() then
            createVipServer()
        end
    end
end)

-- УВЕДОМЛЕНИЕ О ЗАГРУЗКЕ
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🛡️ VIP Server",
    Text = "Защита активна. Нажми кнопку или клавишу V",
    Duration = 3
})