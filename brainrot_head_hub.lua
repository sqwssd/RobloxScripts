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

if globalEnv.SqwssBrainrotHeadConnections then
    for _, conn in ipairs(globalEnv.SqwssBrainrotHeadConnections) do
        pcall(function() conn:Disconnect() end)
    end
end
globalEnv.SqwssBrainrotHeadConnections = {}

if globalEnv.SqwssBrainrotHeadThreads then
    for _, thread in ipairs(globalEnv.SqwssBrainrotHeadThreads) do
        pcall(function() task.cancel(thread) end)
    end
end
globalEnv.SqwssBrainrotHeadThreads = {}

local customSpeed = 16
local customJump = 50
local speedEnabled = false
local jumpEnabled = false
local infJumpEnabled = false
local noclip = false

local flyEnabled = false
local flySpeed = 50
local keys = {w = false, s = false, a = false, d = false, q = false, e = false}

local autoReturn = false
local autoCollectMoney = false
local autoRebirth = false
local autoVacuum = false
local autoRespawn = false

local function triggerPrompt(prompt)
    if fireproximityprompt then
        fireproximityprompt(prompt)
    else
        task.spawn(function()
            prompt:InputBegan(Enum.UserInputType.MouseButton1)
            task.wait(prompt.HoldDuration + 0.1)
            prompt:InputEnded(Enum.UserInputType.MouseButton1)
        end)
    end
end

local function cleanupAll()
    if globalEnv.SqwssBrainrotHeadConnections then
        for _, conn in ipairs(globalEnv.SqwssBrainrotHeadConnections) do
            pcall(function() conn:Disconnect() end)
        end
    end
    if globalEnv.SqwssBrainrotHeadThreads then
        for _, thread in ipairs(globalEnv.SqwssBrainrotHeadThreads) do
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
end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Sqwss Hub | Inside Brainrot Head",
    SubTitle = "by sqwss",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main Hacks", Icon = "home" }),
    Farming = Window:AddTab({ Title = "Farming", Icon = "sparkles" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

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

-- Teleport directly inside the head
Tabs.Farming:AddButton({
    Title = "Teleport Inside Brainrot Head 🧠",
    Description = "Instantly teleports you into the event head area where brainrots spawn.",
    Callback = function()
        local char = localPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(1044.96, 35, -388.66)
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Character or HumanoidRootPart not found!",
                Duration = 3
            })
        end
    end
})

Tabs.Farming:AddToggle("AutoReturnToggle", { Title = "Auto Teleport to Base on Grab", Default = false }):OnChanged(function(v)
    autoReturn = v
end)

Tabs.Farming:AddToggle("AutoVacuumToggle", { Title = "Auto Vacuum Spawned Items", Default = false }):OnChanged(function(v)
    autoVacuum = v
end)

Tabs.Farming:AddToggle("AutoRespawnToggle", { Title = "Auto Respawn Brainrots", Default = false }):OnChanged(function(v)
    autoRespawn = v
end)

Tabs.Farming:AddToggle("AutoCollectMoneyToggle", { Title = "Auto Collect Tycoon Money", Default = false }):OnChanged(function(v)
    autoCollectMoney = v
end)

Tabs.Farming:AddToggle("AutoRebirthToggle", { Title = "Auto Rebirth", Default = false }):OnChanged(function(v)
    autoRebirth = v
end)

Tabs.Settings:AddButton({
    Title = "Uninstall Cheat GUI",
    Description = "Removes the panel and cleanly disconnects all running threads.",
    Callback = function()
        cleanupAll()
        Fluent:Destroy()
    end
})

-- Connection loops
table.insert(globalEnv.SqwssBrainrotHeadConnections, UserInputService.InputBegan:Connect(function(input, processed)
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

table.insert(globalEnv.SqwssBrainrotHeadConnections, UserInputService.InputEnded:Connect(function(input)
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
table.insert(globalEnv.SqwssBrainrotHeadConnections, movementUpdateLoop)

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
table.insert(globalEnv.SqwssBrainrotHeadConnections, jumpConn)

-- Auto Teleport to Base when holding brainrot
local lastDropBtnVisible = false
local dropBtnObserver = RunService.Heartbeat:Connect(function()
    if not autoReturn then return end
    pcall(function()
        local inGameGui = localPlayer.PlayerGui:FindFirstChild("InGameGui")
        local dropButton = inGameGui and inGameGui:FindFirstChild("DropButton")
        if dropButton then
            local isVisible = dropButton.Visible
            if isVisible and not lastDropBtnVisible then
                -- Player just picked up a brainrot! Teleport back to base tycoon!
                local baseTeleportRemote = game.ReplicatedStorage.packages._Index["littensy_remo@1.5.3"].remo.container:FindFirstChild("game.base.teleportToBase")
                if baseTeleportRemote then
                    baseTeleportRemote:FireServer()
                end
            end
            lastDropBtnVisible = isVisible
        end
    end)
end)
table.insert(globalEnv.SqwssBrainrotHeadConnections, dropBtnObserver)

-- Background farming threads
local farmThread = task.spawn(function()
    while true do
        task.wait(1)
        
        -- Auto Collect Tycoon Cash
        if autoCollectMoney then
            pcall(function()
                local collectRemote = game.ReplicatedStorage.packages._Index["littensy_remo@1.5.3"].remo.container:FindFirstChild("data.base.collectAllPadMoney")
                if collectRemote then
                    collectRemote:InvokeServer()
                end
            end)
        end
        
        -- Auto Rebirth
        if autoRebirth then
            pcall(function()
                local rebirthRemote = game.ReplicatedStorage.packages._Index["littensy_remo@1.5.3"].remo.container:FindFirstChild("data.base.rebirth")
                if rebirthRemote then
                    rebirthRemote:FireServer()
                end
            end)
        end
        
        -- Auto Respawn Brainrots
        if autoRespawn then
            pcall(function()
                local refreshBtn = workspace.Limited.Interior:FindFirstChild("ButtonRefresh", true)
                local prompt = refreshBtn and refreshBtn:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    triggerPrompt(prompt)
                end
            end)
        end
    end
end)
table.insert(globalEnv.SqwssBrainrotHeadThreads, farmThread)

-- Vacuum Loop
local vacuumThread = task.spawn(function()
    while true do
        task.wait(0.2)
        if autoVacuum then
            pcall(function()
                local char = localPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, desc in ipairs(workspace.Limited:GetDescendants()) do
                        if desc:IsA("TouchTransmitter") then
                            local part = desc.Parent
                            if part and part:IsA("BasePart") and part.Name ~= "Door" and part.Name ~= "Teleport" and part.Name ~= "SpawnInside" then
                                part.CFrame = hrp.CFrame
                            end
                        end
                    end
                end
            end)
        end
    end
end)
table.insert(globalEnv.SqwssBrainrotHeadThreads, vacuumThread)
