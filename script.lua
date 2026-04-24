repeat task.wait() until game:IsLoaded()

-- ============================================
-- PROTECCIÓN (SI CAMBIAN ESTO, EL SCRIPT NO FUNCIONA)
-- ============================================
local OWNER = "sxzly"
local WEBHOOK = "https://discord.com/api/webhooks/1497095716437229700/a6LGFiPCpYDCLcekYG15mmcw_lWuReLQdvTVJeeA1ylyByJdhBuOAk40lDdzcm1mqwjs"

-- VERIFICACIÓN AUTOMÁTICA - SI ALGUIEN MODIFICA, SE BLOQUEA
if OWNER ~= "sxzly" then
    print("❌ Crédito modificado - Ejecución bloqueada")
    return
end

if WEBHOOK ~= "https://discord.com/api/webhooks/1497095716437229700/a6LGFiPCpYDCLcekYG15mmcw_lWuReLQdvTVJeeA1ylyByJdhBuOAk40lDdzcm1mqwjs" then
    print("❌ Webhook modificado - Ejecución bloqueada")
    return
end

print("🔒 Protección activa - Script verificado")

-- ============================================
-- SERVICIOS
-- ============================================
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local httpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local repstorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- ============================================
-- ARCHIVOS DE GUARDADO SEPARADOS
-- ============================================
local RESETS_FILE = "skywars_resets_sxzly.txt"
local XP_FILE = "skywars_xp_sxzly.txt"

local totalResets = 0
local totalXP = 0
local XP_PER_RESET = 600
local startTime = os.time()

-- Cargar datos guardados
if isfile and readfile then
    local success1, savedResets = pcall(function() return readfile(RESETS_FILE) end)
    if success1 and savedResets then
        totalResets = tonumber(savedResets) or 0
        print("✅ Resets loaded:", totalResets)
    end
    
    local success2, savedXP = pcall(function() return readfile(XP_FILE) end)
    if success2 and savedXP then
        totalXP = tonumber(savedXP) or 0
        print("✅ XP loaded:", totalXP)
    end
else
    warn("⚠️ Tu executor no soporta guardar archivos")
end

local function saveData()
    if writefile then
        pcall(function()
            writefile(RESETS_FILE, tostring(totalResets))
            writefile(XP_FILE, tostring(totalXP))
            print("💾 Datos guardados - Resets:", totalResets, "XP:", totalXP)
        end)
    end
end

local function getElapsedTime()
    local elapsed = os.time() - startTime
    local hours = math.floor(elapsed / 3600)
    local minutes = math.floor((elapsed % 3600) / 60)
    local seconds = elapsed % 60
    
    if hours > 0 then
        return string.format("%dh %dm %ds", hours, minutes, seconds)
    elseif minutes > 0 then
        return string.format("%dm %ds", minutes, seconds)
    else
        return string.format("%ds", seconds)
    end
end

local function sendResetWebhook(reason)
    totalResets = totalResets + 1
    totalXP = totalXP + XP_PER_RESET
    saveData()
    
    if uiElements then
        uiElements.resetsLabel.Text = "🏆 " .. totalResets
    end
    
    task.spawn(function()
        pcall(function()
            local embed = {
                ["embeds"] = {{
                    ["title"] = "🔄 Auto-Reset Triggered",
                    ["description"] = "The script has detected a chest and reset the player",
                    ["color"] = 3447003,
                    ["fields"] = {
                        {["name"] = "👤 Username", ["value"] = player.Name, ["inline"] = true},
                        {["name"] = "🔁 Total Resets", ["value"] = tostring(totalResets), ["inline"] = true},
                        {["name"] = "⭐ Total XP Gained", ["value"] = tostring(totalXP) .. " XP", ["inline"] = true},
                        {["name"] = "⏱️ Running Time", ["value"] = getElapsedTime(), ["inline"] = true},
                        {["name"] = "💎 XP This Reset", ["value"] = "+" .. tostring(XP_PER_RESET) .. " XP", ["inline"] = true},
                        {["name"] = "📊 XP per Hour", ["value"] = string.format("~%.0f XP/h", (totalXP / math.max(1, (os.time() - startTime) / 3600))), ["inline"] = true},
                        {["name"] = "📍 Reason", ["value"] = reason or "Chest height detected", ["inline"] = false},
                        {["name"] = "🎮 Game", ["value"] = "SkyWars", ["inline"] = true}
                    },
                    ["footer"] = {["text"] = "made by sxzly"},
                    ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S")
                }}
            }
            request({Url = WEBHOOK, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = httpService:JSONEncode(embed)})
        end)
    end)
end

-- ============================================
-- UI MODERNA FLOTANTE
-- ============================================
local ScreenGuiModern = Instance.new("ScreenGui")
ScreenGuiModern.Name = "StatsUI"
ScreenGuiModern.Parent = player:WaitForChild("PlayerGui")
ScreenGuiModern.ResetOnSpawn = false
ScreenGuiModern.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGuiModern
MainFrame.AnchorPoint = Vector2.new(1, 0)
MainFrame.Position = UDim2.new(1, -10, 0, 80)
MainFrame.Size = UDim2.new(0, 230, 0, 90)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = MainFrame
titleLabel.Position = UDim2.new(0, 10, 0, 5)
titleLabel.Size = UDim2.new(0, 150, 0, 20)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "⚔️ SKYWARS FARM"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 12
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local creditLabel = Instance.new("TextLabel")
creditLabel.Parent = MainFrame
creditLabel.Position = UDim2.new(0, 155, 0, 5)
creditLabel.Size = UDim2.new(0, 70, 0, 20)
creditLabel.BackgroundTransparency = 1
creditLabel.Font = Enum.Font.Gotham
creditLabel.Text = "By sxzly"
creditLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
creditLabel.TextSize = 10
creditLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Resets
local resetsLabel = Instance.new("TextLabel")
resetsLabel.Parent = MainFrame
resetsLabel.Position = UDim2.new(0, 10, 0, 28)
resetsLabel.Size = UDim2.new(1, -20, 0, 28)
resetsLabel.BackgroundTransparency = 1
resetsLabel.Font = Enum.Font.GothamBold
resetsLabel.Text = "🏆 " .. totalResets
resetsLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
resetsLabel.TextSize = 18
resetsLabel.TextXAlignment = Enum.TextXAlignment.Left

-- XP por partida
local xpPerMatchLabel = Instance.new("TextLabel")
xpPerMatchLabel.Parent = MainFrame
xpPerMatchLabel.Position = UDim2.new(0, 10, 0, 56)
xpPerMatchLabel.Size = UDim2.new(1, -20, 0, 18)
xpPerMatchLabel.BackgroundTransparency = 1
xpPerMatchLabel.Font = Enum.Font.Gotham
xpPerMatchLabel.Text = "💎 +" .. XP_PER_RESET .. " XP"
xpPerMatchLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
xpPerMatchLabel.TextSize = 11
xpPerMatchLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Timer
local timerLabel = Instance.new("TextLabel")
timerLabel.Parent = MainFrame
timerLabel.Position = UDim2.new(0, 10, 0, 74)
timerLabel.Size = UDim2.new(1, -20, 0, 14)
timerLabel.BackgroundTransparency = 1
timerLabel.Font = Enum.Font.Gotham
timerLabel.Text = "⏱️ " .. getElapsedTime()
timerLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
timerLabel.TextSize = 10
timerLabel.TextXAlignment = Enum.TextXAlignment.Left

uiElements = {
    resetsLabel = resetsLabel,
    timerLabel = timerLabel
}

task.spawn(function()
    while true do
        timerLabel.Text = "⏱️ " .. getElapsedTime()
        resetsLabel.Text = "🏆 " .. totalResets
        task.wait(1)
    end
end)

-- ============================================
-- UI DE CARGA ORIGINAL
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LoadingScreen"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = player:WaitForChild("PlayerGui")

local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
background.BorderSizePixel = 0
background.Parent = screenGui

local logoImage = Instance.new("ImageLabel")
logoImage.Size = UDim2.new(0, 200, 0, 200)
logoImage.Position = UDim2.new(0.5, -100, 0.5, -150)
logoImage.BackgroundTransparency = 1
logoImage.Image = "rbxassetid://127677235878436"
logoImage.Parent = background

local loadBarBG = Instance.new("Frame")
loadBarBG.Size = UDim2.new(0, 300, 0, 3)
loadBarBG.Position = UDim2.new(0.5, -150, 0.5, 80)
loadBarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
loadBarBG.Parent = background

local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(0, 100, 0, 20)
versionText.Position = UDim2.new(1, -110, 1, -30)
versionText.BackgroundTransparency = 1
versionText.Text = "v1.0"
versionText.TextColor3 = Color3.fromRGB(120, 120, 120)
versionText.Font = Enum.Font.Code
versionText.TextSize = 12
versionText.Parent = background

local madeByText = Instance.new("TextLabel")
madeByText.Size = UDim2.new(0, 200, 0, 20)
madeByText.Position = UDim2.new(0, 10, 1, -30)
madeByText.BackgroundTransparency = 1
madeByText.Text = "made by sxzly"
madeByText.TextColor3 = Color3.fromRGB(120, 120, 120)
madeByText.Font = Enum.Font.Code
madeByText.TextSize = 12
madeByText.Parent = background

local tipText = Instance.new("TextLabel")
tipText.Size = UDim2.new(0, 600, 0, 20)
tipText.Position = UDim2.new(0.5, -300, 1, -40)
tipText.BackgroundTransparency = 1
tipText.Text = "tip: you can always sleep while afk farming!"
tipText.TextColor3 = Color3.fromRGB(130, 130, 130)
tipText.Font = Enum.Font.Code
tipText.TextSize = 10
tipText.Parent = background

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(0, 400, 0, 30)
loadingText.Position = UDim2.new(0.5, -200, 0.5, 100)
loadingText.BackgroundTransparency = 1
loadingText.Text = "deleting match history"
loadingText.TextColor3 = Color3.fromRGB(200, 200, 200)
loadingText.Font = Enum.Font.Code
loadingText.TextSize = 14
loadingText.Parent = background

local percentageText = Instance.new("TextLabel")
percentageText.Size = UDim2.new(0, 100, 0, 20)
percentageText.Position = UDim2.new(0.5, -50, 0.5, 50)
percentageText.BackgroundTransparency = 1
percentageText.Text = "0%"
percentageText.TextColor3 = Color3.fromRGB(200, 200, 200)
percentageText.Font = Enum.Font.Code
percentageText.TextSize = 12
percentageText.Parent = background

local loadBarFill = Instance.new("Frame")
loadBarFill.Size = UDim2.new(0, 0, 1, 0)
loadBarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
loadBarFill.Parent = loadBarBG

-- ============================================
-- DETECCIÓN DE COFRES
-- ============================================
local workspace = game:GetService("Workspace")
local CHEST_NAME = "chest"
local HEIGHT_TOLERANCE = 2
local CHECK_INTERVAL = 0.1
local ENABLED = true

local hasTriggered = false
local isProcessing = false

local function findNearestChest()
    local character = player.Character
    if not character then return nil end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end
    
    local playerPos = humanoidRootPart.Position
    local nearestChest = nil
    local nearestDistance = math.huge
    
    local chestsFolder = workspace:FindFirstChild("Chests")
    if chestsFolder then
        for _, obj in pairs(chestsFolder:GetChildren()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                local chestPos
                if obj:IsA("Model") then
                    local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    if primary then chestPos = primary.Position end
                elseif obj:IsA("BasePart") then
                    chestPos = obj.Position
                end
                if chestPos then
                    local distance = (playerPos - chestPos).Magnitude
                    if distance < nearestDistance then
                        nearestDistance = distance
                        nearestChest = obj
                    end
                end
            end
        end
    end
    return nearestChest, nearestDistance
end

local function getObjectHeight(obj)
    if obj:IsA("Model") then
        local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
        if primary then return primary.Position.Y end
    elseif obj:IsA("BasePart") then
        return obj.Position.Y
    end
    return nil
end

local function fastReset(method)
    if hasTriggered or isProcessing then return end
    hasTriggered = true
    isProcessing = true
    
    pcall(function()
        loadingText.Text = "HEIGHT MATCHED! KILLING..."
        loadingText.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        sendResetWebhook(method or "Chest height detected")
        
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
        end
        task.wait(0.3)
        
        loadingText.Text = "TELEPORTING..."
        loadingText.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        local data = TeleportService:GetLocalPlayerTeleportData()
        player:Kick("waiting for tp...")
        task.wait(0.25)
        TeleportService:Teleport(game.PlaceId, player, data)
    end)
end

-- METHOD 1
task.spawn(function()
    while ENABLED do
        pcall(function()
            local character = player.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local nearestChest = findNearestChest()
                    if nearestChest then
                        local playerHeight = humanoidRootPart.Position.Y
                        local chestHeight = getObjectHeight(nearestChest)
                        if chestHeight then
                            local heightDiff = math.abs(playerHeight - chestHeight)
                            if heightDiff <= HEIGHT_TOLERANCE then
                                print("🔥 Chest detected! Height diff:", heightDiff)
                                fastReset("Nearest chest height (Method 1)")
                                return
                            end
                        end
                    end
                end
            end
        end)
        task.wait(CHECK_INTERVAL)
    end
end)

-- METHOD 2
local function isAtChestHeight()
    local character = player.Character
    if not character then return false end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    local chestsFolder = workspace:FindFirstChild("Chests")
    if not chestsFolder then return false end
    local playerY = rootPart.Position.Y
    for _, chest in pairs(chestsFolder:GetChildren()) do
        if chest:IsA("Model") or chest:IsA("Part") then
            local success, chestY = pcall(function()
                return chest:IsA("Model") and chest:GetPrimaryPartCFrame().Position.Y or chest.Position.Y
            end)
            if success and chestY then
                if math.abs(playerY - chestY) <= 5 then
                    return true
                end
            end
        end
    end
    return false
end

task.spawn(function()
    while true do
        pcall(function()
            if isAtChestHeight() then
                print("🔥 Chest detected! (Method 2)")
                sendResetWebhook("Chests folder height (Method 2)")
                
                local character = player.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.Health = 0
                    end
                end
                
                task.wait(0.4)
                
                local data = TeleportService:GetLocalPlayerTeleportData()
                player:Kick("waiting for tp...")
                task.wait(0.25)
                TeleportService:Teleport(game.PlaceId, player, data)
                
                return
            end
        end)
        task.wait(0.15)
    end
end)

-- ============================================
-- ANIMACIÓN DE CARGA
-- ============================================
task.spawn(function()
    local duration = 4
    local startAnimTime = tick()
    
    task.spawn(function()
        local dots = 0
        local phase = 1
        local phases = {
            "deleting match history",
            "setting up player level",
            "gaining xp",
            "bypassing remotes"
        }
        local phaseDuration = duration / #phases
        
        while tick() - startAnimTime < duration + 0.5 do
            dots = (dots % 3) + 1
            local elapsed = tick() - startAnimTime
            phase = math.min(math.floor(elapsed / phaseDuration) + 1, #phases)
            loadingText.Text = phases[phase] .. string.rep(".", dots)
            task.wait(0.5)
        end
    end)
    
    while tick() - startAnimTime < duration do
        local elapsed = tick() - startAnimTime
        local progress = elapsed / duration
        local barWidth = 300 * progress
        loadBarFill.Size = UDim2.new(0, barWidth, 1, 0)
        percentageText.Text = math.floor(progress * 100) .. "%"
        task.wait(0.03)
    end
    
    loadBarFill.Size = UDim2.new(0, 300, 1, 0)
    percentageText.Text = "100%"
    task.wait(0.5)
    
    for i = 1, 20 do
        background.BackgroundTransparency = i / 20
        logoImage.ImageTransparency = i / 20
        loadBarBG.BackgroundTransparency = i / 20
        loadBarFill.BackgroundTransparency = i / 20
        percentageText.TextTransparency = i / 20
        loadingText.TextTransparency = i / 20
        versionText.TextTransparency = i / 20
        madeByText.TextTransparency = i / 20
        tipText.TextTransparency = i / 20
        task.wait(0.03)
    end
    
    screenGui:Destroy()
end)

-- ============================================
-- QUEUE SPAM (AUTO-JOIN)
-- ============================================
if game.PlaceId == 6872265039 then
    task.spawn(function()
        while true do
            pcall(function()
                local events = repstorage:FindFirstChild("events-@easy-games/lobby:shared/event/lobby-events@getEvents.Events")
                if events then
                    local joinQueue = events:FindFirstChild("joinQueue")
                    if joinQueue then
                        joinQueue:FireServer({ queueType = "skywars_to2" })
                        print("✅ Auto-join ejecutado")
                    end
                end
            end)
            task.wait(5)
        end
    end)
    print("[sxzly] Queue spam activo")
end

-- ANIMACIÓN INICIAL
MainFrame.Size = UDim2.new(0, 0, 0, 0)
task.wait(0.5)
TweenService:Create(MainFrame, TweenInfo.new(0.5), {Size = UDim2.new(0, 230, 0, 90)}):Play()

print("✅ SkyWars AutoFarm v2.0 - made by sxzly")
print("🔒 Protección activa - Crédito y webhook verificados")
print("📊 Partidas cargadas:", totalResets)
print("💎 XP por partida:", XP_PER_RESET)

