local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local Data = player:WaitForChild("Data", 15)
local Level = Data:WaitForChild("Level")
local Beli = Data:WaitForChild("Beli")
local Fragments = Data:WaitForChild("Fragments")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local Remotes = RS:WaitForChild("Remotes")
local CommF = Remotes:WaitForChild("CommF_")

local function fireRemote(action, ...)
    pcall(function()
        CommF:InvokeServer(action, ...)
    end)
end

-- Tentar setar Pirates automaticamente (com retry)
task.spawn(function()
    task.wait(3)  -- Espera carregar um pouco
    local attempts = 0
    while attempts < 5 do
        pcall(function()
            fireRemote("SetTeam", "Pirates")
        end)
        task.wait(1.5)
        if player.Team and player.Team.Name == "Pirates" then
            break
        end
        attempts = attempts + 1
    end
end)

player.CharacterAdded:Connect(function(ch)
    character = ch
    humanoid = ch:WaitForChild("Humanoid")
    rootPart = ch:WaitForChild("HumanoidRootPart")
end)

-- Otimização gráfica
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 2
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") then v.Enabled = false end
end

local function detectAdmin(p)
    local n = p.Name:lower()
    if n:find("admin") or n:find("mod") or n:find("dev") or n:find("owner") 
    or p:GetAttribute("Admin") or p:FindFirstChild("AdminTag") then
        return true
    end
    return false
end

local function hopServer()
    local ok, data = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        ))
    end)
    if ok and data and data.data then
        for _, s in ipairs(data.data) do
            if s.playing < 6 and s.id ~= game.JobId then
                TS:TeleportToPlaceInstance(game.PlaceId, s.id)
                break
            end
        end
    end
end

Players.PlayerAdded:Connect(function(p)
    task.spawn(function()
        task.wait(1.2)
        if detectAdmin(p) then hopServer() end
    end)
end)

task.spawn(function()
    while task.wait(6) do
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and detectAdmin(p) then hopServer() break end
        end
    end
end)

task.spawn(function()
    while task.wait(1800) do hopServer() end
end)

-- Reset ao morrer (anti-softlock)
task.spawn(function()
    while task.wait(1.2) do
        pcall(function()
            if humanoid.Health <= 0 then
                humanoid:Destroy()
                Instance.new("Humanoid", character)
            end
        end)
    end
end)
local function getQuestInfo()
    local MyLevel = Level.Value
    local World1 = MyLevel < 700
    local World2 = MyLevel >= 700 and MyLevel < 1500
    local World3 = MyLevel >= 1500

    local Mon, LevelQuest, NameQuest, NameMon, CFrameQuest, CFrameMon

    if World1 then
        if MyLevel <= 9 then Mon = "Bandit" LevelQuest = 1 NameQuest = "BanditQuest1" NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059, 17, 1546) CFrameMon = CFrame.new(943, 45, 1562)
        elseif MyLevel <= 14 then Mon = "Monkey" LevelQuest = 1 NameQuest = "JungleQuest" NameMon = "Monkey"
            CFrameQuest = CFrame.new(-1598, 37, 153) CFrameMon = CFrame.new(-1524, 50, 37)
        elseif MyLevel <= 29 then Mon = "Gorilla" LevelQuest = 2 NameQuest = "JungleQuest" NameMon = "Gorilla"
            CFrameQuest = CFrame.new(-1598, 37, 153) CFrameMon = CFrame.new(-1128, 40, -451)
        elseif MyLevel <= 39 then Mon = "Pirate" LevelQuest = 1 NameQuest = "BuggyQuest1" NameMon = "Pirate"
            CFrameQuest = CFrame.new(-1140, 4, 3829) CFrameMon = CFrame.new(-1262, 40, 3905)
        elseif MyLevel <= 59 then Mon = "Brute" LevelQuest = 2 NameQuest = "BuggyQuest1" NameMon = "Brute"
            CFrameQuest = CFrame.new(-1140, 4, 3829) CFrameMon = CFrame.new(-976, 55, 4304)
        elseif MyLevel <= 74 then Mon = "Desert Bandit" LevelQuest = 1 NameQuest = "DesertQuest" NameMon = "Desert Bandit"
            CFrameQuest = CFrame.new(897, 6, 4389) CFrameMon = CFrame.new(924, 7, 4482)
        elseif MyLevel <= 89 then Mon = "Desert Officer" LevelQuest = 2 NameQuest = "DesertQuest" NameMon = "Desert Officer"
            CFrameQuest = CFrame.new(897, 6, 4389) CFrameMon = CFrame.new(1608, 9, 4371)
        elseif MyLevel <= 99 then Mon = "Snow Bandit" LevelQuest = 1 NameQuest = "SnowQuest" NameMon = "Snow Bandit"
            CFrameQuest = CFrame.new(1385, 87, -1298) CFrameMon = CFrame.new(1362, 120, -1531)
        elseif MyLevel <= 119 then Mon = "Snowman" LevelQuest = 2 NameQuest = "SnowQuest" NameMon = "Snowman"
            CFrameQuest = CFrame.new(1385, 87, -1298) CFrameMon = CFrame.new(1243, 140, -1437)
        elseif MyLevel <= 149 then Mon = "Chief Petty Officer" LevelQuest = 1 NameQuest = "MarineQuest2" NameMon = "Chief Petty Officer"
            CFrameQuest = CFrame.new(-5035, 29, 4326) CFrameMon = CFrame.new(-4881, 23, 4274)
        elseif MyLevel <= 174 then Mon = "Sky Bandit" LevelQuest = 1 NameQuest = "SkyQuest" NameMon = "Sky Bandit"
            CFrameQuest = CFrame.new(-4844, 718, -2621) CFrameMon = CFrame.new(-4953, 296, -2899)
        elseif MyLevel <= 189 then Mon = "Dark Master" LevelQuest = 2 NameQuest = "SkyQuest" NameMon = "Dark Master"
            CFrameQuest = CFrame.new(-4844, 718, -2621) CFrameMon = CFrame.new(-5260, 391, -2229)
        elseif MyLevel <= 209 then Mon = "Prisoner" LevelQuest = 1 NameQuest = "PrisonerQuest" NameMon = "Prisoner"
            CFrameQuest = CFrame.new(5306, 2, 477) CFrameMon = CFrame.new(5099, 0, 474)
        elseif MyLevel <= 249 then Mon = "Dangerous Prisoner" LevelQuest = 2 NameQuest = "PrisonerQuest" NameMon = "Dangerous Prisoner"
            CFrameQuest = CFrame.new(5306, 2, 477) CFrameMon = CFrame.new(5655, 16, 866)
        elseif MyLevel <= 274 then Mon = "Toga Warrior" LevelQuest = 1 NameQuest = "ColosseumQuest" NameMon = "Toga Warrior"
            CFrameQuest = CFrame.new(-1581, 7, -2982) CFrameMon = CFrame.new(-1820, 51, -2741)
        elseif MyLevel <= 299 then Mon = "Gladiator" LevelQuest = 2 NameQuest = "ColosseumQuest" NameMon = "Gladiator"
            CFrameQuest = CFrame.new(-1581, 7, -2982) CFrameMon = CFrame.new(-1268, 30, -2996)
        elseif MyLevel <= 324 then Mon = "Military Soldier" LevelQuest = 1 NameQuest = "MagmaQuest" NameMon = "Military Soldier"
            CFrameQuest = CFrame.new(-5319, 12, 8515) CFrameMon = CFrame.new(-5335, 46, 8638)
        elseif MyLevel <= 374 then Mon = "Military Spy" LevelQuest = 2 NameQuest = "MagmaQuest" NameMon = "Military Spy"
            CFrameQuest = CFrame.new(-5319, 12, 8515) CFrameMon = CFrame.new(-5803, 86, 8829)
        elseif MyLevel <= 399 then Mon = "Fishman Warrior" LevelQuest = 1 NameQuest = "FishmanQuest" NameMon = "Fishman Warrior"
            CFrameQuest = CFrame.new(61122, 18, 1567) CFrameMon = CFrame.new(60998, 50, 1534)
        elseif MyLevel <= 449 then Mon = "Fishman Commando" LevelQuest = 2 NameQuest = "FishmanQuest" NameMon = "Fishman Commando"
            CFrameQuest = CFrame.new(61122, 18, 1567) CFrameMon = CFrame.new(61866, 55, 1655)
        elseif MyLevel <= 474 then Mon = "God's Guard" LevelQuest = 1 NameQuest = "SkyExp1Quest" NameMon = "God's Guard"
            CFrameQuest = CFrame.new(-4720, 846, -1951) CFrameMon = CFrame.new(-4720, 846, -1951)
        elseif MyLevel <= 524 then Mon = "Shanda" LevelQuest = 2 NameQuest = "SkyExp1Quest" NameMon = "Shanda"
            CFrameQuest = CFrame.new(-7861, 5545, -381) CFrameMon = CFrame.new(-7741, 5580, -395)
        elseif MyLevel <= 549 then Mon = "Royal Squad" LevelQuest = 1 NameQuest = "SkyExp2Quest" NameMon = "Royal Squad"
            CFrameQuest = CFrame.new(-7903, 5636, -1412) CFrameMon = CFrame.new(-7727, 5650, -1410)
        elseif MyLevel <= 624 then Mon = "Royal Soldier" LevelQuest = 2 NameQuest = "SkyExp2Quest" NameMon = "Royal Soldier"
            CFrameQuest = CFrame.new(-7903, 5636, -1412) CFrameMon = CFrame.new(-7894, 5640, -1629)
        elseif MyLevel <= 649 then Mon = "Galley Pirate" LevelQuest = 1 NameQuest = "FountainQuest" NameMon = "Galley Pirate"
            CFrameQuest = CFrame.new(5258, 39, 4052) CFrameMon = CFrame.new(5391, 70, 4023)
        elseif MyLevel >= 650 then Mon = "Galley Captain" LevelQuest = 2 NameQuest = "FountainQuest" NameMon = "Galley Captain"
            CFrameQuest = CFrame.new(5258, 39, 4052) CFrameMon = CFrame.new(5985, 70, 4790)
        end
    elseif World2 then
        -- (continua na próxima parte - World2 e World3)
        -- (continuação World3 - adicione o restante conforme sua versão anterior, ex: até Grand Devotee)
        -- Exemplo final:
        elseif MyLevel >= 2725 then Mon = "Grand Devotee" LevelQuest = 2 NameQuest = "SubmergedQuest3" NameMon = "Grand Devotee"
            CFrameQuest = CFrame.new(9636.52441, -1992.19507, 9609.52832) CFrameMon = CFrame.new(9557.5849609375, -1928.0404052734375, 9859.1826171875)
        end
    end

    return Mon, LevelQuest, NameQuest, NameMon, CFrameQuest, CFrameMon
end

local FSOrder = { -- mesma lista de antes...
    -- (copie sua FSOrder original aqui - Dark Step, Electric, etc.)
}

local currentMelee = "Combat"

-- Auto buy fighting styles (mantido)
task.spawn(function()
    while task.wait(6) do
        -- (seu código de buy FS e Godhuman aqui - igual ao anterior)
    end
end)

-- Farm Quest + Ataque melhorado
task.spawn(function()
    while task.wait(0.4) do
        pcall(function()
            local Mon, LvlQ, NQ, NM, CQ, CM = getQuestInfo()
            if not Mon then return end

            local questGui = player.PlayerGui:FindFirstChild("Main") and player.PlayerGui.Main:FindFirstChild("Quest")
            local hasCorrectQuest = questGui and questGui.Visible and questGui.Title.Text:find(NQ or "")

            if not hasCorrectQuest then
                rootPart.CFrame = CQ * CFrame.new(0, -3, 5)
                task.wait(0.7)
                fireRemote("StartQuest", NQ, LvlQ)
                task.wait(1.2)
            end

            -- Posição no mob + offset aleatório
            local offset = Vector3.new(math.random(-35,35), 0, math.random(-35,35))
            rootPart.CFrame = CM * CFrame.new(0, 50, 0) * CFrame.new(offset)

            -- Lock nos mobs da quest
            for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                if enemy.Name == NM and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                    enemy.HumanoidRootPart.CFrame = rootPart.CFrame * CFrame.new(0, -20, math.random(-5,5))
                    enemy.HumanoidRootPart.CanCollide = false
                    enemy.Humanoid.WalkSpeed = 0
                end
            end

            -- Equipar melee atual
            local tool = player.Backpack:FindFirstChild(currentMelee)
            if tool and not character:FindFirstChild(currentMelee) then
                humanoid:EquipTool(tool)
            end

            -- Ataque simples (M1 + click no céu)
            if character:FindFirstChild(currentMelee) then
                VirtualUser:ClickButton1(Vector2.new())
                task.wait(0.08)
            end
        end)
    end
end)

-- Auto store fruits (mantido)
task.spawn(function()
    while task.wait(2) do
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Tool") and obj:FindFirstChild("Handle") and (obj.Name:lower():find("fruit") or obj.Name:lower():find("devil")) then
                pcall(function()
                    obj.Parent = player.Backpack
                    fireRemote("StoreFruit", obj.Name, obj.Handle)
                end)
            end
        end
    end
end)
-- UI Dodge Hub com Loading
local sg = Instance.new("ScreenGui")
sg.Name = "DodgeHubUI"
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui")

-- Frame de Loading
local loadFrame = Instance.new("Frame")
loadFrame.Size = UDim2.new(0, 320, 0, 140)
loadFrame.Position = UDim2.new(0.5, -160, 0.5, -70)
loadFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
loadFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
loadFrame.BorderSizePixel = 3
loadFrame.Parent = sg

local loadTitle = Instance.new("TextLabel")
loadTitle.Size = UDim2.new(1, 0, 0, 50)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = "Dodge Hub Carregando..."
loadTitle.TextColor3 = Color3.fromRGB(0, 220, 255)
loadTitle.Font = Enum.Font.GothamBlack
loadTitle.TextSize = 32
loadTitle.Parent = loadFrame

local loadBar = Instance.new("Frame")
loadBar.Size = UDim2.new(0.85, 0, 0, 20)
loadBar.Position = UDim2.new(0.075, 0, 0.65, 0)
loadBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
loadBar.Parent = loadFrame

local fill = Instance.new("Frame")
fill.Size = UDim2.new(0, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
fill.Parent = loadBar

-- Simula loading (0% → 100% em ~5s)
task.spawn(function()
    for i = 0, 100, 2 do
        fill.Size = UDim2.new(i/100, 0, 1, 0)
        task.wait(0.08)
    end
    task.wait(0.6)
    loadFrame:Destroy()
end)

-- Frame principal após loading
task.wait(5.5)  -- Espera loading acabar

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 360)
frame.Position = UDim2.new(0.5, -150, 0.5, -180)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 32)
frame.BorderColor3 = Color3.fromRGB(0, 200, 255)
frame.BorderSizePixel = 2
frame.Parent = sg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
title.Text = "Dodge Hub"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBlack
title.TextSize = 28
title.Parent = frame

local labels = {}

local items = {
    {"God Human", "Godhuman"},
    {"CDK", "Cursed Dual Katana"},
    {"Soul Guitar", "Soul Guitar"},
    {"Valkyrie Helm", "Valkyrie Helm"},
    {"Mirror Fractal", nil}
}

for i, data in ipairs(items) do
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.92, 0, 0, 30)
    lbl.Position = UDim2.new(0.04, 0, 0.14 + (i-1)*0.09, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextColor3 = Color3.fromRGB(200, 220, 255)
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 17
    lbl.Text = data[1] .. ": 🔴"
    lbl.Parent = frame
    labels[data[1]] = lbl
end

local beliLbl = Instance.new("TextLabel")
beliLbl.Size = UDim2.new(0.92, 0, 0, 30)
beliLbl.Position = UDim2.new(0.04, 0, 0.62, 0)
beliLbl.BackgroundTransparency = 1
beliLbl.TextXAlignment = Enum.TextXAlignment.Left
beliLbl.TextColor3 = Color3.fromRGB(255, 215, 0)
beliLbl.Font = Enum.Font.GothamSemibold
beliLbl.TextSize = 17
beliLbl.Text = "Beli: 0"
beliLbl.Parent = frame
labels["Beli"] = beliLbl

local fragLbl = Instance.new("TextLabel")
fragLbl.Size = UDim2.new(0.92, 0, 0, 30)
fragLbl.Position = UDim2.new(0.04, 0, 0.71, 0)
fragLbl.BackgroundTransparency = 1
fragLbl.TextXAlignment = Enum.TextXAlignment.Left
fragLbl.TextColor3 = Color3.fromRGB(150, 200, 255)
fragLbl.Font = Enum.Font.GothamSemibold
fragLbl.TextSize = 17
fragLbl.Text = "Fragments: 0"
fragLbl.Parent = frame
labels["Fragments"] = fragLbl

-- Atualiza status
task.spawn(function()
    while task.wait(1.8) do
        pcall(function()
            local bp = player.Backpack
            local char = character

            labels["God Human"].Text = "God Human: " .. ((bp:FindFirstChild("Godhuman") or char:FindFirstChild("Godhuman")) and "🟢" or "🔴")
            labels["CDK"].Text = "CDK: " .. ((bp:FindFirstChild("Cursed Dual Katana") or char:FindFirstChild("Cursed Dual Katana")) and "🟢" or "🔴")
            labels["Soul Guitar"].Text = "Soul Guitar: " .. ((bp:FindFirstChild("Soul Guitar") or char:FindFirstChild("Soul Guitar")) and "🟢" or "🔴")
            labels["Valkyrie Helm"].Text = "Valkyrie Helm: " .. ((bp:FindFirstChild("Valkyrie Helm") or char:FindFirstChild("Valkyrie Helm")) and "🟢" or "🔴")
            labels["Mirror Fractal"].Text = "Mirror Fractal: " .. (Fragments.Value >= 5000 and "🟢" or "🔴")

            labels["Beli"].Text = "Beli: " .. tostring(Beli.Value or 0)
            labels["Fragments"].Text = "Fragments: " .. tostring(Fragments.Value or 0)
        end)
    end
end)
