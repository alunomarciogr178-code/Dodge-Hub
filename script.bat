local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local Data = player:WaitForChild("Data")
local Level = Data:WaitForChild("Level")
local Beli = Data:WaitForChild("Beli")
local Fragments = Data:WaitForChild("Fragments")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local Remotes = RS:WaitForChild("Remotes")
local CommF = Remotes:WaitForChild("CommF_")

local function fireRemote(action, ...)
    pcall(CommF.InvokeServer, CommF, action, ...)
end

player.CharacterAdded:Connect(function(ch)
    character = ch
    humanoid = ch:WaitForChild("Humanoid")
    rootPart = ch:WaitForChild("HumanoidRootPart")
end)

Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 2
settings().Rendering.QualityLevel = "Level01"
RunService:Set3dRenderingEnabled(false)
for _,v in pairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") then v.Enabled = false end
end

fireRemote("SetTeam", "Marines")

local scriptConfig = { inSea2 = false }

local function detectAdmin(p)
    local n = p.Name:lower()
    if n:find("admin") or n:find("mod") or n:find("dev") or n:find("owner") or p:GetAttribute("Admin") or p:FindFirstChild("AdminTag") then
        return true
    end
    return false
end

local function hopServer()
    local ok, data = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if ok and data and data.data then
        for _,s in ipairs(data.data) do
            if s.playing and s.playing < 6 and s.id ~= game.JobId then
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
        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= player and detectAdmin(p) then hopServer() break end
        end
    end
end)

task.spawn(function()
    while task.wait(1800) do hopServer() end
end)

task.spawn(function()
    while task.wait(1.4) do
        if humanoid.Health <= 0 then
            pcall(function()
                humanoid:Destroy()
                Instance.new("Humanoid", character)
            end)
        end
    end
end)

local levelFarms = {
    {min=1,   max=15,   quest={"CitizenQuest",1},     mobs={"Bandit"}},
    {min=15,  max=30,   quest={"MilitarySoldierQuest",1}, mobs={"Marine Soldier"}},
    {min=30,  max=60,   quest={"MonkeyQuest",1},      mobs={"Monkey"}},
    {min=60,  max=90,   quest={"GorillaQuest",1},     mobs={"Gorilla"}},
    {min=90,  max=120,  quest={"JungleQuest",1},      mobs={"Jungle Pirate"}},
    {min=120, max=150,  quest={"PirateQuest",1},      mobs={"Pirate"}},
    {min=150, max=200,  quest={"DesertQuest",1},      mobs={"Desert Bandit"}},
    {min=200, max=250,  quest={"SnowBanditQuest",1},  mobs={"Snow Bandit"}},
    {min=250, max=300,  quest={"SnowmanQuest",1},     mobs={"Snowman"}},
    {min=300, max=375,  quest={"ChiefPettyQuest",1},  mobs={"Chief Petty Officer"}},
    {min=375, max=450,  quest={"SkyBanditQuest",1},   mobs={"Sky Bandit"}},
    {min=450, max=575,  quest={"PrisonerQuest",1},    mobs={"Prisoner"}},
    {min=575, max=700,  quest={"DangerousPrisonerQuest",1}, mobs={"Dangerous Prisoner"}},
    {min=700, max=850,  quest={"ColosseumQuest",1},   mobs={"Gladiator"}},
    {min=850, max=1000, quest={"RaiderQuest",1},      mobs={"Raider"}},
    {min=1000,max=1100, quest={"LivingZombieQuest",1}, mobs={"Living Zombie"}},
    {min=1100,max=1250, quest={"DemonicWispQuest",1}, mobs={"Demonic Wisp"}},
    {min=1250,max=1350, quest={"SeaSoldierQuest",1},  mobs={"Sea Soldier"}},
    {min=1350,max=1500, quest={"FishmanWarriorQuest",1}, mobs={"Fishman Warrior"}},
    {min=1500,max=1575, quest={"FishmanCaptainQuest",1}, mobs={"Fishman Captain"}},
    {min=1575,max=1625, quest={"SharkmanQuest",1},    mobs={"Sharkman"}},
    {min=1625,max=1675, quest={"MythicalPirateQuest",1}, mobs={"Mythical Pirate"}},
    {min=1675,max=1750, quest={"PirateMillionaireQuest",1}, mobs={"Pirate Millionaire"}},
    {min=1750,max=1825, quest={"DragonCrewWarriorQuest",1}, mobs={"Dragon Crew Warrior"}},
    {min=1825,max=1900, quest={"CastleOnTheSeaQuest",1}, mobs={"Pirate Millionaire"}},
    {min=1500,max=2000, quest={"PortTownQuest",1},    mobs={"Pirate Brute"}},
    {min=2000,max=2075, quest={"HydraQuest",1},       mobs={"Sea Soldier"}},
    {min=2075,max=2150, quest={"FloatingTurtleQuest",1}, mobs={"Pirate Brigade"}},
    {min=2150,max=2250, quest={"HauntedCastleQuest",1}, mobs={"Reborn Skeleton"}},
    {min=2250,max=2375, quest={"SeaOfTreatsQuest",1}, mobs={"Cake Minion"}},
    {min=2375,max=2450, quest={"TikiOutpostQuest",1}, mobs={"Isle Outlaw"}},
    {min=2450,max=2550, quest={"FloatingTurtleQuest",2}, mobs={"Pirate Millionaire"}},
    {min=2550,max=2650, quest={"MansionQuest",4},     mobs={"Mansion Guard"}},
    {min=2650,max=2750, quest={"CursedShipQuest",2},  mobs={"Cursed Pirate"}},
    {min=2750,max=2800, quest={"UsoppPartyQuest",1},  mobs={"Usopp Party Member"}}
}

task.spawn(function()
    while task.wait(3.5) do
        local lv = Level.Value

        for _, farm in ipairs(levelFarms) do
            if lv >= farm.min and lv <= farm.max then
                fireRemote("StartQuest", farm.quest[1], farm.quest[2])

                local pos
                if lv <= 700 then
                    pos = Vector3.new(950, 100, 950)
                elseif lv <= 1500 then
                    pos = Vector3.new(-5000, 300, -5000)
                else
                    pos = Vector3.new(-12000, 300, -8000)
                end
                rootPart.CFrame = CFrame.new(pos + Vector3.new(math.random(-150,150), 0, math.random(-150,150)))

                pcall(function()
                    for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
                        local n = enemy.Name:lower()
                        for _, m in ipairs(farm.mobs) do
                            if n:find(m:lower()) and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                rootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0)
                                break
                            end
                        end
                    end
                end)
                break
            end
        end
    end
end)

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
        for _, t in ipairs(player.Backpack:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():find("fruit") then
                fireRemote("StoreFruit", t.Name, t.Handle)
            end
        end
    end
end)

local sg = Instance.new("ScreenGui")
sg.Name = "DodgeHubMini"
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 260, 0, 240)
main.Position = UDim2.new(0.01, 0, 0.28, 0)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 32)
main.BorderColor3 = Color3.fromRGB(255, 200, 60)
main.BorderSizePixel = 2
main.Parent = sg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,35)
title.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
title.Text = "Dodge Hub"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBlack
title.TextSize = 22
title.Parent = main

local doge = Instance.new("ImageLabel")
doge.Size = UDim2.new(1,0,1,0)
doge.BackgroundTransparency = 1
doge.ImageTransparency = 0.70
doge.Image = "rbxassetid://148947938"
doge.Parent = main

local stats = {
    {"Beli", Beli},
    {"Fragments", Fragments},
    {"God Human", "❌"},
    {"Cursed Dual Katana", "❌"},
    {"Soul Guitar", "❌"},
    {"Mirror Fractal", "❌"},
    {"Valkyrie Helm", "❌"}
}

local lbls = {}
for i, item in ipairs(stats) do
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.92, 0, 0, 24)
    lbl.Position = UDim2.new(0.04, 0, 0.20 + (i-1)*0.085, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextColor3 = Color3.fromRGB(220,220,255)
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 14
    lbl.Text = item[1] .. ": carregando..."
    lbl.Parent = main
    lbls[item[1]] = lbl
end

task.spawn(function()
    while task.wait(2.5) do
        lbls["Beli"].Text       = "Beli: " .. Beli.Value
        lbls["Fragments"].Text  = "Fragments: " .. Fragments.Value

        local bp = player.Backpack
        local char = character

        lbls["God Human"].Text          = "God Human: " .. (bp:FindFirstChild("Godhuman") or char:FindFirstChild("Godhuman") and "✅" or "❌")
        lbls["Cursed Dual Katana"].Text = "Cursed Dual Katana: " .. (bp:FindFirstChild("Cursed Dual Katana") or char:FindFirstChild("Cursed Dual Katana") and "✅" or "❌")
        lbls["Soul Guitar"].Text        = "Soul Guitar: " .. (bp:FindFirstChild("Soul Guitar") or char:FindFirstChild("Soul Guitar") and "✅" or "❌")
        lbls["Mirror Fractal"].Text     = "Mirror Fractal: " .. (Fragments.Value >= 5000 and "provável" or "❌")
        lbls["Valkyrie Helm"].Text      = "Valkyrie Helm: " .. (bp:FindFirstChild("Valkyrie Helm") or char:FindFirstChild("Valkyrie Helm") and "✅" or "❌")
    end
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/alunomarciogr178-code/Dodge-Hub/33bb22c15b0d30abef02caf73f737bede661febc/script.bat"))()
