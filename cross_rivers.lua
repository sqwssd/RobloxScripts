local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
while not localPlayer do
    task.wait()
    localPlayer = Players.LocalPlayer
end

local globalEnv = (getgenv and getgenv()) or _G

if globalEnv.SqwssCrossRiversConnections then
    for _, conn in ipairs(globalEnv.SqwssCrossRiversConnections) do
        pcall(function() conn:Disconnect() end)
    end
end
globalEnv.SqwssCrossRiversConnections = {}

if globalEnv.SqwssCrossRiversThreads then
    for _, thread in ipairs(globalEnv.SqwssCrossRiversThreads) do
        pcall(function() task.cancel(thread) end)
    end
end
globalEnv.SqwssCrossRiversThreads = {}

local function cleanupAll()
    if globalEnv.SqwssCrossRiversConnections then
        for _, conn in ipairs(globalEnv.SqwssCrossRiversConnections) do
            pcall(function() conn:Disconnect() end)
        end
    end
    if globalEnv.SqwssCrossRiversThreads then
        for _, thread in ipairs(globalEnv.SqwssCrossRiversThreads) do
            pcall(function() task.cancel(thread) end)
        end
    end
    
    pcall(function()
        local char = localPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            if hrp:FindFirstChild("SqwssFlyBV") then hrp.SqwssFlyBV:Destroy() end
            if hrp:FindFirstChild("SqwssFlyBG") then hrp.SqwssFlyBG:Destroy() end
        end
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = false
        end
    end)
    
    pcall(function()
        local screenGui = CoreGui:FindFirstChild("SqwssCrossRiversHub") or localPlayer:WaitForChild("PlayerGui"):FindFirstChild("SqwssCrossRiversHub")
        if screenGui then screenGui:Destroy() end
    end)
end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Sqwss Hub | Cross Rivers for Brainrots!",
    SubTitle = "by sqwss",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main Hacks", Icon = "home" }),
    Farming = Window:AddTab({ Title = "Auto Farm", Icon = "refresh-cw" }),
    Teleports = Window:AddTab({ Title = "Teleports", Icon = "map-pin" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local autoFarm = false
local autoBuyPads = false
local autoUpgradeSpeed = false
local autoUpgradeCarry = false
local autoRebirth = false
local autoSlap = false

local customSpeed = 16
local customJump = 50
local speedEnabled = false
local jumpEnabled = false
local infJumpEnabled = false
local noclip = false

local flyEnabled = false
local flySpeed = 50
local keys = {w = false, s = false, a = false, d = false, q = false, e = false}

Tabs.Main:AddToggle("SpeedToggle", { Title = "Enable WalkSpeed Modifier", Default = false }):OnChanged(function(v)
    speedEnabled = v
end)

Tabs.Main:AddSlider("SpeedSlider", {
    Title = "WalkSpeed Limit",
    Min = 16,
    Max = 500,
    Default = 16,
    Rounding = 0,
    Callback = function(v)
        customSpeed = v
    end
})

Tabs.Main:AddToggle("JumpToggle", { Title = "Enable JumpPower Modifier", Default = false }):OnChanged(function(v)
    jumpEnabled = v
end)

Tabs.Main:AddSlider("JumpSlider", {
    Title = "JumpPower Limit",
    Min = 50,
    Max = 500,
    Default = 50,
    Rounding = 0,
    Callback = function(v)
        customJump = v
    end
})

Tabs.Main:AddToggle("NoclipToggle", { Title = "Noclip", Default = false }):OnChanged(function(v)
    noclip = v
end)

Tabs.Main:AddToggle("InfJumpToggle", { Title = "Infinite Jump", Default = false }):OnChanged(function(v)
    infJumpEnabled = v
end)

Tabs.Main:AddToggle("FlyToggle", { Title = "Fly Mode", Default = false }):OnChanged(function(v)
    flyEnabled = v
    
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    
    if flyEnabled then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "SqwssFlyBV"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = hrp
        
        local bg = Instance.new("BodyGyro")
        bg.Name = "SqwssFlyBG"
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = hrp.CFrame
        bg.Parent = hrp
        
        hum.PlatformStand = true
    else
        if hrp:FindFirstChild("SqwssFlyBV") then hrp.SqwssFlyBV:Destroy() end
        if hrp:FindFirstChild("SqwssFlyBG") then hrp.SqwssFlyBG:Destroy() end
        hum.PlatformStand = false
    end
end)

Tabs.Main:AddSlider("FlySpeedSlider", {
    Title = "Fly Speed",
    Min = 10,
    Max = 300,
    Default = 50,
    Rounding = 0,
    Callback = function(v)
        flySpeed = v
    end
})

Tabs.Farming:AddToggle("AutoFarmToggle", { Title = "Auto Grab & Sell Brainrots", Default = false }):OnChanged(function(v)
    autoFarm = v
end)

Tabs.Farming:AddToggle("AutoBuyPadsToggle", { Title = "Auto Buy Tycoon Buttons", Default = false }):OnChanged(function(v)
    autoBuyPads = v
end)

Tabs.Farming:AddToggle("AutoUpgradeSpeedToggle", { Title = "Auto Upgrade Speed (+10 Speed)", Default = false }):OnChanged(function(v)
    autoUpgradeSpeed = v
end)

Tabs.Farming:AddToggle("AutoUpgradeCarryToggle", { Title = "Auto Upgrade Carry Capacity", Default = false }):OnChanged(function(v)
    autoUpgradeCarry = v
end)

Tabs.Farming:AddToggle("AutoRebirthToggle", { Title = "Auto Rebirth", Default = false }):OnChanged(function(v)
    autoRebirth = v
end)

Tabs.Farming:AddToggle("AutoSlapToggle", { Title = "Auto Slap Nearby Players", Default = false }):OnChanged(function(v)
    autoSlap = v
end)

local function getMyPlot()
    local name = localPlayer.Name
    local plots = workspace:FindFirstChild("MainGame") and workspace.MainGame:FindFirstChild("Plots")
    if plots then
        for _, plot in ipairs(plots:GetChildren()) do
            local ownerTxt = plot:FindFirstChild("PlotOwner", true) and plot.PlotOwner:FindFirstChild("NameTxt", true)
            if ownerTxt and ownerTxt:IsA("TextLabel") and (ownerTxt.Text == name or ownerTxt.Text:find(name)) then
                return plot
            end
        end
    end
    return nil
end

local function teleportToMyPlot()
    local plot = getMyPlot()
    local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if plot and hrp then
        hrp.CFrame = plot.Home.CFrame + Vector3.new(0, 5, 0)
    end
end

Tabs.Teleports:AddButton({
    Title = "Teleport to Tycoon Base",
    Description = "Teleports you directly onto your base.",
    Callback = teleportToMyPlot
})

Tabs.Teleports:AddButton({
    Title = "Teleport to Spawn / Lobby",
    Description = "Teleports you to the main map spawn.",
    Callback = function()
        local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(2787, 85, 60)
        end
    end
})

local function addZoneTeleport(name, labelText)
    local zones = workspace:FindFirstChild("MainGame") and workspace.MainGame:FindFirstChild("Zones")
    if zones then
        for _, zone in ipairs(zones:GetChildren()) do
            local title = zone:FindFirstChild("Title", true) or zone:FindFirstChildWhichIsA("TextLabel", true)
            if title and title.Text == name then
                Tabs.Teleports:AddButton({
                    Title = "Teleport to " .. labelText,
                    Description = "Teleports you to the " .. labelText .. " zone.",
                    Callback = function()
                        local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.CFrame = zone:GetPivot() + Vector3.new(0, 5, 0)
                        end
                    end
                })
                break
            end
        end
    end
end

addZoneTeleport("COMMON AREA", "Common Area")
addZoneTeleport("UNCOMMON AREA", "Uncommon Area")
addZoneTeleport("RARE AREA", "Rare Area")
addZoneTeleport("EPIC AREA", "Epic Area")
addZoneTeleport("LEGENDARY AREA", "Legendary Area")
addZoneTeleport("GODLY AREA", "Godly Area")
addZoneTeleport("SECRET AREA", "Secret Area")
addZoneTeleport("DIVINE AREA", "Divine Area")
addZoneTeleport("℧ OMEGA", "Omega Area")
addZoneTeleport("Eternal", "Eternal Area")

Tabs.Settings:AddButton({
    Title = "Uninstall Cheat GUI",
    Description = "Removes the panel and cleanly disconnects all running threads.",
    Callback = function()
        cleanupAll()
        Fluent:Destroy()
    end
})

table.insert(globalEnv.SqwssCrossRiversConnections, UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    local code = input.KeyCode
    if code == Enum.KeyCode.W then keys.w = true
    elseif code == Enum.KeyCode.S then keys.s = true
    elseif code == Enum.KeyCode.A then keys.a = true
    elseif code == Enum.KeyCode.D then keys.d = true
    elseif code == Enum.KeyCode.Q then keys.q = true
    elseif code == Enum.KeyCode.E then keys.e = true
    end
end))

table.insert(globalEnv.SqwssCrossRiversConnections, UserInputService.InputEnded:Connect(function(input)
    local code = input.KeyCode
    if code == Enum.KeyCode.W then keys.w = false
    elseif code == Enum.KeyCode.S then keys.s = false
    elseif code == Enum.KeyCode.A then keys.a = false
    elseif code == Enum.KeyCode.D then keys.d = false
    elseif code == Enum.KeyCode.Q then keys.q = false
    elseif code == Enum.KeyCode.E then keys.e = false
    end
end))

local movementUpdateLoop = RunService.Heartbeat:Connect(function(dt)
    pcall(function()
        local char = localPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            
            if hum then
                if speedEnabled and not flyEnabled then
                    hum.WalkSpeed = customSpeed
                end
                if jumpEnabled then
                    hum.JumpPower = customJump
                    hum.UseJumpPower = true
                end
            end
            
            if noclip then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
            
            if flyEnabled and hrp and hum then
                local cam = workspace.CurrentCamera
                local velocity = Vector3.new(0, 0, 0)
                if keys.w then velocity = velocity + cam.CFrame.LookVector end
                if keys.s then velocity = velocity - cam.CFrame.LookVector end
                if keys.a then velocity = velocity - cam.CFrame.RightVector end
                if keys.d then velocity = velocity + cam.CFrame.RightVector end
                if keys.q then velocity = velocity - Vector3.new(0, 1, 0) end
                if keys.e then velocity = velocity + Vector3.new(0, 1, 0) end
                
                local bv = hrp:FindFirstChild("SqwssFlyBV")
                local bg = hrp:FindFirstChild("SqwssFlyBG")
                if bv and bg then
                    bv.Velocity = velocity.Magnitude > 0 and (velocity.Unit * flySpeed) or Vector3.new(0, 0, 0)
                    bg.CFrame = cam.CFrame
                end
            end
        end
    end)
end)
table.insert(globalEnv.SqwssCrossRiversConnections, movementUpdateLoop)

local jumpConn = UserInputService.JumpRequest:Connect(function()
    pcall(function()
        if infJumpEnabled then
            local char = localPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end)
table.insert(globalEnv.SqwssCrossRiversConnections, jumpConn)

local farmThread = task.spawn(function()
    while true do
        task.wait(1)
        if autoFarm then
            pcall(function()
                local char = localPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local sb = workspace:FindFirstChild("SpawnedBrainrots")
                local myPlot = getMyPlot()
                if hrp and sb and myPlot then
                    local children = sb:GetChildren()
                    table.sort(children, function(a, b)
                        local za = a:GetAttribute("_ZoneIndex") or 0
                        local zb = b:GetAttribute("_ZoneIndex") or 0
                        return za > zb
                    end)
                    
                    local target = nil
                    for _, child in ipairs(children) do
                        local prompt = child:FindFirstChildWhichIsA("ProximityPrompt", true)
                        local part = child:FindFirstChild("HumanoidRootPart") or child:FindFirstChildWhichIsA("BasePart")
                        if prompt and part then
                            target = {prompt = prompt, part = part}
                            break
                        end
                    end
                    
                    if target then
                        local oldPos = hrp.CFrame
                        hrp.CFrame = target.part.CFrame
                        task.wait(0.3)
                        fireproximityprompt(target.prompt)
                        task.wait(0.3)
                        hrp.CFrame = myPlot.Home.CFrame + Vector3.new(0, 5, 0)
                        task.wait(0.3)
                        game.ReplicatedStorage.Events.RequestSell:FireServer("Inventory")
                        task.wait(0.3)
                        hrp.CFrame = oldPos
                    end
                end
            end)
        end
    end
end)
table.insert(globalEnv.SqwssCrossRiversThreads, farmThread)

local tycoonThread = task.spawn(function()
    while true do
        task.wait(1)
        if autoBuyPads then
            pcall(function()
                local plot = getMyPlot()
                local char = localPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if plot and hrp then
                    for _, pad in ipairs(plot.Pads:GetChildren()) do
                        local cp = pad:FindFirstChild("CollectPart")
                        if cp then
                            firetouchinterest(hrp, cp, 0)
                            firetouchinterest(hrp, cp, 1)
                        end
                    end
                end
            end)
        end
        if autoUpgradeSpeed then
            pcall(function()
                game.ReplicatedStorage.Events.PurchaseSpeed:FireServer(10)
            end)
        end
        if autoUpgradeCarry then
            pcall(function()
                game.ReplicatedStorage.Events.PurchaseCarry:FireServer()
            end)
        end
        if autoRebirth then
            pcall(function()
                game.ReplicatedStorage.Events.RequestRebirth:FireServer()
            end)
        end
    end
end)
table.insert(globalEnv.SqwssCrossRiversThreads, tycoonThread)

local slapThread = task.spawn(function()
    while true do
        task.wait(0.1)
        if autoSlap then
            pcall(function()
                local char = localPlayer.Character
                local bat = char and char:FindFirstChild("Bat") or localPlayer.Backpack:FindFirstChild("Bat")
                if bat and char then
                    if bat.Parent == localPlayer.Backpack then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then
                            hum:EquipTool(bat)
                        end
                    end
                    game.ReplicatedStorage.Events.SlapBat:FireServer()
                end
            end)
        end
    end
end)
table.insert(globalEnv.SqwssCrossRiversThreads, slapThread)
