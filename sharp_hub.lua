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

if globalEnv.SqwssSharpConnections then
    for _, conn in ipairs(globalEnv.SqwssSharpConnections) do
        pcall(function() conn:Disconnect() end)
    end
end
globalEnv.SqwssSharpConnections = {}

if globalEnv.SqwssSharpThreads then
    for _, thread in ipairs(globalEnv.SqwssSharpThreads) do
        pcall(function() task.cancel(thread) end)
    end
end
globalEnv.SqwssSharpThreads = {}

local Camera = workspace.CurrentCamera

local aimbotEnabled = false
local targetPartName = "Head"
local fovRadius = 150
local fovColor = Color3.fromRGB(244, 66, 142)
local showFov = false
local aimbotSmoothness = 0.2
local wallCheckEnabled = true
local teamCheckEnabled = true
local autoGrabFlag = false
local autoDeliverFlag = false

local customSpeed = 16

local customJump = 50
local speedEnabled = false
local jumpEnabled = false
local infJumpEnabled = false
local noclip = false
local bhopEnabled = false

local flyEnabled = false
local flySpeed = 50
local keys = {w = false, s = false, a = false, d = false, q = false, e = false}
local spaceHeld = false

local DrawingESP = {
    Players = {},
    Enabled = false,
    Boxes = false,
    Tracers = false
}

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1.5
fovCircle.Filled = false
fovCircle.Transparency = 1
fovCircle.Visible = false

local function updateFovCircle()
    if showFov and aimbotEnabled then
        local mousePos = UserInputService:GetMouseLocation()
        fovCircle.Position = mousePos
        fovCircle.Radius = fovRadius
        fovCircle.Color = fovColor
        fovCircle.Visible = true
    else
        fovCircle.Visible = false
    end
end

local aimPriority = "Distance (3D)"

local function isVisible(part, char)
    local localChar = localPlayer.Character
    if not localChar then return false end
    
    local origin = Camera.CFrame.Position
    local destination = part.Position
    local direction = destination - origin
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    
    local ignoreList = {localChar, char, Camera}
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            table.insert(ignoreList, p.Character)
        end
    end
    params.FilterDescendantsInstances = ignoreList
    
    -- Recursive raycasting up to 5 layers (to bypass shoot-through obstacles, glass, transparent fences, etc.)
    local maxDistance = direction.Magnitude
    local rayOrigin = origin
    local rayDirection = direction.Unit * maxDistance
    
    for i = 1, 5 do
        local result = workspace:Raycast(rayOrigin, rayDirection, params)
        if not result then
            return true
        end
        
        -- If we hit a solid wall
        if result.Instance.CanCollide and result.Instance.Transparency < 0.7 then
            return false
        end
        
        -- Otherwise, add hit instance to ignore list, adjust distance and cast again
        table.insert(ignoreList, result.Instance)
        params.FilterDescendantsInstances = ignoreList
        
        local hitDistance = (result.Position - rayOrigin).Magnitude
        maxDistance = maxDistance - hitDistance
        if maxDistance <= 0.1 then break end
        
        rayOrigin = result.Position + (direction.Unit * 0.05) -- Offset slightly to avoid re-triggering on same surface
        rayDirection = direction.Unit * maxDistance
    end
    
    return true
end

local function getTargetPart(char)
    if targetPartName == "Random" then
        local parts = {"Head", "HumanoidRootPart", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg"}
        local selected = parts[math.random(1, #parts)]
        return char:FindFirstChild(selected) or char:FindFirstChild("HumanoidRootPart")
    else
        return char:FindFirstChild(targetPartName) or char:FindFirstChild("HumanoidRootPart")
    end
end

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local mousePos = UserInputService:GetMouseLocation()
    local localChar = localPlayer.Character
    local localHrp = localChar and localChar:FindFirstChild("HumanoidRootPart")
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            -- Team check
            if teamCheckEnabled and player.Team and localPlayer.Team and player.Team == localPlayer.Team then
                continue
            end
            
            local part = player.Character:FindFirstChild(targetPartName == "Random" and "Head" or targetPartName) or player.Character:FindFirstChild("HumanoidRootPart")
            if part then
                if wallCheckEnabled and not isVisible(part, player.Character) then
                    continue
                end
                
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    if aimPriority == "Distance (3D)" then
                        if localHrp then
                            local dist3d = (part.Position - localHrp.Position).Magnitude
                            if dist3d < shortestDistance then
                                local dist2d = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                                if dist2d <= fovRadius then
                                    shortestDistance = dist3d
                                    closestPlayer = player
                                end
                            end
                        end
                    else
                        local dist2d = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist2d < shortestDistance and dist2d <= fovRadius then
                            shortestDistance = dist2d
                            closestPlayer = player
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end


local chamsEnabled = false
local function applyHighlight(player)
    if player == localPlayer then return end
    
    local function highlightChar(char)
        task.wait(0.2)
        local hl = char:FindFirstChild("SqwssHighlight")
        if chamsEnabled then
            if not hl then
                hl = Instance.new("Highlight")
                hl.Name = "SqwssHighlight"
                hl.FillColor = Color3.fromRGB(244, 66, 142)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.5
                hl.OutlineTransparency = 0
                hl.Parent = char
            end
        else
            if hl then hl:Destroy() end
        end
    end
    
    if player.Character then highlightChar(player.Character) end
    local conn = player.CharacterAdded:Connect(highlightChar)
    table.insert(globalEnv.SqwssSharpConnections, conn)
end

local function updateChams()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            if chamsEnabled then
                applyHighlight(player)
            else
                local char = player.Character
                local hl = char and char:FindFirstChild("SqwssHighlight")
                if hl then hl:Destroy() end
            end
        end
    end
end

local function createESP(player)
    if player == localPlayer then return end
    if DrawingESP.Players[player] then return end
    
    local box = Drawing.new("Square")
    box.Thickness = 1.5
    box.Color = Color3.fromRGB(244, 66, 142)
    box.Filled = false
    box.Visible = false
    
    local tracer = Drawing.new("Line")
    tracer.Thickness = 1.5
    tracer.Color = Color3.fromRGB(244, 66, 142)
    tracer.Visible = false
    
    DrawingESP.Players[player] = {Box = box, Tracer = tracer, Player = player}
end

local function removeESP(player)
    local data = DrawingESP.Players[player]
    if data then
        pcall(function() data.Box:Destroy() end)
        pcall(function() data.Tracer:Destroy() end)
        DrawingESP.Players[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do createESP(p) end
table.insert(globalEnv.SqwssSharpConnections, Players.PlayerAdded:Connect(createESP))
table.insert(globalEnv.SqwssSharpConnections, Players.PlayerRemoving:Connect(removeESP))

local function updateESP()
    for player, data in pairs(DrawingESP.Players) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        local visible = false
        if DrawingESP.Enabled and hrp and hum and hum.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                visible = true
                
                if DrawingESP.Boxes then
                    local head = char:FindFirstChild("Head")
                    local headPos = head and Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)) or pos
                    local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                    
                    local height = math.abs(headPos.Y - legPos.Y)
                    local width = height * 0.6
                    
                    data.Box.Size = Vector2.new(width, height)
                    data.Box.Position = Vector2.new(pos.X - width/2, pos.Y - height/2)
                    data.Box.Visible = true
                else
                    data.Box.Visible = false
                end
                
                if DrawingESP.Tracers then
                    data.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    data.Tracer.To = Vector2.new(pos.X, pos.Y)
                    data.Tracer.Visible = true
                else
                    data.Tracer.Visible = false
                end
            end
        end
        
        if not visible then
            data.Box.Visible = false
            data.Tracer.Visible = false
        end
    end
end

local function cleanupAll()
    if globalEnv.SqwssSharpConnections then
        for _, conn in ipairs(globalEnv.SqwssSharpConnections) do
            pcall(function() conn:Disconnect() end)
        end
    end
    if globalEnv.SqwssSharpThreads then
        for _, thread in ipairs(globalEnv.SqwssSharpThreads) do
            pcall(function() task.cancel(thread) end)
        end
    end
    
    pcall(function() fovCircle:Destroy() end)
    for p, _ in pairs(DrawingESP.Players) do removeESP(p) end
    
    pcall(function()
        for _, player in ipairs(Players:GetPlayers()) do
            local char = player.Character
            local hl = char and char:FindFirstChild("SqwssHighlight")
            if hl then hl:Destroy() end
        end
    end)
    
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
    Title = "Sqwss Hub | SHARP",
    SubTitle = "by sqwss",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift
})

local Tabs = {
    Combat = Window:AddTab({ Title = "Combat", Icon = "crosshair" }),
    FlagFarm = Window:AddTab({ Title = "Flag Farm", Icon = "sparkles" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Movement = Window:AddTab({ Title = "Movement", Icon = "zap" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}


Tabs.Combat:AddToggle("AimbotToggle", { Title = "Enable Camera Aimbot", Default = false }):OnChanged(function(v)
    aimbotEnabled = v
end)

Tabs.Combat:AddToggle("WallCheckToggle", { Title = "Enable Wall Check", Default = true }):OnChanged(function(v)
    wallCheckEnabled = v
end)

Tabs.Combat:AddToggle("TeamCheckToggle", { Title = "Enable Team Check", Default = true }):OnChanged(function(v)
    teamCheckEnabled = v
end)


Tabs.Combat:AddDropdown("TargetPartDropdown", {
    Title = "Target Hitbox",
    Values = {"Head", "HumanoidRootPart", "Random"},
    Default = "Head",
    Callback = function(v)
        targetPartName = v
    end
})

Tabs.Combat:AddDropdown("TargetPriorityDropdown", {
    Title = "Target Priority",
    Values = {"Distance (3D)", "Mouse (2D)"},
    Default = "Distance (3D)",
    Callback = function(v)
        aimPriority = v
    end
})


Tabs.Combat:AddSlider("SmoothnessSlider", {
    Title = "Aimbot Smoothness",
    Min = 0.05,
    Max = 1.0,
    Default = 0.2,
    Rounding = 2,
    Callback = function(v)
        aimbotSmoothness = v
    end
})

Tabs.Combat:AddToggle("ShowFovToggle", { Title = "Show FOV Circle", Default = false }):OnChanged(function(v)
    showFov = v
end)

Tabs.Combat:AddSlider("FovRadiusSlider", {
    Title = "FOV Radius",
    Min = 50,
    Max = 800,
    Default = 150,
    Rounding = 0,
    Callback = function(v)
        fovRadius = v
    end
})

Tabs.Combat:AddColorpicker("FovColorPicker", {
    Title = "FOV Circle Color",
    Default = Color3.fromRGB(244, 66, 142),
    Callback = function(v)
        fovColor = v
    end
})

Tabs.FlagFarm:AddToggle("AutoGrabFlagToggle", { Title = "Auto Grab Enemy / Dropped Flag", Default = false }):OnChanged(function(v)
    autoGrabFlag = v
end)

Tabs.FlagFarm:AddToggle("AutoDeliverFlagToggle", { Title = "Auto Deliver Flag to Base", Default = false }):OnChanged(function(v)
    autoDeliverFlag = v
end)

Tabs.Visuals:AddToggle("ChamsToggle", { Title = "Highlight Players (Chams)", Default = false }):OnChanged(function(v)

    chamsEnabled = v
    updateChams()
end)

Tabs.Visuals:AddToggle("ESPToggle", { Title = "Enable Drawing ESP", Default = false }):OnChanged(function(v)
    DrawingESP.Enabled = v
end)

Tabs.Visuals:AddToggle("BoxesToggle", { Title = "Show 2D Boxes", Default = false }):OnChanged(function(v)
    DrawingESP.Boxes = v
end)

Tabs.Visuals:AddToggle("TracersToggle", { Title = "Show Tracers", Default = false }):OnChanged(function(v)
    DrawingESP.Tracers = v
end)

Tabs.Movement:AddToggle("BhopToggle", { Title = "Bunnyhop (Bhop)", Default = false }):OnChanged(function(v)
    bhopEnabled = v
end)

Tabs.Movement:AddToggle("SpeedToggle", { Title = "Enable WalkSpeed Modifier", Default = false }):OnChanged(function(v)
    speedEnabled = v
end)

Tabs.Movement:AddSlider("SpeedSlider", {
    Title = "WalkSpeed Limit",
    Min = 16,
    Max = 500,
    Default = 16,
    Rounding = 0,
    Callback = function(v)
        customSpeed = v
    end
})

Tabs.Movement:AddToggle("JumpToggle", { Title = "Enable JumpPower Modifier", Default = false }):OnChanged(function(v)
    jumpEnabled = v
end)

Tabs.Movement:AddSlider("JumpSlider", {
    Title = "JumpPower Limit",
    Min = 50,
    Max = 500,
    Default = 50,
    Rounding = 0,
    Callback = function(v)
        customJump = v
    end
})

Tabs.Movement:AddToggle("NoclipToggle", { Title = "Noclip", Default = false }):OnChanged(function(v)
    noclip = v
end)

Tabs.Movement:AddToggle("InfJumpToggle", { Title = "Infinite Jump", Default = false }):OnChanged(function(v)
    infJumpEnabled = v
end)

Tabs.Movement:AddToggle("FlyToggle", { Title = "Fly Mode", Default = false }):OnChanged(function(v)
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

Tabs.Movement:AddSlider("FlySpeedSlider", {
    Title = "Fly Speed",
    Min = 10,
    Max = 300,
    Default = 50,
    Rounding = 0,
    Callback = function(v)
        flySpeed = v
    end
})

Tabs.Settings:AddButton({
    Title = "Uninstall Cheat GUI",
    Description = "Removes the panel and cleanly disconnects all running threads.",
    Callback = function()
        cleanupAll()
        Fluent:Destroy()
    end
})

table.insert(globalEnv.SqwssSharpConnections, UserInputService.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.Space then
        spaceHeld = true
    end
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

table.insert(globalEnv.SqwssSharpConnections, UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then
        spaceHeld = false
    end
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
                if bhopEnabled and spaceHeld then
                    if hum.FloorMaterial ~= Enum.Material.Air then
                        hum.Jump = true
                    end
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
table.insert(globalEnv.SqwssSharpConnections, movementUpdateLoop)

local renderUpdateLoop = RunService.RenderStepped:Connect(function()
    pcall(updateFovCircle)
    pcall(updateESP)
    
    if aimbotEnabled then
        pcall(function()
            local target = getClosestPlayer()
            if target and target.Character then
                local part = getTargetPart(target.Character)
                if part then
                    local cam = workspace.CurrentCamera
                    local targetLook = CFrame.new(cam.CFrame.Position, part.Position)
                    cam.CFrame = cam.CFrame:Lerp(targetLook, aimbotSmoothness)
                end
            end
        end)
    end
end)
table.insert(globalEnv.SqwssSharpConnections, renderUpdateLoop)

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
table.insert(globalEnv.SqwssSharpConnections, jumpConn)

local pJoinedConn = Players.PlayerAdded:Connect(function(player)
    if chamsEnabled then
        applyHighlight(player)
    end
end)
table.insert(globalEnv.SqwssSharpConnections, pJoinedConn)

-- Background flag farming thread
local flagFarmThread = task.spawn(function()
    while true do
        task.wait(0.2)
        pcall(function()
            local char = localPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            -- Check if player already has a flag (attached to HumanoidRootPart.PlayerStatus)
            local hasFlag = false
            local playerStatus = hrp:FindFirstChild("PlayerStatus")
            if playerStatus and playerStatus:FindFirstChild("Flag") then
                hasFlag = true
            end
            
            if autoGrabFlag and not hasFlag then
                -- 1. Grab Dropped Flag
                local droppedFlag = workspace:FindFirstChild("DroppedFlag", true) or (workspace:FindFirstChild("Entities") and workspace.Entities:FindFirstChild("DroppedFlag"))
                if droppedFlag then
                    local hitDetect = droppedFlag:FindFirstChild("HitDetect")
                    if hitDetect then
                        if firetouchtransmitter then
                            firetouchtransmitter(hitDetect, hrp, 0)
                            task.wait(0.1)
                            firetouchtransmitter(hitDetect, hrp, 1)
                        else
                            -- Fallback CFrame teleport grab
                            local oldCFrame = hrp.CFrame
                            hrp.CFrame = hitDetect.CFrame
                            task.wait(0.1)
                            hrp.CFrame = oldCFrame
                        end
                    end
                end
            end
            
            if autoDeliverFlag and hasFlag then
                -- 2. Deliver Flag to player's Team Base
                -- In SHARP, base spawn points are inside Lobby or designated Base markers
                -- Since players don't have teams here (No Team), we teleport to their designated stand/base or lobby deliver point
                local lobbyBase = workspace:FindFirstChild("RetroPlayerStand", true) or workspace:FindFirstChild("Lobby")
                if lobbyBase then
                    local targetPos = lobbyBase:IsA("Model") and lobbyBase:GetModelCFrame() or lobbyBase.CFrame
                    local oldCFrame = hrp.CFrame
                    hrp.CFrame = targetPos + Vector3.new(0, 3, 0)
                    task.wait(0.2)
                end
            end
        end)
    end
end)
table.insert(globalEnv.SqwssSharpThreads, flagFarmThread)

