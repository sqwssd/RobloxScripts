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

if globalEnv.SqwssJetpackConnections then
    for _, conn in ipairs(globalEnv.SqwssJetpackConnections) do
        pcall(function() conn:Disconnect() end)
    end
end
globalEnv.SqwssJetpackConnections = {}

if globalEnv.SqwssJetpackThreads then
    for _, thread in ipairs(globalEnv.SqwssJetpackThreads) do
        pcall(function() task.cancel(thread) end)
    end
end
globalEnv.SqwssJetpackThreads = {}

local function cleanupAll()
    if globalEnv.SqwssJetpackConnections then
        for _, conn in ipairs(globalEnv.SqwssJetpackConnections) do
            pcall(function() conn:Disconnect() end)
        end
    end
    if globalEnv.SqwssJetpackThreads then
        for _, thread in ipairs(globalEnv.SqwssJetpackThreads) do
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
        local screenGui = CoreGui:FindFirstChild("SqwssJetpackHub") or localPlayer:WaitForChild("PlayerGui"):FindFirstChild("SqwssJetpackHub")
        if screenGui then screenGui:Destroy() end
    end)
end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Sqwss Hub | +1 Jetpack for Brainrots",
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

local autoCollectCoins = false
local autoCollectBase = false
local autoUpgradeBase = false
local autoUpgradeBrainrot = false
local autoUpgradeCarry = false
local autoUpgradeBoost = false
local autoRebirth = false

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

Tabs.Farming:AddToggle("CollectCoinsToggle", { Title = "Auto Collect Flying Coins", Default = false }):OnChanged(function(v)
    autoCollectCoins = v
end)

Tabs.Farming:AddToggle("CollectBaseToggle", { Title = "Auto Collect Tycoon Cash", Default = false }):OnChanged(function(v)
    autoCollectBase = v
end)

Tabs.Farming:AddToggle("UpgradeBaseToggle", { Title = "Auto Upgrade Tycoon Base", Default = false }):OnChanged(function(v)
    autoUpgradeBase = v
end)

Tabs.Farming:AddToggle("UpgradeSlotsToggle", { Title = "Auto Upgrade Brainrot Generators", Default = false }):OnChanged(function(v)
    autoUpgradeBrainrot = v
end)

Tabs.Farming:AddToggle("UpgradeCarryToggle", { Title = "Auto Upgrade Backpack (Carry Limit)", Default = false }):OnChanged(function(v)
    autoUpgradeCarry = v
end)

Tabs.Farming:AddToggle("UpgradeBoostToggle", { Title = "Auto Upgrade Boosts", Default = false }):OnChanged(function(v)
    autoUpgradeBoost = v
end)

Tabs.Farming:AddToggle("AutoRebirthToggle", { Title = "Auto Rebirth", Default = false }):OnChanged(function(v)
    autoRebirth = v
end)

local function getMyBase()
    local name = localPlayer.Name
    local bases = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("PlayerBases")
    if bases then
        for _, base in ipairs(bases:GetChildren()) do
            for _, v in ipairs(base:GetDescendants()) do
                if v:IsA("TextLabel") and (v.Text == name or v.Text:find(name)) then
                    return base
                end
            end
        end
    end
    return nil
end

local function teleportToMyBase()
    local base = getMyBase()
    local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if base and hrp then
        hrp.CFrame = base:GetPivot() + Vector3.new(0, 5, 0)
    end
end

Tabs.Teleports:AddButton({
    Title = "Teleport to Tycoon Base",
    Description = "Teleports you directly onto your base.",
    Callback = teleportToMyBase
})

Tabs.Teleports:AddButton({
    Title = "Teleport to Spawn / Shop",
    Description = "Teleports you to the main map spawn.",
    Callback = function()
        local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(-32, 85, -20)
        end
    end
})

local islands = workspace.Map:FindFirstChild("Islands")
if islands then
    local children = islands:GetChildren()
    table.sort(children, function(a, b)
        local na = tonumber(a.Name) or 999
        local nb = tonumber(b.Name) or 999
        if na == nb then
            return a.Name < b.Name
        end
        return na < nb
    end)
    
    local seen = {}
    for _, child in ipairs(children) do
        local part = child:FindFirstChildWhichIsA("BasePart", true)
        if part then
            local name = child.Name
            if seen[name] then
                seen[name] = seen[name] + 1
                name = name .. " #" .. tostring(seen[name])
            else
                seen[name] = 1
            end
            
            Tabs.Teleports:AddButton({
                Title = "Teleport to Island " .. name,
                Description = "Teleports you to " .. child.Name,
                Callback = function()
                    local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
                    end
                end
            })
        end
    end
end


Tabs.Settings:AddButton({
    Title = "Uninstall Cheat GUI",
    Description = "Removes the panel and cleanly disconnects all running threads.",
    Callback = function()
        cleanupAll()
        Fluent:Destroy()
    end
})

table.insert(globalEnv.SqwssJetpackConnections, UserInputService.InputBegan:Connect(function(input, processed)
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

table.insert(globalEnv.SqwssJetpackConnections, UserInputService.InputEnded:Connect(function(input)
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
table.insert(globalEnv.SqwssJetpackConnections, movementUpdateLoop)

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
table.insert(globalEnv.SqwssJetpackConnections, jumpConn)

local coinCollectThread = task.spawn(function()
    while true do
        task.wait(1.5)
        if autoCollectCoins then
            pcall(function()
                local char = localPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local coinContainer = workspace:FindFirstChild("MutationCoins")
                    if coinContainer then
                        for _, v in ipairs(coinContainer:GetDescendants()) do
                            if v.Name == "TouchInterest" or v:IsA("TouchTransmitter") then
                                local p = v.Parent
                                if p and p:IsA("BasePart") and p.Name == "Part" then
                                    firetouchinterest(hrp, p, 0)
                                    firetouchinterest(hrp, p, 1)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)
table.insert(globalEnv.SqwssJetpackThreads, coinCollectThread)

local farmLoopThread = task.spawn(function()
    local gameRF = game.ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.Game.RF
    while true do
        task.wait(1)
        if autoCollectBase then
            pcall(function()
                gameRF.PickupAllCash:InvokeServer()
            end)
        end
        if autoUpgradeBase then
            pcall(function()
                gameRF.UpgradeBase:InvokeServer()
            end)
        end
        if autoUpgradeBrainrot then
            pcall(function()
                for slot = 1, 6 do
                    gameRF.UpgradeBrainrot:InvokeServer(slot)
                end
            end)
        end
        if autoUpgradeCarry then
            pcall(function()
                gameRF.UpgradeCarryLimit:InvokeServer()
            end)
        end
        if autoUpgradeBoost then
            pcall(function()
                gameRF.UpgradeBoost:InvokeServer()
            end)
        end
        if autoRebirth then
            pcall(function()
                gameRF.Rebirth:InvokeServer()
            end)
        end
    end
end)
table.insert(globalEnv.SqwssJetpackThreads, farmLoopThread)
