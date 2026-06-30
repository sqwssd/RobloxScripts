local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local localPlayer = Players.LocalPlayer
local function cleanupOldUI()
    local name = "ObbyHub"
    if CoreGui:FindFirstChild(name) then CoreGui[name]:Destroy() end
    if localPlayer:WaitForChild("PlayerGui"):FindFirstChild(name) then 
        localPlayer.PlayerGui[name]:Destroy() 
    end
end
cleanupOldUI()
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ObbyHub"
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
MainFrame.Size = UDim2.new(0, 420, 0, 280)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
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
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, -25)
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
Logo.Text = "OBBY PRO"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 13
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
ContentArea.Size = UDim2.new(1, -135, 1, -40)
ContentArea.Position = UDim2.new(0, 127, 0, 10)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame
local StatusBar = Instance.new("TextLabel")
StatusBar.Size = UDim2.new(1, 0, 0, 25)
StatusBar.Position = UDim2.new(0, 0, 1, -25)
StatusBar.BackgroundColor3 = Color3.fromRGB(12, 13, 17)
StatusBar.BorderSizePixel = 0
StatusBar.Text = "  Status: Idle"
StatusBar.TextColor3 = Color3.fromRGB(140, 142, 150)
StatusBar.Font = Enum.Font.GothamMedium
StatusBar.TextSize = 10
StatusBar.TextXAlignment = Enum.TextXAlignment.Left
StatusBar.Parent = MainFrame
local StatusSeparator = Instance.new("Frame")
StatusSeparator.Size = UDim2.new(1, 0, 0, 1)
StatusSeparator.BackgroundColor3 = Color3.fromRGB(40, 42, 52)
StatusSeparator.BorderSizePixel = 0
StatusSeparator.Parent = StatusBar
local dragToggle = nil
local dragStart = nil
local startPos = nil
local function updateInput(input)
    local delta = input.Position - dragStart
    local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    TweenService:Create(MainFrame, TweenInfo.new(0.08, Enum.EasingStyle.OutQuad), {Position = position}):Play()
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
    
    local PageList = Instance.new("UIListLayout")
    PageList.Parent = Page
    PageList.SortOrder = Enum.SortOrder.LayoutOrder
    PageList.Padding = UDim.new(0, 6)
    
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
createTab("Main", "Functions")
createTab("Autopass", "Auto Pass")
createTab("Teleports", "Teleports")
tabs["Main"].Page.Visible = true
tabs["Main"].Button.TextColor3 = Color3.fromRGB(66, 133, 244)
tabs["Main"].Button.BackgroundTransparency = 0
tabs["Main"].Button.BackgroundColor3 = Color3.fromRGB(30, 31, 39)
tabs["Main"].ActiveBar.Visible = true
local function addToggle(tabName, text, default, callback)
    local page = tabs[tabName].Page
    local state = default
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(26, 27, 34)
    Frame.BorderSizePixel = 0
    Frame.Parent = page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 222, 230)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12.5
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local ToggleBg = Instance.new("TextButton")
    ToggleBg.Size = UDim2.new(0, 40, 0, 20)
    ToggleBg.Position = UDim2.new(1, -52, 0.5, -10)
    ToggleBg.BackgroundColor3 = default and Color3.fromRGB(66, 133, 244) or Color3.fromRGB(48, 50, 60)
    ToggleBg.Text = ""
    ToggleBg.AutoButtonColor = false
    ToggleBg.Parent = Frame
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(0.5, 0)
    SwitchCorner.Parent = ToggleBg
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BorderSizePixel = 0
    Circle.Parent = ToggleBg
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(0.5, 0)
    CircleCorner.Parent = Circle
    
    ToggleBg.MouseButton1Click:Connect(function()
        state = not state
        local targetColor = state and Color3.fromRGB(66, 133, 244) or Color3.fromRGB(48, 50, 60)
        local targetPosition = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        
        TweenService:Create(ToggleBg, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(Circle, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPosition}):Play()
        
        callback(state)
    end)
end
local function addTextBox(tabName, labelText, placeholderText, callback)
    local page = tabs[tabName].Page
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 36)
    Frame.BackgroundColor3 = Color3.fromRGB(26, 27, 34)
    Frame.BorderSizePixel = 0
    Frame.Parent = page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(220, 222, 230)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12.5
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0.28, 0, 0, 22)
    TextBox.Position = UDim2.new(1, -75, 0.5, -11)
    TextBox.BackgroundColor3 = Color3.fromRGB(36, 37, 46)
    TextBox.BorderSizePixel = 0
    TextBox.Text = ""
    TextBox.PlaceholderText = placeholderText
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.PlaceholderColor3 = Color3.fromRGB(110, 110, 120)
    TextBox.Font = Enum.Font.GothamMedium
    TextBox.TextSize = 11
    TextBox.Parent = Frame
    
    local TBCorner = Instance.new("UICorner")
    TBCorner.CornerRadius = UDim.new(0, 4)
    TBCorner.Parent = TextBox
    
    TextBox.FocusLost:Connect(function(enterPressed)
        callback(TextBox.Text)
    end)
end
local function addButton(tabName, text, callback)
    local page = tabs[tabName].Page
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 36)
    Frame.BackgroundColor3 = Color3.fromRGB(26, 27, 34)
    Frame.BorderSizePixel = 0
    Frame.Parent = page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(66, 133, 244)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 12
    Button.Parent = Frame
    
    Button.MouseButton1Click:Connect(callback)
end
local statusPass = "Idle"
local statusJump = "Off"
local function updateStatusBar()
    StatusBar.Text = string.format("  Status: Pass [%s] | InfJump [%s]", statusPass, statusJump)
end
local infJump = false
addToggle("Main", "Infinite Jump", false, function(v)
    infJump = v
    statusJump = infJump and "On" or "Off"
    updateStatusBar()
end)
UserInputService.JumpRequest:Connect(function()
    if infJump then
        local character = localPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
addTextBox("Main", "Walk Speed", "16", function(text)
    local val = tonumber(text)
    if val then
        local character = localPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = val
        end
    end
end)
addTextBox("Main", "Jump Power", "50", function(text)
    local val = tonumber(text)
    if val then
        local character = localPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = val
        end
    end
end)
local function getCheckpointsCount()
    local maxCp = 0
    if workspace:FindFirstChild("Checkpoints") then
        for _, cp in ipairs(workspace.Checkpoints:GetChildren()) do
            local num = tonumber(cp.Name)
            if num and num > maxCp then
                maxCp = num
            end
        end
    end
    return maxCp
end
local function safeTeleport(targetPart)
    local character = localPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp or not targetPart then return end
    
    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    
    if firetouchinterest then
        firetouchinterest(hrp, targetPart, 0)
        task.wait()
        firetouchinterest(hrp, targetPart, 1)
    end
    
    hrp.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
end
local autoPassing = false
local passDelay = 0.15
addTextBox("Autopass", "Pass Speed (delay sec)", "0.15", function(text)
    local val = tonumber(text)
    if val then passDelay = val end
end)
addButton("Autopass", "Start Auto Pass", function()
    if autoPassing then return end
    autoPassing = true
    
    task.spawn(function()
        local maxCp = getCheckpointsCount()
        local currentStage = 0
        local leaderstats = localPlayer:FindFirstChild("leaderstats")
        if leaderstats and leaderstats:FindFirstChild("Stage") then
            currentStage = leaderstats.Stage.Value
        end
        
        for i = currentStage + 1, maxCp do
            if not autoPassing then break end
            
            local cp = workspace.Checkpoints:FindFirstChild(tostring(i))
            if cp then
                statusPass = string.format("Passing %d/%d", i, maxCp)
                updateStatusBar()
                safeTeleport(cp)
                task.wait(passDelay)
            end
        end
        
        autoPassing = false
        statusPass = "Finished"
        updateStatusBar()
    end)
end)
addButton("Autopass", "Stop Auto Pass", function()
    autoPassing = false
    statusPass = "Stopped"
    updateStatusBar()
end)
local targetStage = ""
addTextBox("Teleports", "Enter Stage Number", "0", function(text)
    targetStage = text
end)
addButton("Teleports", "Teleport to Stage", function()
    if targetStage ~= "" then
        local cp = workspace.Checkpoints:FindFirstChild(targetStage)
        if cp then
            safeTeleport(cp)
            statusPass = "Teleported"
            updateStatusBar()
        end
    end
end)
local guiVisible = true
local function toggleGui()
    guiVisible = not guiVisible
    MainFrame.Visible = guiVisible
    ToggleButton.Text = guiVisible and "★" or "☰"
end
ToggleButton.MouseButton1Click:Connect(toggleGui)
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed then
        if input.KeyCode == Enum.KeyCode.Insert or input.KeyCode == Enum.KeyCode.RightShift then
            toggleGui()
        end
    end
end)
updateStatusBar()
