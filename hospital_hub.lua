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

if globalEnv.SqwssHospitalConnections then
    for _, conn in ipairs(globalEnv.SqwssHospitalConnections) do
        pcall(function() conn:Disconnect() end)
    end
end
globalEnv.SqwssHospitalConnections = {}

if globalEnv.SqwssHospitalThreads then
    for _, thread in ipairs(globalEnv.SqwssHospitalThreads) do
        pcall(function() task.cancel(thread) end)
    end
end
globalEnv.SqwssHospitalThreads = {}

local espEnabled = false
local espConnections = {}
local autoMinigames = false
local unlockCursor = false

local customSpeed = 16
local customJump = 50
local speedEnabled = false
local jumpEnabled = false
local infJumpEnabled = false
local noclip = false

local flyEnabled = false
local flySpeed = 50
local keys = {w = false, s = false, a = false, d = false, q = false, e = false}

local function cleanESP()
    for _, conn in ipairs(espConnections) do
        pcall(function() conn:Disconnect() end)
    end
    espConnections = {}
    for _, child in ipairs(workspace:GetDescendants()) do
        local hl = child:FindFirstChild("SqwssHospitalHighlight")
        if hl then hl:Destroy() end
    end
end

local function getHighlightColor(model)
    if model:GetAttribute("IsPatient") == true then
        if model:GetAttribute("Skinwalker") == true then
            return Color3.fromRGB(255, 0, 0) -- RED for Skinwalker!
        elseif model:GetAttribute("PhotoEffect") and model:GetAttribute("PhotoEffect") ~= "" then
            return Color3.fromRGB(255, 140, 0) -- ORANGE for Anomaly!
        else
            return Color3.fromRGB(255, 255, 0) -- YELLOW for normal patient
        end
    end
    return Color3.fromRGB(0, 191, 255) -- BLUE for players
end

local function highlightModel(model)
    if model == localPlayer.Character then return end
    local hum = model:FindFirstChildOfClass("Humanoid")
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if hum and hrp then
        local hl = model:FindFirstChild("SqwssHospitalHighlight")
        if espEnabled then
            if not hl then
                hl = Instance.new("Highlight")
                hl.Name = "SqwssHospitalHighlight"
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.5
                hl.OutlineTransparency = 0
                hl.Parent = model
            end
            hl.FillColor = getHighlightColor(model)
        else
            if hl then hl:Destroy() end
        end
    end
end

local function applyESP()
    cleanESP()
    if not espEnabled then return end
    
    for _, child in ipairs(workspace:GetDescendants()) do
        if child:IsA("Model") then
            highlightModel(child)
        end
    end
    
    local conn = workspace.DescendantAdded:Connect(function(desc)
        if desc:IsA("Model") then
            task.wait(0.5)
            highlightModel(desc)
        end
    end)
    table.insert(espConnections, conn)
    table.insert(globalEnv.SqwssHospitalConnections, conn)
end

local function cleanupAll()
    cleanESP()
    if globalEnv.SqwssHospitalConnections then
        for _, conn in ipairs(globalEnv.SqwssHospitalConnections) do
            pcall(function() conn:Disconnect() end)
        end
    end
    if globalEnv.SqwssHospitalThreads then
        for _, thread in ipairs(globalEnv.SqwssHospitalThreads) do
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
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        localPlayer.CameraMode = Enum.CameraMode.Classic
        UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
    end)
end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Sqwss Hub | The Animal Hospital",
    SubTitle = "by sqwss",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main Hacks", Icon = "home" }),
    Detector = Window:AddTab({ Title = "Anomaly Detector", Icon = "alert-circle" }),
    Visuals = Window:AddTab({ Title = "ESP Visuals", Icon = "eye" }),
    Teleports = Window:AddTab({ Title = "Teleports", Icon = "map-pin" }),
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

Tabs.Main:AddToggle("AutoMinigameToggle", { Title = "Auto Solve Heartbeat Minigames", Default = false }):OnChanged(function(v)
    autoMinigames = v
end)

Tabs.Main:AddToggle("UnlockCursorToggle", { Title = "Unlock Mouse Cursor (Force 3rd Person)", Default = false }):OnChanged(function(v)
    unlockCursor = v
    if not unlockCursor then
        pcall(function()
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            localPlayer.CameraMode = Enum.CameraMode.Classic
            UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
        end)
    end
end)

local detectorLabel = Tabs.Detector:AddParagraph({
    Title = "Active Anomalies List",
    Content = "Scanning for anomalies in hospital rooms..."
})

local function getActiveAnomaliesList()
    local list = {}
    local npcsFolder = workspace:FindFirstChild("NPCs")
    if npcsFolder then
        for _, npc in ipairs(npcsFolder:GetChildren()) do
            local isPatient = npc:GetAttribute("IsPatient")
            local isSkinwalker = npc:GetAttribute("Skinwalker")
            local effect = npc:GetAttribute("PhotoEffect")
            local room = npc:GetAttribute("DesignatedRoom") or "None"
            
            if isPatient == true then
                if isSkinwalker == true then
                    table.insert(list, "🔴 " .. npc.Name .. " (" .. tostring(room) .. ") - SKINWALKER")
                elseif effect and effect ~= "" then
                    table.insert(list, "🟠 " .. npc.Name .. " (" .. tostring(room) .. ") - ANOMALY: " .. tostring(effect))
                else
                    table.insert(list, "🟢 " .. npc.Name .. " (" .. tostring(room) .. ") - Normal Patient")
                end
            end
        end
    end
    if #list == 0 then
        return "No active patients found."
    else
        table.sort(list)
        return table.concat(list, "\n")
    end
end

local detectorThread = task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            detectorLabel:SetContent(getActiveAnomaliesList())
            if espEnabled then
                for _, child in ipairs(workspace:GetDescendants()) do
                    if child:IsA("Model") then
                        local hl = child:FindFirstChild("SqwssHospitalHighlight")
                        if hl then
                            hl.FillColor = getHighlightColor(child)
                        end
                    end
                end
            end
        end)
    end
end)
table.insert(globalEnv.SqwssHospitalThreads, detectorThread)

Tabs.Visuals:AddToggle("ChamsToggle", { Title = "Show Chams Highlight (Smart Colors)", Default = false }):OnChanged(function(v)
    espEnabled = v
    applyESP()
end)

local chamsColorInfo = Tabs.Visuals:AddParagraph({
    Title = "Smart Color Guide",
    Content = "🔵 Blue - Normal Players\n🟡 Yellow - Normal Patients\n🟠 Orange - Anomalous Patients\n🔴 Red - SKINWALKERS"
})

local function addAreaTeleports()
    local areas = workspace:FindFirstChild("Areas")
    if areas then
        local items = areas:GetChildren()
        table.sort(items, function(a, b)
            return a.Name < b.Name
        end)
        
        for _, area in ipairs(items) do
            Tabs.Teleports:AddButton({
                Title = "Teleport to " .. area.Name,
                Description = "Teleports you directly to " .. area.Name .. ".",
                Callback = function()
                    local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = area:GetPivot() + Vector3.new(0, 5, 0)
                    end
                end
            })
        end
    end
end

addAreaTeleports()

Tabs.Settings:AddButton({
    Title = "Uninstall Cheat GUI",
    Description = "Removes the panel and cleanly disconnects all running threads.",
    Callback = function()
        cleanupAll()
        Fluent:Destroy()
    end
})

table.insert(globalEnv.SqwssHospitalConnections, UserInputService.InputBegan:Connect(function(input, processed)
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

table.insert(globalEnv.SqwssHospitalConnections, UserInputService.InputEnded:Connect(function(input)
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
table.insert(globalEnv.SqwssHospitalConnections, movementUpdateLoop)

local renderUpdateLoop = RunService.RenderStepped:Connect(function()
    if unlockCursor then
        pcall(function()
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            localPlayer.CameraMode = Enum.CameraMode.Classic
            UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceShow
        end)
    end
end)
table.insert(globalEnv.SqwssHospitalConnections, renderUpdateLoop)

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
table.insert(globalEnv.SqwssHospitalConnections, jumpConn)

local startMinigameEv = game.ReplicatedStorage:FindFirstChild("StartHeartbeatMinigame", true) or game.ReplicatedStorage.Util.Net:FindFirstChild("RE/StartHeartbeatMinigame")
local completeMinigameEv = game.ReplicatedStorage:FindFirstChild("HeartbeatMinigameComplete", true) or game.ReplicatedStorage.Util.Net:FindFirstChild("RE/HeartbeatMinigameComplete")

if startMinigameEv and completeMinigameEv then
    local minigameConn = startMinigameEv.OnClientEvent:Connect(function(...)
        if autoMinigames then
            task.wait(0.5)
            completeMinigameEv:FireServer(true, true)
        end
    end)
    table.insert(globalEnv.SqwssHospitalConnections, minigameConn)
end
