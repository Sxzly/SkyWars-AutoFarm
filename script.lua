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
-- EL RESTO ES TU SCRIPT ORIGINAL (SIN NINGÚN CAMBIO)
-- ============================================
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local httpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local repstorage = game:GetService("ReplicatedStorage")

-- WEBHOOK DE DISCORD (usando la variable protegida)
local webhookURL = WEBHOOK

-- Archivos de guardado
local RESETS_FILE = "skywars_resets.txt"
local XP_FILE = "skywars_xp.txt"

-- Variables de datos
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
    warn("⚠️ Your executor doesn't support file saving")
end

local function saveData()
    if writefile then
        pcall(function()
            writefile(RESETS_FILE, tostring(totalResets))
            writefile(XP_FILE, tostring(totalXP))
            print("💾 Data saved - Resets:", totalResets, "XP:", totalXP)
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
            request({Url = webhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = httpService:JSONEncode(embed)})
        end)
    end)
end

-- Create Loading Screen GUI
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

-- BALANCED SETTINGS
local CHEST_NAME = "chest"
local HEIGHT_TOLERANCE = 2
local CHECK_INTERVAL = 0.1
local ENABLED = true

local hasTriggered = false
local isProcessing = false
local workspace = game:GetService("Workspace")

-- Find nearest chest
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

-- Monitor chest height (Method 1)
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

-- Method 2
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

-- Loading animation
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

-- Queue spam
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

print("✅ SkyWars AutoFarm loaded!")
print("💾 Loaded Data:")
print("  - Total Resets:", totalResets)
print("  - Total XP:", totalXP)
print("  - XP per Reset:", XP_PER_RESET)
print("📝 made by sxzly")
