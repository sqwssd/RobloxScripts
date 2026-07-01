local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local mapMarkers = {}
local minX, maxX = -264, 876
local minZ, maxZ = -593, 298
local function cleanupAll()
    local names = {"SqwssColorOrDie", "SqwssHub", "ObbyHub", "MinimalistHub"}
    for _, name in ipairs(names) do
        if CoreGui:FindFirstChild(name) then CoreGui[name]:Destroy() end
        if localPlayer:WaitForChild("PlayerGui"):FindFirstChild(name) then 
            localPlayer.PlayerGui[name]:Destroy() 
        end
    end
    local oldEsp = CoreGui:FindFirstChild("SqwssESP")
    if oldEsp then oldEsp:Destroy() end
    local pgEsp = localPlayer:WaitForChild("PlayerGui"):FindFirstChild("SqwssESP")
    if pgEsp then pgEsp:Destroy() end
    
    local monsters = workspace:FindFirstChild("GameplayAssets")
    monsters = monsters and monsters:FindFirstChild("Monsters")
    if monsters then
        for _, model in ipairs(monsters:GetChildren()) do
            local h = model:FindFirstChild("SqwssMonsterHighlight")
            if h then h:Destroy() end
        end
    end
    if workspace:FindFirstChild("SqwssTutorialHighlight") then 
        workspace.SqwssTutorialHighlight:Destroy() 
    end
    local char = localPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local att = hrp:FindFirstChild("SqwssTutorialAtt")
            if att then att:Destroy() end
            local beam = hrp:FindFirstChild("SqwssTutorialBeam")
            if beam then beam:Destroy() end
        end
    end
    for _, marker in pairs(mapMarkers) do
        if marker then marker:Destroy() end
    end
    table.clear(mapMarkers)
    if workspace:FindFirstChild("SqwssTutorialHighlight") then workspace.SqwssTutorialHighlight:Destroy() end
end
cleanupAll()
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SqwssColorOrDie"
ScreenGui.ResetOnSpawn = false
local parent = (game:GetService("RunService"):IsStudio() or not pcall(function() local x = CoreGui.Name end)) and localPlayer:WaitForChild("PlayerGui") or CoreGui
ScreenGui.Parent = parent
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 46, 0, 46)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -23)
ToggleButton.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "★"
ToggleButton.TextColor3 = Color3.fromRGB(240, 240, 245)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 22
ToggleButton.ZIndex = 10
ToggleButton.Parent = ScreenGui
local TBCorner = Instance.new("UICorner")
TBCorner.CornerRadius = UDim.new(0.5, 0)
TBCorner.Parent = ToggleButton
local TBStroke = Instance.new("UIStroke")
TBStroke.Color = Color3.fromRGB(48, 50, 60)
TBStroke.Thickness = 1.5
TBStroke.Parent = ToggleButton
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 460, 0, 320)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(40, 42, 52)
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -30, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(244, 67, 54)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = MainFrame
local CBCorner = Instance.new("UICorner")
CBCorner.CornerRadius = UDim.new(0.5, 0)
CBCorner.Parent = CloseBtn
CloseBtn.MouseButton1Click:Connect(function()
    cleanupAll()
end)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 20, 0, 20)
MinBtn.Position = UDim2.new(1, -55, 0, 10)
MinBtn.BackgroundColor3 = Color3.fromRGB(48, 50, 60)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14
MinBtn.Parent = MainFrame
local MBCorner = Instance.new("UICorner")
MBCorner.CornerRadius = UDim.new(0.5, 0)
MBCorner.Parent = MinBtn
local guiVisible = true
local function toggleGui()
    guiVisible = not guiVisible
    MainFrame.Visible = guiVisible
    ToggleButton.Text = guiVisible and "★" or "☰"
end
MinBtn.MouseButton1Click:Connect(function()
    toggleGui()
end)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 16, 20)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 10)
SidebarCorner.Parent = Sidebar
local SidebarPatch = Instance.new("Frame")
SidebarPatch.Size = UDim2.new(0, 15, 1, 0)
SidebarPatch.Position = UDim2.new(1, -15, 0, 0)
SidebarPatch.BackgroundColor3 = Color3.fromRGB(15, 16, 20)
SidebarPatch.BorderSizePixel = 0
SidebarPatch.Parent = Sidebar
local Separator = Instance.new("Frame")
Separator.Size = UDim2.new(0, 1, 1, 0)
Separator.Position = UDim2.new(1, 0, 0, 0)
Separator.BackgroundColor3 = Color3.fromRGB(40, 42, 52)
Separator.BorderSizePixel = 0
Separator.Parent = Sidebar
local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 50)
Logo.BackgroundTransparency = 1
Logo.Text = "COLOR OR DIE"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 14
Logo.Parent = Sidebar
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 1, -55)
TabContainer.Position = UDim2.new(0, 0, 0, 50)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Sidebar
local TabList = Instance.new("UIListLayout")
TabList.Parent = TabContainer
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0, 4)
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -145, 1, -20)
ContentArea.Position = UDim2.new(0, 137, 0, 10)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame
local dragToggle = nil
local dragStart = nil
local startPos = nil
local function updateInput(input)
    local delta = input.Position - dragStart
    local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    TweenService:Create(MainFrame, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {Position = position}):Play()
end
MainFrame.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not UserInputService:GetFocusedTextBox() then
        dragToggle = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggle = false
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateInput(input)
    end
end)
local tabs = {}
local function createTab(tabName, displayName)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Color3.fromRGB(66, 133, 244)
    Page.Visible = false
    Page.Parent = ContentArea
    
    local List = Instance.new("UIListLayout")
    List.Parent = Page
    List.SortOrder = Enum.SortOrder.LayoutOrder
    List.Padding = UDim.new(0, 8)
    
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, -12, 0, 30)
    TabButton.Position = UDim2.new(0, 6, 0, 0)
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 31, 39)
    TabButton.BackgroundTransparency = 1
    TabButton.Text = "   " .. displayName
    TabButton.TextColor3 = Color3.fromRGB(150, 153, 162)
    TabButton.Font = Enum.Font.GothamMedium
    TabButton.TextSize = 11
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.Parent = TabContainer
    
    local TabButtonCorner = Instance.new("UICorner")
    TabButtonCorner.CornerRadius = UDim.new(0, 5)
    TabButtonCorner.Parent = TabButton
    
    local ActiveBar = Instance.new("Frame")
    ActiveBar.Size = UDim2.new(0, 3, 0.6, 0)
    ActiveBar.Position = UDim2.new(0, 4, 0.2, 0)
    ActiveBar.BackgroundColor3 = Color3.fromRGB(66, 133, 244)
    ActiveBar.BorderSizePixel = 0
    ActiveBar.Visible = false
    ActiveBar.Parent = TabButton
    
    tabs[tabName] = {Page = Page, Button = TabButton, ActiveBar = ActiveBar}
    
    TabButton.MouseButton1Click:Connect(function()
        for name, data in pairs(tabs) do
            data.Page.Visible = false
            data.Button.TextColor3 = Color3.fromRGB(150, 153, 162)
            data.Button.BackgroundTransparency = 1
            data.ActiveBar.Visible = false
        end
        Page.Visible = true
        TabButton.TextColor3 = Color3.fromRGB(66, 133, 244)
        TabButton.BackgroundTransparency = 0
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 31, 39)
        ActiveBar.Visible = true
    end)
end
createTab("Main", "Hacks")
createTab("ESP", "ESP Controls")
createTab("Guide", "Guide")
createTab("Teleport", "Teleports")
createTab("About", "Info")
tabs["Main"].Page.Visible = true
tabs["Main"].Button.TextColor3 = Color3.fromRGB(66, 133, 244)
tabs["Main"].Button.BackgroundTransparency = 0
tabs["Main"].Button.BackgroundColor3 = Color3.fromRGB(30, 31, 39)
tabs["Main"].ActiveBar.Visible = true
local speedEnabled = false
local customSpeed = 16
local jumpEnabled = false
local customJump = 50
local infJumpEnabled = false
local flyEnabled = false
local flySpeed = 50
local noclipEnabled = false
local showPaint = false
local showBrushes = false
local showTools = false
local showMonster = false
local tutorialEnabled = false
local mapEnabled = false
local espFolder = Instance.new("Folder")
espFolder.Name = "SqwssESP"
espFolder.Parent = parent
local colorMap = {
    Red = Color3.fromRGB(255, 50, 50),
    Blue = Color3.fromRGB(50, 100, 255),
    Pink = Color3.fromRGB(255, 100, 200),
    Purple = Color3.fromRGB(150, 50, 255),
    White = Color3.fromRGB(255, 255, 255),
    Teal = Color3.fromRGB(0, 200, 200),
    Orange = Color3.fromRGB(255, 150, 50),
    Green = Color3.fromRGB(50, 200, 50),
    Yellow = Color3.fromRGB(255, 255, 50)
}
local brushColor = Color3.fromRGB(255, 215, 0)
local toolColor = Color3.fromRGB(255, 100, 0)
local function makeToggle(parentPage, text, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 38)
    Frame.BackgroundColor3 = Color3.fromRGB(26, 27, 34)
    Frame.BorderSizePixel = 0
    Frame.Parent = parentPage
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 222, 230)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 44, 0, 22)
    ToggleBtn.Position = UDim2.new(1, -54, 0.5, -11)
    ToggleBtn.BackgroundColor3 = default and Color3.fromRGB(66, 133, 244) or Color3.fromRGB(48, 50, 60)
    ToggleBtn.Text = ""
    ToggleBtn.Parent = Frame
    
    local TCorner = Instance.new("UICorner")
    TCorner.CornerRadius = UDim.new(0.5, 0)
    TCorner.Parent = ToggleBtn
    
    local Ball = Instance.new("Frame")
    Ball.Size = UDim2.new(0, 16, 0, 16)
    Ball.Position = default and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    Ball.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Ball.BorderSizePixel = 0
    Ball.Parent = ToggleBtn
    
    local BCorner = Instance.new("UICorner")
    BCorner.CornerRadius = UDim.new(0.5, 0)
    BCorner.Parent = Ball
    
    local state = default
    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        local targetPos = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        local targetColor = state and Color3.fromRGB(66, 133, 244) or Color3.fromRGB(48, 50, 60)
        TweenService:Create(Ball, TweenInfo.new(0.15), {Position = targetPos}):Play()
        TweenService:Create(ToggleBtn, TweenInfo.new(0.15), {BackgroundColor3 = targetColor}):Play()
        callback(state)
    end)
    return ToggleBtn, Ball
end
local function makeSlider(parentPage, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 50)
    Frame.BackgroundColor3 = Color3.fromRGB(26, 27, 34)
    Frame.BorderSizePixel = 0
    Frame.Parent = parentPage
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0, 25)
    Label.Position = UDim2.new(0, 10, 0, 2)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 222, 230)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local ValLabel = Instance.new("TextLabel")
    ValLabel.Size = UDim2.new(0.3, 0, 0, 25)
    ValLabel.Position = UDim2.new(0.7, -10, 0, 2)
    ValLabel.BackgroundTransparency = 1
    ValLabel.Text = tostring(default)
    ValLabel.TextColor3 = Color3.fromRGB(66, 133, 244)
    ValLabel.Font = Enum.Font.GothamBold
    ValLabel.TextSize = 12
    ValLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValLabel.Parent = Frame
    
    local SlideBar = Instance.new("Frame")
    SlideBar.Size = UDim2.new(1, -20, 0, 5)
    SlideBar.Position = UDim2.new(0, 10, 0, 32)
    SlideBar.BackgroundColor3 = Color3.fromRGB(48, 50, 60)
    SlideBar.BorderSizePixel = 0
    SlideBar.Parent = Frame
    
    local SBCorner = Instance.new("UICorner")
    SBCorner.CornerRadius = UDim.new(0.5, 0)
    SBCorner.Parent = SlideBar
    
    local SlideFill = Instance.new("Frame")
    local pct = (default - min) / (max - min)
    SlideFill.Size = UDim2.new(pct, 0, 1, 0)
    SlideFill.BackgroundColor3 = Color3.fromRGB(66, 133, 244)
    SlideFill.BorderSizePixel = 0
    SlideFill.Parent = SlideBar
    
    local SFCorner = Instance.new("UICorner")
    SFCorner.CornerRadius = UDim.new(0.5, 0)
    SFCorner.Parent = SlideFill
    
    local SlideBtn = Instance.new("TextButton")
    SlideBtn.Size = UDim2.new(0, 13, 0, 13)
    SlideBtn.Position = UDim2.new(pct, -6, 0.5, -6)
    SlideBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SlideBtn.Text = ""
    SlideBtn.Parent = SlideBar
    
    local SlideCorner = Instance.new("UICorner")
    SlideCorner.CornerRadius = UDim.new(0.5, 0)
    SlideCorner.Parent = SlideBtn
    
    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - SlideBar.AbsolutePosition.X) / SlideBar.AbsoluteSize.X, 0, 1)
        SlideFill.Size = UDim2.new(pos, 0, 1, 0)
        SlideBtn.Position = UDim2.new(pos, -6, 0.5, -6)
        local value = math.round(min + (max - min) * pos)
        ValLabel.Text = tostring(value)
        callback(value)
    end
    
    SlideBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end
local function makeButton(parentPage, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 36)
    Btn.BackgroundColor3 = Color3.fromRGB(66, 133, 244)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Btn.Parent = parentPage
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end
makeToggle(tabs["Main"].Page, "WalkSpeed Hack", false, function(v) speedEnabled = v end)
makeSlider(tabs["Main"].Page, "WalkSpeed Value", 16, 150, 16, function(v) customSpeed = v end)
makeToggle(tabs["Main"].Page, "JumpPower Hack", false, function(v) jumpEnabled = v end)
makeSlider(tabs["Main"].Page, "JumpPower Value", 50, 200, 50, function(v) customJump = v end)
makeToggle(tabs["Main"].Page, "Infinite Jump", false, function(v) infJumpEnabled = v end)
local flyVelocity, flyGyro
local flyConnection
local function stopFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    local char = localPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = hrp:FindFirstChildOfClass("BodyVelocity")
            if bv then bv:Destroy() end
            local bg = hrp:FindFirstChildOfClass("BodyGyro")
            if bg then bg:Destroy() end
        end
    end
end
local function startFly()
    stopFly()
    local char = localPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    
    flyVelocity = Instance.new("BodyVelocity")
    flyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    flyVelocity.Parent = hrp
    
    flyGyro = Instance.new("BodyGyro")
    flyGyro.CFrame = hrp.CFrame
    flyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
    flyGyro.Parent = hrp
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if not hrp.Parent or not hum.Parent or not flyEnabled then
            stopFly()
            return
        end
        local camera = workspace.CurrentCamera
        local moveDir = hum.MoveDirection
        local vel = Vector3.new(0, 0, 0)
        if moveDir.Magnitude > 0 then
            local look = camera.CFrame.LookVector
            local right = camera.CFrame.RightVector
            vel = (look * moveDir.Z + right * moveDir.X).Unit * flySpeed
        end
        flyVelocity.Velocity = vel
        flyGyro.CFrame = camera.CFrame
    end)
end
makeToggle(tabs["Main"].Page, "Fly Mode", false, function(v)
    flyEnabled = v
    if v then startFly() else stopFly() end
end)
makeSlider(tabs["Main"].Page, "Fly Speed", 20, 200, 50, function(v) flySpeed = v end)
local noclipConnection
local function startNoclip()
    if noclipConnection then noclipConnection:Disconnect() end
    noclipConnection = RunService.Stepped:Connect(function()
        if noclipEnabled and localPlayer.Character then
            for _, child in ipairs(localPlayer.Character:GetDescendants()) do
                if child:IsA("BasePart") then
                    child.CanCollide = false
                end
            end
        end
    end)
end
makeToggle(tabs["Main"].Page, "Noclip (Walk Through Walls)", false, function(v)
    noclipEnabled = v
    if v then startNoclip() elseif noclipConnection then noclipConnection:Disconnect() end
end)
makeToggle(tabs["ESP"].Page, "Show Paint Buckets ESP", false, function(v) showPaint = v end)
makeToggle(tabs["ESP"].Page, "Show Brushes ESP", false, function(v) showBrushes = v end)
makeToggle(tabs["ESP"].Page, "Show Tools ESP", false, function(v) showTools = v end)
makeToggle(tabs["ESP"].Page, "Show Monster Highlight & ESP", false, function(v) showMonster = v end)
local function isModelVisible(model)
    if not model or not model.Parent then return false end
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency < 1 then
            return true
        end
    end
    return false
end
local function getLobbySpawn()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("SpawnLocation") and v.Enabled then
            return v.CFrame + Vector3.new(0, 5, 0)
        end
    end
    local lobby = workspace:FindFirstChild("Environment") and workspace.Environment:FindFirstChild("Lobby")
    local part = lobby and lobby:FindFirstChildWhichIsA("BasePart", true)
    if part then
        return part.CFrame + Vector3.new(0, 8, 0)
    end
    return CFrame.new(0, 5, 0)
end
local function getNextTutorialStep()
    local paints = {"Red", "Orange", "Yellow", "Green", "Teal", "Blue", "Purple", "Pink", "White"}
    for _, color in ipairs(paints) do
        local bucket = workspace.GameplayAssets.Items.Normal.PaintBucket:FindFirstChild(color)
        if bucket and isModelVisible(bucket) then
            return {
                Text = "Collect " .. color:upper() .. " Paint Bucket 🎨",
                Target = bucket
            }
        end
        local door = workspace.GameplayParts.Doors.Normal.Paintable:FindFirstChild(color)
        local core = door and door:FindFirstChild("Core")
        if core and core.CanCollide then
            return {
                Text = "Unlock " .. color:upper() .. " Door 🚪",
                Target = core
            }
        end
    end
    local tools = {"Puzzle", "Saw", "Hammer", "Plank", "Key", "ScrewDriver"}
    for _, tName in ipairs(tools) do
        local item
        local normal = workspace.GameplayAssets.Items.Normal.Tool:FindFirstChild(tName)
        if normal and isModelVisible(normal) then
            item = normal
        else
            local secret = workspace.GameplayAssets.Items.Secret.Tool:FindFirstChild(tName)
            if secret and isModelVisible(secret) then
                item = secret
            end
        end
        if item then
            return {
                Text = "Collect " .. tName:upper() .. " 🛠️",
                Target = item
            }
        end
        local door = workspace.GameplayParts.Doors.Normal.Unlockable:FindFirstChild(tName)
        if not door then
            door = workspace.GameplayParts.Doors.Normal.Buildable:FindFirstChild(tName)
        end
        if not door then
            door = workspace.GameplayParts.Doors.Secret.Unlockable:FindFirstChild(tName)
        end
        
        local core = door and (door:FindFirstChild("Core") or door:FindFirstChildWhichIsA("BasePart"))
        if core and core.CanCollide then
            return {
                Text = "Unlock " .. tName:upper() .. " Door 🚪",
                Target = core
            }
        end
    end
    local escape = workspace.GameplayParts.Doors.Completion:FindFirstChild("Escape")
    local core = escape and (escape:FindFirstChild("Core") or escape:FindFirstChildWhichIsA("BasePart"))
    if core and core.CanCollide then
        return {
            Text = "Escape the Maze! 🏃",
            Target = core
        }
    end
    return nil
end
local function updateTutorialHighlight(target)
    local h = workspace:FindFirstChild("SqwssTutorialHighlight")
    if not target then
        if h then h:Destroy() end
        return
    end
    if not h then
        h = Instance.new("Highlight")
        h.Name = "SqwssTutorialHighlight"
        h.FillColor = Color3.fromRGB(66, 133, 244)
        h.FillTransparency = 0.4
        h.OutlineColor = Color3.fromRGB(255, 255, 255)
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = workspace
    end
    h.Adornee = target
end
local function updateTutorialBeam(targetPart)
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not targetPart then
        if hrp then
            local att = hrp:FindFirstChild("SqwssTutorialAtt")
            if att then att:Destroy() end
            local beam = hrp:FindFirstChild("SqwssTutorialBeam")
            if beam then beam:Destroy() end
        end
        return
    end
    
    local attPlayer = hrp:FindFirstChild("SqwssTutorialAtt")
    if not attPlayer then
        attPlayer = Instance.new("Attachment")
        attPlayer.Name = "SqwssTutorialAtt"
        attPlayer.Parent = hrp
    end
    
    local attTarget = targetPart:FindFirstChild("SqwssTutorialTargetAtt")
    if not attTarget then
        attTarget = Instance.new("Attachment")
        attTarget.Name = "SqwssTutorialTargetAtt"
        attTarget.Parent = targetPart
    end
    
    local beam = hrp:FindFirstChild("SqwssTutorialBeam")
    if not beam then
        beam = Instance.new("Beam")
        beam.Name = "SqwssTutorialBeam"
        beam.Width0 = 0.2
        beam.Width1 = 0.2
        beam.FaceCamera = true
        beam.Color = ColorSequence.new(Color3.fromRGB(66, 133, 244))
        beam.TextureSpeed = 1.5
        beam.Parent = hrp
    end
    beam.Attachment0 = attPlayer
    beam.Attachment1 = attTarget
end
local function tpToCFrame(cf)
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = cf
    end
end
local TutorialGui = Instance.new("Frame")
TutorialGui.Name = "TutorialPanel"
TutorialGui.Size = UDim2.new(0, 320, 0, 36)
TutorialGui.Position = UDim2.new(0.5, -160, 0, 15)
TutorialGui.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
TutorialGui.BorderSizePixel = 0
TutorialGui.Visible = false
TutorialGui.Parent = ScreenGui
local TBCorner2 = Instance.new("UICorner")
TBCorner2.CornerRadius = UDim.new(0, 8)
TBCorner2.Parent = TutorialGui
local TBStroke2 = Instance.new("UIStroke")
TBStroke2.Color = Color3.fromRGB(66, 133, 244)
TBStroke2.Thickness = 1.2
TBStroke2.Parent = TutorialGui
local TutorialLabel = Instance.new("TextLabel")
TutorialLabel.Size = UDim2.new(1, -20, 1, 0)
TutorialLabel.Position = UDim2.new(0, 10, 0, 0)
TutorialLabel.BackgroundTransparency = 1
TutorialLabel.Text = "Objective: None"
TutorialLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
TutorialLabel.Font = Enum.Font.GothamBold
TutorialLabel.TextSize = 11
TutorialLabel.Parent = TutorialGui
local MinimapFrame = Instance.new("Frame")
MinimapFrame.Name = "SqwssMinimap"
MinimapFrame.Size = UDim2.new(0, 300, 0, 240)
MinimapFrame.Position = UDim2.new(1, -320, 0.5, -120)
MinimapFrame.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
MinimapFrame.BorderSizePixel = 0
MinimapFrame.Active = true
MinimapFrame.Visible = false
MinimapFrame.Parent = ScreenGui
local MMCorner = Instance.new("UICorner")
MMCorner.CornerRadius = UDim.new(0, 10)
MMCorner.Parent = MinimapFrame
local MMStroke = Instance.new("UIStroke")
MMStroke.Color = Color3.fromRGB(66, 133, 244)
MMStroke.Thickness = 1.2
MMStroke.Parent = MinimapFrame
local MMHeader = Instance.new("Frame")
MMHeader.Size = UDim2.new(1, 0, 0, 30)
MMHeader.BackgroundTransparency = 1
MMHeader.Parent = MinimapFrame
local MMTitle = Instance.new("TextLabel")
MMTitle.Size = UDim2.new(0.6, 0, 1, 0)
MMTitle.Position = UDim2.new(0, 12, 0, 0)
MMTitle.BackgroundTransparency = 1
MMTitle.Text = "MAZE MAP"
MMTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MMTitle.Font = Enum.Font.GothamBold
MMTitle.TextSize = 11
MMTitle.TextXAlignment = Enum.TextXAlignment.Left
MMTitle.Parent = MMHeader
local MMClose = Instance.new("TextButton")
MMClose.Size = UDim2.new(0, 16, 0, 16)
MMClose.Position = UDim2.new(1, -26, 0.5, -8)
MMClose.BackgroundColor3 = Color3.fromRGB(244, 67, 54)
MMClose.Text = "×"
MMClose.TextColor3 = Color3.fromRGB(255, 255, 255)
MMClose.Font = Enum.Font.GothamBold
MMClose.TextSize = 11
MMClose.Parent = MMHeader
local MMCCorner = Instance.new("UICorner")
MMCCorner.CornerRadius = UDim.new(0.5, 0)
MMCCorner.Parent = MMClose
local mapCanvas = Instance.new("Frame")
mapCanvas.Size = UDim2.new(0, 280, 0, 200)
mapCanvas.Position = UDim2.new(0.5, -140, 1, -205)
mapCanvas.BackgroundTransparency = 1
mapCanvas.Parent = MinimapFrame
local mapViewport = Instance.new("Frame")
mapViewport.Size = UDim2.new(0, 280, 0, 200)
mapViewport.Position = UDim2.new(0.5, -140, 1, -205)
mapViewport.BackgroundColor3 = Color3.fromRGB(15, 16, 20)
mapViewport.BorderSizePixel = 0
mapViewport.ClipsDescendants = true
mapViewport.Parent = MinimapFrame
mapCanvas.Parent = mapViewport
local MCCorner = Instance.new("UICorner")
MCCorner.CornerRadius = UDim.new(0, 6)
MCCorner.Parent = mapViewport
local zoomScale = 1.0
local panOffset = Vector2.new(0, 0)
local panning = false
local panStart = nil
local panOffsetStart = nil
local activeTouches = {}
local lastPinchDist = nil
local function updateMapLayout()
    mapCanvas.Size = UDim2.new(0, 280 * zoomScale, 0, 200 * zoomScale)
    mapCanvas.Position = UDim2.new(0.5, panOffset.X - (280 * zoomScale)/2, 0.5, panOffset.Y - (200 * zoomScale)/2)
end
mapViewport.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if input.UserInputType == Enum.UserInputType.Touch then
            activeTouches[input] = input.Position
        end
        local touchCount = 0
        for _ in pairs(activeTouches) do touchCount = touchCount + 1 end
        if touchCount < 2 then
            panning = true
            panStart = input.Position
            panOffsetStart = panOffset
        else
            panning = false
        end
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not mapEnabled or not guiVisible then return end
    if input.UserInputType == Enum.UserInputType.Touch then
        if activeTouches[input] then
            activeTouches[input] = input.Position
        end
    end
    local touchCount = 0
    local touches = {}
    for _, pos in pairs(activeTouches) do
        touchCount = touchCount + 1
        table.insert(touches, pos)
    end
    if touchCount == 2 then
        panning = false
        local dist = (touches[1] - touches[2]).Magnitude
        if lastPinchDist then
            local delta = (dist - lastPinchDist) * 0.015
            zoomScale = math.clamp(zoomScale + delta, 1.0, 8.0)
            updateMapLayout()
        end
        lastPinchDist = dist
    elseif panning and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        lastPinchDist = nil
        local delta = input.Position - panStart
        panOffset = panOffsetStart + Vector2.new(delta.X, delta.Y)
        local maxPanX = (280 * zoomScale - 280) / 2 + 100
        local maxPanY = (200 * zoomScale - 200) / 2 + 100
        panOffset = Vector2.new(
            math.clamp(panOffset.X, -maxPanX, maxPanX),
            math.clamp(panOffset.Y, -maxPanY, maxPanY)
        )
        updateMapLayout()
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if input.UserInputType == Enum.UserInputType.Touch then
            activeTouches[input] = nil
        end
        local touchCount = 0
        for _ in pairs(activeTouches) do touchCount = touchCount + 1 end
        if touchCount < 2 then
            lastPinchDist = nil
        end
        if touchCount == 0 then
            panning = false
        end
    end
end)
mapViewport.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        zoomScale = math.clamp(zoomScale + input.Position.Z * 0.15, 1.0, 8.0)
        local maxPanX = (280 * zoomScale - 280) / 2 + 100
        local maxPanY = (200 * zoomScale - 200) / 2 + 100
        panOffset = Vector2.new(
            math.clamp(panOffset.X, -maxPanX, maxPanX),
            math.clamp(panOffset.Y, -maxPanY, maxPanY)
        )
        updateMapLayout()
    end
end)
local mmDragToggle = nil
local mmDragStart = nil
local mmStartPos = nil
MMHeader.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mmDragToggle = true
        mmDragStart = input.Position
        mmStartPos = MinimapFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                mmDragToggle = false
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if mmDragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - mmDragStart
        local position = UDim2.new(mmStartPos.X.Scale, mmStartPos.X.Offset + delta.X, mmStartPos.Y.Scale, mmStartPos.Y.Offset + delta.Y)
        TweenService:Create(MinimapFrame, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {Position = position}):Play()
    end
end)
local function getPartXZBounds(part)
    local cf = part.CFrame
    local size = part.Size
    local xVectors = {
        cf:VectorToWorldSpace(Vector3.new(size.X/2, 0, 0)),
        cf:VectorToWorldSpace(Vector3.new(-size.X/2, 0, 0)),
        cf:VectorToWorldSpace(Vector3.new(0, 0, size.Z/2)),
        cf:VectorToWorldSpace(Vector3.new(0, 0, -size.Z/2))
    }
    local minX2, maxX2 = 999999, -999999
    local minZ2, maxZ2 = 999999, -999999
    for _, v in ipairs(xVectors) do
        local worldPos = cf.Position + v
        if worldPos.X < minX2 then minX2 = worldPos.X end
        if worldPos.X > maxX2 then maxX2 = worldPos.X end
        if worldPos.Z < minZ2 then minZ2 = worldPos.Z end
        if worldPos.Z > maxZ2 then maxZ2 = worldPos.Z end
    end
    return maxX2 - minX2, maxZ2 - minZ2
end
local function drawStaticWalls()
    local maze = workspace:FindFirstChild("Environment")
    maze = maze and maze:FindFirstChild("Maze")
    if not maze then return end
    
    local folders = {
        maze:FindFirstChild("BlackOutlines"),
        maze:FindFirstChild("Contour"),
        maze:FindFirstChild("BlackRoom"),
        maze:FindFirstChild("SecretPassage"),
        maze:FindFirstChild("ScrewDriverCorridor")
    }
    
    for _, folder in ipairs(folders) do
        if folder then
            for _, part in ipairs(folder:GetDescendants()) do
                if part:IsA("BasePart") and part.Transparency < 1 then
                    local w, h = getPartXZBounds(part)
                    local wPct = w / (maxX - minX)
                    local hPct = h / (maxZ - minZ)
                    local xPct = (part.Position.X - minX) / (maxX - minX)
                    local zPct = (part.Position.Z - minZ) / (maxZ - minZ)
                    
                    local wall = Instance.new("Frame")
                    wall.Size = UDim2.new(wPct, 0, hPct, 0)
                    wall.Position = UDim2.new(xPct - wPct/2, 0, zPct - hPct/2, 0)
                    wall.BackgroundColor3 = Color3.fromRGB(45, 47, 58)
                    wall.BorderSizePixel = 0
                    wall.ZIndex = 1
                    wall.Parent = mapCanvas
                end
            end
        end
    end
end
drawStaticWalls()
local mapToggleBtn, mapToggleBall
mapToggleBtn, mapToggleBall = makeToggle(tabs["Guide"].Page, "Show Maze Minimap", false, function(v)
    mapEnabled = v
    MinimapFrame.Visible = v
end)
MMClose.MouseButton1Click:Connect(function()
    mapEnabled = false
    MinimapFrame.Visible = false
    panning = false
    table.clear(activeTouches)
    lastPinchDist = nil
    TweenService:Create(mapToggleBall, TweenInfo.new(0.15), {Position = UDim2.new(0, 3, 0.5, -8)}):Play()
    TweenService:Create(mapToggleBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(48, 50, 60)}):Play()
end)
makeToggle(tabs["Guide"].Page, "Step-by-Step Tutorial Guide", false, function(v)
    tutorialEnabled = v
end)
makeButton(tabs["Guide"].Page, "Teleport to Current Objective", function()
    local step = getNextTutorialStep()
    if step and step.Target then
        local primary = step.Target:IsA("Model") and (step.Target.PrimaryPart or step.Target:FindFirstChildWhichIsA("BasePart")) or step.Target
        if primary then
            tpToCFrame(primary.CFrame * CFrame.new(0, 3, 0))
        end
    end
end)
local function updateMapMarker(key, text, pos, color, isMonster, isPlayer)
    local marker = mapMarkers[key]
    if not marker or not marker.Parent then
        marker = Instance.new("Frame")
        marker.Size = isPlayer and UDim2.new(0, 8, 0, 8) or (isMonster and UDim2.new(0, 8, 0, 8) or UDim2.new(0, 6, 0, 6))
        marker.BackgroundColor3 = color
        marker.BorderSizePixel = 0
        marker.ZIndex = isPlayer and 5 or (isMonster and 4 or 2)
        marker.Parent = mapCanvas
        
        local mc = Instance.new("UICorner")
        mc.CornerRadius = UDim.new(0.5, 0)
        mc.Parent = marker
        
        if not isPlayer and not isMonster then
            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(0, 0, 0)
            stroke.Thickness = 0.5
            stroke.Parent = marker
        end
        if isMonster or isPlayer or (not isPlayer and text ~= "") then
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0, 60, 0, 12)
            lbl.Position = UDim2.new(0.5, -30, 0, -14)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = color
            lbl.Text = text
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 7
            lbl.TextStrokeTransparency = 0.2
            lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            lbl.Parent = marker
        end
        
        mapMarkers[key] = marker
    end
    
    local xPct = (pos.X - minX) / (maxX - minX)
    local zPct = (pos.Z - minZ) / (maxZ - minZ)
    marker.Position = UDim2.new(xPct, -marker.Size.X.Offset/2, zPct, -marker.Size.Y.Offset/2)
    marker.Visible = true
end
makeButton(tabs["Teleport"].Page, "Teleport to Spawn / Safe Zone", function()
    tpToCFrame(getLobbySpawn())
end)
makeButton(tabs["Teleport"].Page, "Teleport to Next Brush", function()
    local cc = workspace:FindFirstChild("GameplayAssets")
    cc = cc and cc:FindFirstChild("Items")
    cc = cc and cc:FindFirstChild("Collectable")
    cc = cc and cc:FindFirstChild("Collectable")
    if cc then
        for _, model in ipairs(cc:GetChildren()) do
            if model:IsA("Model") and isModelVisible(model) then
                local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                if primary then
                    tpToCFrame(primary.CFrame * CFrame.new(0, 3, 0))
                    break
                end
            end
        end
    end
end)
local function makeGridLabel(parentPage, text)
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, -10, 0, 24)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = text
    Lbl.TextColor3 = Color3.fromRGB(180, 182, 190)
    Lbl.Font = Enum.Font.GothamBold
    Lbl.TextSize = 11
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = parentPage
end
makeGridLabel(tabs["Teleport"].Page, "PAINT BUCKETS:")
local paints = {"Red", "Blue", "Pink", "Purple", "White", "Teal", "Orange", "Green", "Yellow"}
for _, paintName in ipairs(paints) do
    local btn = makeButton(tabs["Teleport"].Page, "TP to " .. paintName .. " Bucket", function()
        local pb = workspace:FindFirstChild("GameplayAssets")
        pb = pb and pb:FindFirstChild("Items")
        pb = pb and pb:FindFirstChild("Normal")
        pb = pb and pb:FindFirstChild("PaintBucket")
        local model = pb and pb:FindFirstChild(paintName)
        if model and isModelVisible(model) then
            local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
            if primary then
                tpToCFrame(primary.CFrame * CFrame.new(0, 3, 0))
            end
        end
    end)
    btn.BackgroundColor3 = colorMap[paintName] or Color3.fromRGB(66, 133, 244)
    if paintName == "White" or paintName == "Yellow" then
        btn.TextColor3 = Color3.fromRGB(15, 16, 20)
    end
end
makeGridLabel(tabs["Teleport"].Page, "TOOLS:")
local tools = {"Puzzle", "Saw", "Hammer", "Plank", "Key", "ScrewDriver"}
for _, toolName in ipairs(tools) do
    makeButton(tabs["Teleport"].Page, "TP to " .. toolName, function()
        local items = workspace:FindFirstChild("GameplayAssets")
        items = items and items:FindFirstChild("Items")
        if items then
            local model
            local normal = items:FindFirstChild("Normal")
            local normTool = normal and normal:FindFirstChild("Tool")
            model = normTool and normTool:FindFirstChild(toolName)
            if not model or not isModelVisible(model) then
                local secret = items:FindFirstChild("Secret")
                local secTool = secret and secret:FindFirstChild("Tool")
                model = secTool and secTool:FindFirstChild(toolName)
            end
            if model and isModelVisible(model) then
                local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                if primary then
                    tpToCFrame(primary.CFrame * CFrame.new(0, 3, 0))
                end
            end
        end
    end)
end
local AboutTitle = Instance.new("TextLabel")
AboutTitle.Size = UDim2.new(1, 0, 0, 30)
AboutTitle.BackgroundTransparency = 1
AboutTitle.Text = "COLOR OR DIE HACK"
AboutTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
AboutTitle.Font = Enum.Font.GothamBold
AboutTitle.TextSize = 18
AboutTitle.TextXAlignment = Enum.TextXAlignment.Left
AboutTitle.Parent = tabs["About"].Page
local AboutText = Instance.new("TextLabel")
AboutText.Size = UDim2.new(1, 0, 1, -40)
AboutText.Position = UDim2.new(0, 0, 0, 35)
AboutText.BackgroundTransparency = 1
AboutText.Text = "Developer / Creator:\nsqwss\n\nFeatures:\n- Item ESP (Paint, Brushes, Tools)\n- Monster Highlight / Chams\n- Speed & Jump adjustments\n- Fly, Noclip & Infinite Jump\n- Item Teleports\n- Step-by-step Game Guide & Beam Tracer\n- 2D Maze Minimap Window\n\nEnjoy the game!"
AboutText.TextColor3 = Color3.fromRGB(180, 182, 190)
AboutText.Font = Enum.Font.GothamMedium
AboutText.TextSize = 13
AboutText.TextXAlignment = Enum.TextXAlignment.Left
AboutText.TextYAlignment = Enum.TextYAlignment.Top
AboutText.Parent = tabs["About"].Page
local activeLabels = {}
RunService.RenderStepped:Connect(function()
    local char = localPlayer.Character
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    
    if not (showPaint or showBrushes or showTools or showMonster) then
        espFolder:ClearAllChildren()
        table.clear(activeLabels)
        return
    end
    
    local targets = {}
    
    if showPaint then
        local pb = workspace:FindFirstChild("GameplayAssets")
        pb = pb and pb:FindFirstChild("Items")
        pb = pb and pb:FindFirstChild("Normal")
        pb = pb and pb:FindFirstChild("PaintBucket")
        if pb then
            for _, model in ipairs(pb:GetChildren()) do
                if model:IsA("Model") and isModelVisible(model) then
                    table.insert(targets, {
                        Model = model,
                        Text = model.Name .. " Paint",
                        Color = colorMap[model.Name] or Color3.fromRGB(255, 255, 255)
                    })
                end
            end
        end
    end
    
    if showBrushes then
        local cc = workspace:FindFirstChild("GameplayAssets")
        cc = cc and cc:FindFirstChild("Items")
        cc = cc and cc:FindFirstChild("Collectable")
        cc = cc and cc:FindFirstChild("Collectable")
        if cc then
            for _, model in ipairs(cc:GetChildren()) do
                if model:IsA("Model") and isModelVisible(model) then
                    table.insert(targets, {
                        Model = model,
                        Text = "Brush " .. model.Name,
                        Color = brushColor
                    })
                end
            end
        end
    end
    
    if showTools then
        local items = workspace:FindFirstChild("GameplayAssets")
        items = items and items:FindFirstChild("Items")
        if items then
            local folders = {items:FindFirstChild("Normal"), items:FindFirstChild("Secret")}
            for _, folder in ipairs(folders) do
                local toolFolder = folder and folder:FindFirstChild("Tool")
                if toolFolder then
                    for _, model in ipairs(toolFolder:GetChildren()) do
                        if model:IsA("Model") and isModelVisible(model) then
                            table.insert(targets, {
                                Model = model,
                                Text = model.Name,
                                Color = toolColor
                            })
                        end
                    end
                end
            end
        end
    end
    
    if showMonster then
        local monsters = workspace:FindFirstChild("GameplayAssets")
        monsters = monsters and monsters:FindFirstChild("Monsters")
        if monsters then
            for _, model in ipairs(monsters:GetChildren()) do
                if model:IsA("Model") then
                    table.insert(targets, {
                        Model = model,
                        Text = "MONSTER",
                        Color = Color3.fromRGB(255, 50, 50)
                    })
                    local highlight = model:FindFirstChild("SqwssMonsterHighlight")
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "SqwssMonsterHighlight"
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.FillTransparency = 0.5
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.Parent = model
                    end
                end
            end
        end
    else
        local monsters = workspace:FindFirstChild("GameplayAssets")
        monsters = monsters and monsters:FindFirstChild("Monsters")
        if monsters then
            for _, model in ipairs(monsters:GetChildren()) do
                local h = model:FindFirstChild("SqwssMonsterHighlight")
                if h then h:Destroy() end
            end
        end
    end
    
    local currentKeys = {}
    for _, t in ipairs(targets) do
        local model = t.Model
        local key = model:GetFullName()
        currentKeys[key] = true
        
        local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
        if primary then
            local dist = rootPart and math.round((rootPart.Position - primary.Position).Magnitude) or 0
            local labelText = t.Text .. " [" .. dist .. "m]"
            
            local bGui = activeLabels[key]
            if not bGui or not bGui.Parent then
                bGui = Instance.new("BillboardGui")
                bGui.Size = UDim2.new(0, 100, 0, 30)
                bGui.AlwaysOnTop = true
                bGui.Adornee = primary
                bGui.Parent = espFolder
                
                local tLabel = Instance.new("TextLabel")
                tLabel.Size = UDim2.new(1, 0, 1, 0)
                tLabel.BackgroundTransparency = 1
                tLabel.TextColor3 = t.Color
                tLabel.Font = Enum.Font.GothamBold
                tLabel.TextSize = 10
                tLabel.TextStrokeTransparency = 0.2
                tLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                tLabel.Parent = bGui
                
                activeLabels[key] = bGui
            end
            bGui.TextLabel.Text = labelText
        end
    end
    
    for key, bGui in pairs(activeLabels) do
        if not currentKeys[key] then
            bGui:Destroy()
            activeLabels[key] = nil
        end
    end
end)
RunService.RenderStepped:Connect(function()
    if not tutorialEnabled then
        TutorialGui.Visible = false
        updateTutorialHighlight(nil)
        updateTutorialBeam(nil)
        return
    end
    
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    local step = getNextTutorialStep()
    if step and step.Target and hrp then
        TutorialGui.Visible = true
        local primary = step.Target:IsA("Model") and (step.Target.PrimaryPart or step.Target:FindFirstChildWhichIsA("BasePart")) or step.Target
        if primary then
            local dist = math.round((hrp.Position - primary.Position).Magnitude)
            TutorialLabel.Text = step.Text .. " [" .. dist .. "m]"
            updateTutorialHighlight(step.Target)
            updateTutorialBeam(primary)
        else
            TutorialLabel.Text = step.Text
            updateTutorialHighlight(step.Target)
            updateTutorialBeam(nil)
        end
    else
        TutorialGui.Visible = true
        TutorialLabel.Text = step and step.Text or "All steps completed! 🎉"
        updateTutorialHighlight(nil)
        updateTutorialBeam(nil)
    end
end)
RunService.RenderStepped:Connect(function()
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    local showMap = mapEnabled and guiVisible
    if not showMap then
        for _, marker in pairs(mapMarkers) do
            marker.Visible = false
        end
        return
    end
    
    local activeKeys = {}
    
    if hrp then
        updateMapMarker("Player", "YOU", hrp.Position, Color3.fromRGB(50, 255, 50), false, true)
        activeKeys["Player"] = true
    end
    
    local monsters = workspace:FindFirstChild("GameplayAssets")
    monsters = monsters and monsters:FindFirstChild("Monsters")
    if monsters then
        for _, model in ipairs(monsters:GetChildren()) do
            if model:IsA("Model") then
                local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                if primary then
                    local key = "Monster_" .. model.Name
                    updateMapMarker(key, "💀", primary.Position, Color3.fromRGB(255, 50, 50), true, false)
                    activeKeys[key] = true
                end
            end
        end
    end
    
    local doors = workspace:FindFirstChild("GameplayParts")
    doors = doors and doors:FindFirstChild("Doors")
    if doors then
        local catNames = {"Normal", "Secret", "Completion"}
        for _, catName in ipairs(catNames) do
            local cat = doors:FindFirstChild(catName)
            if cat then
                for _, sub in ipairs(cat:GetChildren()) do
                    if sub:IsA("Folder") then
                        for _, door in ipairs(sub:GetChildren()) do
                            if door:IsA("Model") then
                                local core = door:FindFirstChild("Core") or door:FindFirstChildWhichIsA("BasePart")
                                if core and core.CanCollide then
                                    local key = "Door_" .. door:GetFullName()
                                    local color = colorMap[door.Name] or Color3.fromRGB(200, 200, 200)
                                    updateMapMarker(key, door.Name, core.Position, color, false, false)
                                    activeKeys[key] = true
                                end
                            end
                        end
                    elseif sub:IsA("Model") then
                        local core = sub:FindFirstChild("Core") or sub:FindFirstChildWhichIsA("BasePart")
                        if core and core.CanCollide then
                            local key = "Door_" .. sub:GetFullName()
                            updateMapMarker(key, sub.Name, core.Position, Color3.fromRGB(255, 255, 255), false, false)
                            activeKeys[key] = true
                        end
                    end
                end
            end
        end
    end
    
    for key, marker in pairs(mapMarkers) do
        if not activeKeys[key] then
            marker.Visible = false
        end
    end
end)
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and localPlayer.Character then
        local hum = localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
RunService.RenderStepped:Connect(function()
    if localPlayer.Character then
        local hum = localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            if speedEnabled then
                hum.WalkSpeed = customSpeed
            end
            if jumpEnabled then
                hum.JumpPower = customJump
                hum.UseJumpPower = true
            end
        end
    end
end)
ToggleButton.MouseButton1Click:Connect(toggleGui)
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed then
        if input.KeyCode == Enum.KeyCode.Insert or input.KeyCode == Enum.KeyCode.RightShift then
            toggleGui()
        end
    end
end)
