local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()

local Window = OrionLib:MakeWindow({
    Name = "Nexus Hub | Blox Fruits Pro",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "NexusBloxFruitsPro"
})

_G.AutoFarm = false
_G.FastAttack = false
_G.AutoStats = false
_G.AutoChest = false
_G.ESPPlayers = false

local TabFarm = Window:MakeTab({Name = "Auto Farm", Icon = "rbxassetid://4483345998"})
local TabStats = Window:MakeTab({Name = "Stats", Icon = "rbxassetid://4483345999"})
local TabFruits = Window:MakeTab({Name = "Frutas & Gacha", Icon = "rbxassetid://4483345995"})
local TabTeleport = Window:MakeTab({Name = "Teleportes", Icon = "rbxassetid://4483345997"})
local TabMisc = Window:MakeTab({Name = "Misc & ESP", Icon = "rbxassetid://4483345996"})

TabFarm:AddToggle({
    Name = "Auto Farm Level (Quest + Ataque)",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        task.spawn(function()
            while _G.AutoFarm do
                task.wait()
                pcall(function()
                    local player = game.Players.LocalPlayer
                    local character = player.Character
                    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                    
                    local level = player.Data.Level.Value
                    local questVisible = player.PlayerGui.Main.Quest.Visible
                    
                    if not questVisible then
                        local questPos = CFrame.new(0, 0, 0)
                        local questName = ""
                        local questId = 1
                        
                        if level >= 1 and level <= 9 then
                            questPos = CFrame.new(1059.3, 16.9, 1549.5)
                            questName = "BanditQuest1"
                            questId = 1
                        elseif level >= 10 and level <= 14 then
                            questPos = CFrame.new(-1598.1, 36.8, 153.3)
                            questName = "JungleQuest"
                            questId = 1
                        end
                        
                        character.HumanoidRootPart.CFrame = questPos
                        task.wait(0.5)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", questName, questId)
                        task.wait(1)
                    else
                        for _, mob in pairs(workspace.Enemies:GetChildren()) do
                            if not _G.AutoFarm then break end
                            if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                                repeat
                                    task.wait()
                                    character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                                until not _G.AutoFarm or not mob.Parent or mob.Humanoid.Health <= 0 or not player.PlayerGui.Main.Quest.Visible
                            end
                        end
                    end
                end)
            end
        end)
    end
})

TabFarm:AddToggle({
    Name = "Fast Attack (Ataque Rápido)",
    Default = false,
    Callback = function(Value)
        _G.FastAttack = Value
        task.spawn(function()
            while _G.FastAttack do
                task.wait(0.1)
            end
        end)
    end
})

TabStats:AddToggle({
    Name = "Auto Distribuir Stats (Melee)",
    Default = false,
    Callback = function(Value)
        _G.AutoStats = Value
        task.spawn(function()
            while _G.AutoStats do
                task.wait(1)
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Melee", 3)
                end)
            end
        end)
    end
})

TabFruits:AddButton({
    Name = "Girar Fruta (Sem ir ao Zioles)",
    Callback = function()
        pcall(function()
            local args = {"Cousin"}
            local resposta = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        end)
    end
})

TabFruits:AddButton({
    Name = "Guardar Fruta Atual no Inventário (Store)",
    Callback = function()
        pcall(function()
            for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", v.Name)
                end
            end
        end)
    end
})

TabTeleport:AddButton({
    Name = "Ir para o Café (Second Sea)",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(386.5, 72.8, 318.5)
        end
    end
})

TabTeleport:AddButton({
    Name = "Ir para Mansão (Third Sea)",
    Callback = function()
        lcal player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(-12462.8, 374.9, -7551.5)
        end
    end
})

TabMisc:AddToggle({
    Name = "Auto Coletar Baús (Chest Farm)",
    Default = false,
    Callback = function(Value)
        _G.AutoChest = Value
        task.spawn(function()
            while _G.AutoChest do
                task.wait(0.5)
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj.Name:find("Chest") and obj:FindFirstChild("HumanoidRootPart") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = obj.HumanoidRootPart.CFrame
                    end
                end
            end
        end)
    end
})

OrionLib:Init()
