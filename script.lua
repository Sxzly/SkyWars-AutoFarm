repeat task.wait() until game:IsLoaded()

-- ============================================
-- PROTECCIÓN AÑADIDA (SOLO ESTO ES NUEVO)
-- ============================================
local OWNER = "sxzly"
local WEBHOOK = "https://discord.com/api/webhooks/1497095716437229700/a6LGFiPCpYDCLcekYG15mmcw_lWuReLQdvTVJeeA1ylyByJdhBuOAk40lDdzcm1mqwjs"

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

-- WEBHOOK DE DISCORD
local webhookURL = WEBHOOK

-- ============================================
-- ARCHIVOS DE GUARDADO (con nombre único para SkyWars)
-- ============================================
local RESETS_FILE = "skywars_sxzly_resets.txt"
local XP_FILE = "skywars_sxzly_xp.txt"

local totalResets = 0
local totalXP = 0
local XP_PER_RESET = 600
local startTime = os.time()

if isfile and readfile then
    pcall(function() totalResets = tonumber(readfile(RESETS_FILE)) or 0 end)
    pcall(function() totalXP = tonumber(readfile(XP_FILE)) or 0 end)
end

local function saveData()
    if writefile then
        pcall(function()
            writefile(RESETS_FILE, tostring(totalResets))
            writefile(XP_FILE, tostring(totalXP))
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
                        {["name"] = "📍 Reason", ["value"] = reason or "Chest height detected", ["inline"] = false},
                        {["name"] = "🎮 Game", ["value"] = "SkyWars", ["inline"] = true}
                    },
                    ["footer"] = {["text"] = "made by sxzly"},
                    ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S")
                }}
            }
            request({Url = webhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = httpService:JSONEncode(embed)})
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
MainFrame.Size = UDim2.new(0, 230, 0, 95)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

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

local resetsLabel = Instance.new("TextLabel")
resetsLabel.Parent = MainFrame
resetsLabel.Position = UDim2.new(0, 10, 0, 28)
resetsLabel.Size = UDim2.new(1, -20, 0, 28)
resetsLabel.BackgroundTransparency = 1
resetsLabel.Font = Enum.Font.GothamBold
resetsLabel.Text = "🏆 " .. totalResets
resetsLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
resetsLabel.TextSize = 18

local xpPerMatchLabel = Instance.new("TextLabel")
xpPerMatchLabel.Parent = MainFrame
xpPerMatchLabel.Position = UDim2.new(0, 10, 0, 56)
xpPerMatchLabel.Size = UDim2.new(1, -20, 0, 18)
xpPerMatchLabel.BackgroundTransparency = 1
xpPerMatchLabel.Font = Enum.Font.Gotham
xpPerMatchLabel.Text = "💎 +" .. XP_PER_RESET .. " XP"
xpPerMatchLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
xpPerMatchLabel.TextSize = 11

local timerLabel = Instance.new("TextLabel")
timerLabel.Parent = MainFrame
timerLabel.Position = UDim2.new(0, 10, 0, 74)
timerLabel.Size = UDim2.new(1, -20, 0, 14)
timerLabel.BackgroundTransparency = 1
timerLabel.Font = Enum.Font.Gotham
timerLabel.Text = "⏱️ " .. getElapsedTime()
timerLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
timerLabel.TextSize = 10

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
background.Position = UDim2.new(0, 0, 0, 0)
background.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
background.BorderSizePixel = 0
background.ZIndex = 1
background.Parent = screenGui

local logoImage = Instance.new("ImageLabel")
logoImage.Size = UDim2.new(0, 200, 0, 200)
logoImage.Position = UDim2.new(0.5, -100, 0.5, -150)
logoImage.BackgroundTransparency = 1
logoImage.Image = "rbxassetid://127677235878436"
logoImage.ZIndex = 2
logoImage.Parent = background

local logoGlow = Instance.new("ImageLabel")
logoGlow.Size = UDim2.new(0, 240, 0, 240)
logoGlow.Position = UDim2.new(0.5, -120, 0.5, -170)
logoGlow.BackgroundTransparency = 1
logoGlow.Image = "rbxassetid://127677235878436"
logoGlow.ImageTransparency = 0.92
logoGlow.ZIndex = 1
logoGlow.Parent = background

local logoGlowBlur = Instance.new("ImageLabel")
logoGlowBlur.Size = UDim2.new(1, 0, 1, 0)
logoGlowBlur.Position = UDim2.new(0, 0, 0, 0)
logoGlowBlur.BackgroundTransparency = 1
logoGlowBlur.Image = "rbxassetid://127677235878436"
logoGlowBlur.ImageColor3 = Color3.fromRGB(255, 255, 255)
logoGlowBlur.ImageTransparency = 0.95
logoGlowBlur.ZIndex = 1
logoGlowBlur.Parent = logoGlow

local loadBarBG = Instance.new("Frame")
loadBarBG.Size = UDim2.new(0, 300, 0, 3)
loadBarBG.Position = UDim2.new(0.5, -150, 0.5, 80)
loadBarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
loadBarBG.BorderSizePixel = 0
loadBarBG.ZIndex = 2
loadBarBG.Parent = background

local loadBarStroke = Instance.new("UIStroke")
loadBarStroke.Color = Color3.fromRGB(255, 255, 255)
loadBarStroke.Transparency = 0.8
loadBarStroke.Thickness = 1
loadBarStroke.Parent = loadBarBG

local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(0, 100, 0, 20)
versionText.Position = UDim2.new(1, -110, 1, -30)
versionText.BackgroundTransparency = 1
versionText.Text = "4.7.2"
versionText.TextColor3 = Color3.fromRGB(120, 120, 120)
versionText.Font = Enum.Font.Code
versionText.TextSize = 12
versionText.TextXAlignment = Enum.TextXAlignment.Right
versionText.ZIndex = 2
versionText.Parent = background

local madeByText = Instance.new("TextLabel")
madeByText.Size = UDim2.new(0, 200, 0, 20)
madeByText.Position = UDim2.new(0, 10, 1, -30)
madeByText.BackgroundTransparency = 1
madeByText.Text = "made by sxzly"
madeByText.TextColor3 = Color3.fromRGB(120, 120, 120)
madeByText.Font = Enum.Font.Code
madeByText.TextSize = 12
madeByText.TextXAlignment = Enum.TextXAlignment.Left
madeByText.ZIndex = 2
madeByText.Parent = background

local tipText = Instance.new("TextLabel")
tipText.Size = UDim2.new(0, 600, 0, 20)
tipText.Position = UDim2.new(0.5, -300, 1, -40)
tipText.BackgroundTransparency = 1
tipText.Text = "tip: you can always sleep while afk farming!"
tipText.TextColor3 = Color3.fromRGB(130, 130, 130)
tipText.Font = Enum.Font.Code
tipText.TextSize = 10
tipText.TextXAlignment = Enum.TextXAlignment.Center
tipText.ZIndex = 2
tipText.Parent = background

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(0, 400, 0, 30)
loadingText.Position = UDim2.new(0.5, -200, 0.5, 100)
loadingText.BackgroundTransparency = 1
loadingText.Text = "deleting match history"
loadingText.TextColor3 = Color3.fromRGB(200, 200, 200)
loadingText.Font = Enum.Font.Code
loadingText.TextSize = 14
loadingText.ZIndex = 2
loadingText.Parent = background

local percentageText = Instance.new("TextLabel")
percentageText.Size = UDim2.new(0, 100, 0, 20)
percentageText.Position = UDim2.new(0.5, -50, 0.5, 50)
percentageText.BackgroundTransparency = 1
percentageText.Text = "0%"
percentageText.TextColor3 = Color3.fromRGB(200, 200, 200)
percentageText.Font = Enum.Font.Code
percentageText.TextSize = 12
percentageText.TextXAlignment = Enum.TextXAlignment.Center
percentageText.ZIndex = 2
percentageText.Parent = background

local loadBarFill = Instance.new("Frame")
loadBarFill.Size = UDim2.new(0, 0, 1, 0)
loadBarFill.Position = UDim2.new(0, 0, 0, 0)
loadBarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
loadBarFill.BorderSizePixel = 0
loadBarFill.ZIndex = 3
loadBarFill.Parent = loadBarBG

-- ============================================
-- DETECCIÓN DE COFRES (EXACTAMENTE COMO EN TU ORIGINAL)
-- ============================================
local CHEST_NAME = "chest"
local HEIGHT_TOLERANCE = 2
local CHECK_INTERVAL = 0.1
local ENABLED = true

local hasTriggered = false
local isProcessing = false
local workspace = game:GetService("Workspace")

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
    
    if not nearestChest then
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                if obj.Name:lower():find(CHEST_NAME:lower()) then
                    local chestPos
                    if obj:IsA("Model") then
                        local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                        if primary then chestPos = primary.Position end
                    elseif obj:IsA("BasePart") then
                        chestPos = obj.Position
                    end
                    if chestPos then
                        local distance = (playerPos - chestPos).Magnitude
                        if distance < nearestDistance and distance < 100 then
                            nearestDistance = distance
                            nearestChest = obj
                        end
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

-- METHOD 1 (exactamente como en tu original)
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

-- METHOD 2 (exactamente como en tu original - con task.wait(0.4))
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
                
                task.wait(0.4)  -- ← ESTE ES EL TIEMPO CORRECTO (NO 0.3)
                
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
        logoGlow.ImageTransparency = 0.92 + (0.08 * i / 20)
        logoGlowBlur.ImageTransparency = 0.95 + (0.05 * i / 20)
        loadBarBG.BackgroundTransparency = i / 20
        loadBarFill.BackgroundTransparency = i / 20
        percentageText.TextTransparency = i / 20
        loadingText.TextTransparency = i / 20
        versionText.TextTransparency = i / 20
        madeByText.TextTransparency = i / 20
        tipText.TextTransparency = i / 20
        loadBarStroke.Transparency = 0.8 + (0.2 * i / 20)
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
                local events = repstorage:WaitForChild("events-@easy-games/lobby:shared/event/lobby-events@getEvents.Events", 5)
                if events then
                    local joinQueue = events:FindFirstChild("joinQueue")
                    if joinQueue then
                        joinQueue:FireServer({ queueType = "skywars_to2" })
                    end
                end
            end)
            task.wait(5)
        end
    end)
    print("[sxzly] Queue spam active")
else
    print("[sxzly] Not in lobby")
end

-- ANIMACIÓN INICIAL DE LA UI MODERNA
MainFrame.Size = UDim2.new(0, 0, 0, 0)
task.wait(0.5)
TweenService:Create(MainFrame, TweenInfo.new(0.5), {Size = UDim2.new(0, 230, 0, 95)}):Play()

print("✅ SkyWars AutoFarm v2.0 - made by sxzly")
print("🔒 Protección activa - Crédito y webhook verificados")
print("📊 Partidas cargadas:", totalResets)
print("💎 XP por partida:", XP_PER_RESET)
