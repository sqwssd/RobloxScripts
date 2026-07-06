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
local screenGuiName = "SqwssMM2Hub"

if globalEnv.SqwssMM2Connections then
    for _, conn in ipairs(globalEnv.SqwssMM2Connections) do
        pcall(function() conn:Disconnect() end)
    end
end
globalEnv.SqwssMM2Connections = {}

if globalEnv.SqwssMM2Threads then
    for _, thread in ipairs(globalEnv.SqwssMM2Threads) do
        pcall(function() task.cancel(thread) end)
    end
end
globalEnv.SqwssMM2Threads = {}

local function cleanupAll()
    if globalEnv.SqwssMM2Connections then
        for _, conn in ipairs(globalEnv.SqwssMM2Connections) do
            pcall(function() conn:Disconnect() end)
        end
    end
    if globalEnv.SqwssMM2Threads then
        for _, thread in ipairs(globalEnv.SqwssMM2Threads) do
            pcall(function() task.cancel(thread) end)
        end
    end
    
    pcall(function()
        if CoreGui:FindFirstChild(screenGuiName) then CoreGui[screenGuiName]:Destroy() end
    end)
    pcall(function()
        if localPlayer:WaitForChild("PlayerGui"):FindFirstChild(screenGuiName) then 
            localPlayer.PlayerGui[screenGuiName]:Destroy() 
        end
    end)
    
    for _, p in ipairs(Players:GetPlayers()) do
        pcall(function()
            local char = p.Character
            if char then
                if char:FindFirstChild("SqwssESP_Highlight") then char.SqwssESP_Highlight:Destroy() end
                local head = char:FindFirstChild("Head")
                if head and head:FindFirstChild("SqwssESP_Tag") then head.SqwssESP_Tag:Destroy() end
            end
        end)
    end
    
    pcall(function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v.Name == "SqwssGunESP_Highlight" or v.Name == "SqwssGunESP_Tag" then
                v:Destroy()
            end
        end
    end)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = screenGuiName
ScreenGui.ResetOnSpawn = false
local parent = (RunService:IsStudio() or not pcall(function() local x = CoreGui.Name end)) and localPlayer:WaitForChild("PlayerGui") or CoreGui
ScreenGui.Parent = parent

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 46, 0, 46)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -23)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 16, 20)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "★"
ToggleButton.TextColor3 = Color3.fromRGB(66, 133, 244)
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
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(17, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(30, 32, 40)
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame

local dragToggle = nil
local dragStart = nil
local startPos = nil
local isDraggingSlider = false

local function updateDragInput(input)
    if isDraggingSlider then return end
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

table.insert(globalEnv.SqwssMM2Connections, UserInputService.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateDragInput(input)
    end
end))

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 50, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 13, 17)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 10)
SidebarCorner.Parent = Sidebar

local SidebarPatch = Instance.new("Frame")
SidebarPatch.Size = UDim2.new(0, 10, 1, 0)
SidebarPatch.Position = UDim2.new(1, -10, 0, 0)
SidebarPatch.BackgroundColor3 = Color3.fromRGB(12, 13, 17)
SidebarPatch.BorderSizePixel = 0
SidebarPatch.Parent = Sidebar

local Separator = Instance.new("Frame")
Separator.Size = UDim2.new(0, 1, 1, 0)
Separator.Position = UDim2.new(1, 0, 0, 0)
Separator.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
Separator.BorderSizePixel = 0
Separator.Parent = Sidebar

local LogoLabel = Instance.new("ImageLabel")
LogoLabel.Size = UDim2.new(0, 20, 0, 20)
LogoLabel.Position = UDim2.new(0.5, -10, 0, 15)
LogoLabel.BackgroundTransparency = 1
LogoLabel.Image = "rbxassetid://10888987118"
LogoLabel.ImageColor3 = Color3.fromRGB(66, 133, 244)
LogoLabel.Parent = Sidebar

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 1, -60)
TabContainer.Position = UDim2.new(0, 0, 0, 50)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Sidebar

local TabList = Instance.new("UIListLayout")
TabList.Parent = TabContainer
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0, 4)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, -50, 0, 50)
Topbar.Position = UDim2.new(0, 50, 0, 0)
Topbar.BackgroundTransparency = 1
Topbar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.3, 0, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Player"
Title.TextColor3 = Color3.fromRGB(240, 240, 245)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

local SearchFrame = Instance.new("Frame")
SearchFrame.Size = UDim2.new(0, 150, 0, 24)
SearchFrame.Position = UDim2.new(0.3, 10, 0.5, -12)
SearchFrame.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
SearchFrame.BorderSizePixel = 0
SearchFrame.Parent = Topbar

local SFCorner = Instance.new("UICorner")
SFCorner.CornerRadius = UDim.new(0, 6)
SFCorner.Parent = SearchFrame

local SearchIcon = Instance.new("TextLabel")
SearchIcon.Size = UDim2.new(0, 24, 1, 0)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Text = "🔍"
SearchIcon.TextColor3 = Color3.fromRGB(100, 103, 112)
SearchIcon.Font = Enum.Font.GothamMedium
SearchIcon.TextSize = 11
SearchIcon.Parent = SearchFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -30, 1, 0)
SearchBox.Position = UDim2.new(0, 26, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.Text = ""
SearchBox.PlaceholderText = "Search..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(80, 83, 92)
SearchBox.TextColor3 = Color3.fromRGB(240, 240, 245)
SearchBox.Font = Enum.Font.GothamMedium
SearchBox.TextSize = 11
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.Parent = SearchFrame

local SwitchViewBtn = Instance.new("TextButton")
SwitchViewBtn.Size = UDim2.new(0, 85, 0, 24)
SwitchViewBtn.Position = UDim2.new(0.3, 170, 0.5, -12)
SwitchViewBtn.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
SwitchViewBtn.Text = "switch view"
SwitchViewBtn.TextColor3 = Color3.fromRGB(150, 153, 162)
SwitchViewBtn.Font = Enum.Font.GothamMedium
SwitchViewBtn.TextSize = 10
SwitchViewBtn.Parent = Topbar

local SVCorner = Instance.new("UICorner")
SVCorner.CornerRadius = UDim.new(0, 6)
SVCorner.Parent = SwitchViewBtn

local SVStroke = Instance.new("UIStroke")
SVStroke.Color = Color3.fromRGB(36, 38, 46)
SVStroke.Thickness = 1
SVStroke.Parent = SwitchViewBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -30, 0.5, -10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(244, 67, 54)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = Topbar

local CBCorner = Instance.new("UICorner")
CBCorner.CornerRadius = UDim.new(0.5, 0)
CBCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    cleanupAll()
end)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 20, 0, 20)
MinBtn.Position = UDim2.new(1, -55, 0.5, -10)
MinBtn.BackgroundColor3 = Color3.fromRGB(48, 50, 60)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14
MinBtn.Parent = Topbar

local MBCorner = Instance.new("UICorner")
MBCorner.CornerRadius = UDim.new(0.5, 0)
MBCorner.Parent = MinBtn

local guiVisible = true
local function toggleGui()
    guiVisible = not guiVisible
    MainFrame.Visible = guiVisible
    ToggleButton.Visible = not guiVisible
end

MinBtn.MouseButton1Click:Connect(toggleGui)
ToggleButton.MouseButton1Click:Connect(toggleGui)
ToggleButton.Visible = false

local TopSeparator = Instance.new("Frame")
TopSeparator.Size = UDim2.new(1, -50, 0, 1)
TopSeparator.Position = UDim2.new(0, 50, 0, 50)
TopSeparator.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
TopSeparator.BorderSizePixel = 0
TopSeparator.Parent = MainFrame

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -65, 1, -65)
ContentArea.Position = UDim2.new(0, 60, 0, 60)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local tabs = {}
local function createTab(tabName, displayName, iconAsset)
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
    List.Padding = UDim.new(0, 0)
    
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 36, 0, 36)
    TabButton.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
    TabButton.BackgroundTransparency = 1
    TabButton.Text = ""
    TabButton.Parent = TabContainer
    
    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 18, 0, 18)
    Icon.Position = UDim2.new(0.5, -9, 0.5, -9)
    Icon.BackgroundTransparency = 1
    Icon.Image = iconAsset
    Icon.ImageColor3 = Color3.fromRGB(150, 153, 162)
    Icon.Parent = TabButton
    
    local ActiveBar = Instance.new("Frame")
    ActiveBar.Size = UDim2.new(0, 3, 0.5, 0)
    ActiveBar.Position = UDim2.new(0, 2, 0.25, 0)
    ActiveBar.BackgroundColor3 = Color3.fromRGB(66, 133, 244)
    ActiveBar.BorderSizePixel = 0
    ActiveBar.Visible = false
    ActiveBar.Parent = TabButton
    
    tabs[tabName] = {Page = Page, Button = TabButton, Icon = Icon, ActiveBar = ActiveBar, TitleText = displayName}
    
    TabButton.MouseButton1Click:Connect(function()
        for name, data in pairs(tabs) do
            data.Page.Visible = false
            data.Icon.ImageColor3 = Color3.fromRGB(150, 153, 162)
            data.Button.BackgroundTransparency = 1
            data.ActiveBar.Visible = false
        end
        Page.Visible = true
        Icon.ImageColor3 = Color3.fromRGB(66, 133, 244)
        TabButton.BackgroundTransparency = 0
        TabButton.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
        ActiveBar.Visible = true
        Title.Text = displayName
    end)
end

local function makeSectionHeader(parentPage, text)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 30)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parentPage
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.Position = UDim2.new(0, 0, 0, 4)
    Label.BackgroundTransparency = 1
    Label.Text = text:upper()
    Label.TextColor3 = Color3.fromRGB(80, 85, 95)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 9
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
end

local binds = {}
local bindButtons = {}
local listeningForAction = nil
local triggers = {}

local function createBindBtn(parentFrame, actionName, xOffset)
    local BindBtn = Instance.new("TextButton")
    BindBtn.Size = UDim2.new(0, 48, 0, 18)
    BindBtn.Position = UDim2.new(1, xOffset, 0.5, -9)
    BindBtn.BackgroundTransparency = 1
    BindBtn.Text = "[ None ]"
    BindBtn.TextColor3 = Color3.fromRGB(120, 122, 130)
    BindBtn.Font = Enum.Font.GothamMedium
    BindBtn.TextSize = 9
    BindBtn.Parent = parentFrame
    
    bindButtons[actionName] = BindBtn
    
    BindBtn.MouseButton1Click:Connect(function()
        if listeningForAction == actionName then
            listeningForAction = nil
            BindBtn.Text = binds[actionName] and "[ " .. binds[actionName].Name .. " ]" or "[ None ]"
            BindBtn.TextColor3 = binds[actionName] and Color3.fromRGB(66, 133, 244) or Color3.fromRGB(120, 122, 130)
            return
        end
        if listeningForAction then
            local oldAct = listeningForAction
            listeningForAction = nil
            bindButtons[oldAct].Text = binds[oldAct] and "[ " .. binds[oldAct].Name .. " ]" or "[ None ]"
            bindButtons[oldAct].TextColor3 = binds[oldAct] and Color3.fromRGB(66, 133, 244) or Color3.fromRGB(120, 122, 130)
        end
        listeningForAction = actionName
        BindBtn.Text = "[ ... ]"
        BindBtn.TextColor3 = Color3.fromRGB(66, 133, 244)
    end)
end

table.insert(globalEnv.SqwssMM2Connections, UserInputService.InputBegan:Connect(function(input)
    if UserInputService:GetFocusedTextBox() then return end
    
    if listeningForAction then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local key = input.KeyCode
            local action = listeningForAction
            listeningForAction = nil
            
            if key == Enum.KeyCode.Backspace or key == Enum.KeyCode.Escape then
                binds[action] = nil
                bindButtons[action].Text = "[ None ]"
                bindButtons[action].TextColor3 = Color3.fromRGB(120, 122, 130)
            else
                binds[action] = key
                bindButtons[action].Text = "[ " .. key.Name .. " ]"
                bindButtons[action].TextColor3 = Color3.fromRGB(66, 133, 244)
            end
        end
        return
    end
    
    if input.UserInputType == Enum.UserInputType.Keyboard then
        for action, key in pairs(binds) do
            if input.KeyCode == key then
                local trigger = triggers[action]
                if trigger then
                    pcall(trigger)
                end
            end
        end
    end
end))

local function makeToggle(parentPage, actionName, text, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 36)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parentPage
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 202, 210)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 38, 0, 18)
    ToggleBtn.Position = UDim2.new(1, -48, 0.5, -9)
    ToggleBtn.BackgroundColor3 = default and Color3.fromRGB(66, 133, 244) or Color3.fromRGB(34, 37, 48)
    ToggleBtn.Text = ""
    ToggleBtn.Parent = Frame
    
    local TCorner = Instance.new("UICorner")
    TCorner.CornerRadius = UDim.new(0.5, 0)
    TCorner.Parent = ToggleBtn
    
    local Ball = Instance.new("Frame")
    Ball.Size = UDim2.new(0, 14, 0, 14)
    Ball.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    Ball.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Ball.BorderSizePixel = 0
    Ball.Parent = ToggleBtn
    
    local BCorner = Instance.new("UICorner")
    BCorner.CornerRadius = UDim.new(0.5, 0)
    BCorner.Parent = Ball
    
    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, 0, 0, 1)
    Line.Position = UDim2.new(0, 0, 1, -1)
    Line.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
    Line.BorderSizePixel = 0
    Line.Parent = Frame
    
    createBindBtn(Frame, actionName, -106)
    
    local state = default
    local function toggleState(newState)
        if newState == nil then
            state = not state
        else
            state = newState
        end
        local targetPos = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        local targetColor = state and Color3.fromRGB(66, 133, 244) or Color3.fromRGB(34, 37, 48)
        TweenService:Create(Ball, TweenInfo.new(0.12), {Position = targetPos}):Play()
        TweenService:Create(ToggleBtn, TweenInfo.new(0.12), {BackgroundColor3 = targetColor}):Play()
        callback(state)
    end
    
    ToggleBtn.MouseButton1Click:Connect(function()
        toggleState()
    end)
    
    triggers[actionName] = toggleState
    return ToggleBtn, Ball
end

local function makeSlider(parentPage, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 48)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parentPage
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0, 24)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 202, 210)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local ValLabel = Instance.new("TextLabel")
    ValLabel.Size = UDim2.new(0.3, 0, 0, 24)
    ValLabel.Position = UDim2.new(0.7, 0, 0, 0)
    ValLabel.BackgroundTransparency = 1
    ValLabel.Text = tostring(default)
    ValLabel.TextColor3 = Color3.fromRGB(66, 133, 244)
    ValLabel.Font = Enum.Font.GothamMedium
    ValLabel.TextSize = 12
    ValLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValLabel.Parent = Frame
    
    local SlideBar = Instance.new("Frame")
    SlideBar.Size = UDim2.new(1, 0, 0, 4)
    SlideBar.Position = UDim2.new(0, 0, 0, 28)
    SlideBar.BackgroundColor3 = Color3.fromRGB(34, 37, 48)
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
    SlideBtn.Size = UDim2.new(0, 10, 0, 10)
    SlideBtn.Position = UDim2.new(pct, -5, 0.5, -5)
    SlideBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SlideBtn.Text = ""
    SlideBtn.Parent = SlideBar
    
    local SlideCorner = Instance.new("UICorner")
    SlideCorner.CornerRadius = UDim.new(0.5, 0)
    SlideCorner.Parent = SlideBtn
    
    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, 0, 0, 1)
    Line.Position = UDim2.new(0, 0, 1, -1)
    Line.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
    Line.BorderSizePixel = 0
    Line.Parent = Frame
    
    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - SlideBar.AbsolutePosition.X) / SlideBar.AbsoluteSize.X, 0, 1)
        SlideFill.Size = UDim2.new(pos, 0, 1, 0)
        SlideBtn.Position = UDim2.new(pos, -5, 0.5, -5)
        local value = math.round(min + (max - min) * pos)
        ValLabel.Text = tostring(value)
        callback(value)
    end
    
    SlideBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            isDraggingSlider = true
        end
    end)
    
    local endConn = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            isDraggingSlider = false
        end
    end)
    table.insert(globalEnv.SqwssMM2Connections, endConn)
    
    local changeConn = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    table.insert(globalEnv.SqwssMM2Connections, changeConn)
end

local function makeButton(parentPage, actionName, text, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 44)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parentPage
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -56, 0, 32)
    Btn.Position = UDim2.new(0, 0, 0, 4)
    Btn.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(150, 153, 162)
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 11
    Btn.Parent = Frame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(36, 38, 46)
    Stroke.Thickness = 1
    Stroke.Parent = Btn
    
    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, 0, 0, 1)
    Line.Position = UDim2.new(0, 0, 1, -1)
    Line.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
    Line.BorderSizePixel = 0
    Line.Parent = Frame
    
    createBindBtn(Frame, actionName, -48)
    
    Btn.MouseButton1Click:Connect(callback)
    triggers[actionName] = callback
    return Btn
end

local function makeTextBox(parentPage, text, placeholder, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 44)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parentPage
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.4, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 202, 210)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local BoxFrame = Instance.new("Frame")
    BoxFrame.Size = UDim2.new(0.6, -10, 0, 28)
    BoxFrame.Position = UDim2.new(0.4, 0, 0.5, -14)
    BoxFrame.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
    BoxFrame.BorderSizePixel = 0
    BoxFrame.Parent = Frame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = BoxFrame
    
    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(1, -10, 1, 0)
    TextBox.Position = UDim2.new(0, 5, 0, 0)
    TextBox.BackgroundTransparency = 1
    TextBox.Text = ""
    TextBox.PlaceholderText = placeholder
    TextBox.PlaceholderColor3 = Color3.fromRGB(80, 83, 92)
    TextBox.TextColor3 = Color3.fromRGB(240, 240, 245)
    TextBox.Font = Enum.Font.GothamMedium
    TextBox.TextSize = 11
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.Parent = BoxFrame
    
    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, 0, 0, 1)
    Line.Position = UDim2.new(0, 0, 1, -1)
    Line.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
    Line.BorderSizePixel = 0
    Line.Parent = Frame
    
    TextBox.FocusLost:Connect(function()
        callback(TextBox.Text)
    end)
    return TextBox
end

createTab("Player", "Player", "rbxassetid://10888998127")
createTab("Visuals", "Visuals", "rbxassetid://10889017646")
createTab("Teleports", "Teleports", "rbxassetid://10889025745")
createTab("Settings", "Settings", "rbxassetid://10889012353")

tabs["Player"].Page.Visible = true
tabs["Player"].Icon.ImageColor3 = Color3.fromRGB(66, 133, 244)
tabs["Player"].Button.BackgroundTransparency = 0
tabs["Player"].Button.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
tabs["Player"].ActiveBar.Visible = true
Title.Text = "Player"

local espEnabled = false
local showInnocents = true
local showSheriffs = true
local showMurderers = true
local showLobby = true
local showGunDrop = true
local isAutoShooting = false

makeSectionHeader(tabs["Visuals"].Page, "ESP Controls")
makeToggle(tabs["Visuals"].Page, "esp_toggle", "ESP Активация", false, function(v) espEnabled = v end)
makeToggle(tabs["Visuals"].Page, "esp_innocents", "Подсветка Выживших (Зеленый)", true, function(v) showInnocents = v end)
makeToggle(tabs["Visuals"].Page, "esp_sheriffs", "Подсветка Шерифа (Синий)", true, function(v) showSheriffs = v end)
makeToggle(tabs["Visuals"].Page, "esp_murderers", "Подсветка Убийцы (Красный)", true, function(v) showMurderers = v end)
makeToggle(tabs["Visuals"].Page, "esp_gundrop", "Подсветка Упавшего Пистолета (Золотой)", true, function(v) showGunDrop = v end)
makeToggle(tabs["Visuals"].Page, "esp_lobby", "Подсветка Лобби (Серый)", true, function(v) showLobby = v end)

local function getMurderer()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local knifeSkin = p:GetAttribute("EquippedKnife")
            local hasKnife = false
            for _, t in ipairs(p.Character:GetDescendants()) do
                if t:IsA("Tool") or t:IsA("Model") then
                    local name = t.Name
                    if t ~= p.Character then
                        if knifeSkin and name == knifeSkin then
                            hasKnife = true break
                        elseif name:lower():match("^knife$") or name:lower():match("^knifeskin$") then
                            hasKnife = true break
                        end
                    end
                end
            end
            if not hasKnife then
                for _, t in ipairs(p.Backpack:GetChildren()) do
                    local name = t.Name
                    if knifeSkin and name == knifeSkin then
                        hasKnife = true break
                    elseif name:lower():find("knife") then
                        hasKnife = true break
                    end
                end
            end
            if hasKnife then return p.Character.HumanoidRootPart end
        end
    end
    return nil
end

local function getSheriff()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local gunSkin = p:GetAttribute("EquippedGun")
            local hasGun = false
            for _, t in ipairs(p.Character:GetDescendants()) do
                if t:IsA("Tool") and (t.Name == gunSkin or t.Name:lower():find("gun") or t.Name:lower():find("revolver")) then hasGun = true break end
            end
            if not hasGun then
                for _, t in ipairs(p.Backpack:GetChildren()) do
                    if t.Name == gunSkin or t.Name:lower():find("gun") or t.Name:lower():find("revolver") then hasGun = true break end
                end
            end
            if hasGun then return p.Character.HumanoidRootPart end
        end
    end
    return nil
end

local function isHoldingGun()
    local char = localPlayer.Character
    if char then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            local gunSkin = localPlayer:GetAttribute("EquippedGun")
            if tool.Name == gunSkin or tool.Name:lower():find("gun") or tool.Name:lower():find("revolver") then
                return true
            end
        end
    end
    return false
end

local function autoHitMurderer()
    local murderer = getMurderer()
    if not murderer then return end
    
    local char = localPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    
    local gun = char:FindFirstChildOfClass("Tool")
    local gunSkin = localPlayer:GetAttribute("EquippedGun")
    
    if not (gun and (gun.Name == gunSkin or gun.Name:lower():find("gun") or gun.Name:lower():find("revolver"))) then
        local backpack = localPlayer:FindFirstChild("Backpack")
        if backpack then
            for _, t in ipairs(backpack:GetChildren()) do
                if t:IsA("Tool") and (t.Name == gunSkin or t.Name:lower():find("gun") or t.Name:lower():find("revolver")) then
                    gun = t
                    break
                end
            end
        end
    end
    
    if gun then
        if gun.Parent ~= char then
            hum:EquipTool(gun)
            task.wait(0.12)
        end
        
        isAutoShooting = true
        gun:Activate()
        task.wait(0.35)
        isAutoShooting = false
    end
end

local function killAll()
    local char = localPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    
    local knife = char:FindFirstChildOfClass("Tool")
    local knifeSkin = localPlayer:GetAttribute("EquippedKnife")
    
    if not (knife and (knife.Name == knifeSkin or knife.Name:lower():find("knife"))) then
        local backpack = localPlayer:FindFirstChild("Backpack")
        if backpack then
            for _, t in ipairs(backpack:GetChildren()) do
                if t:IsA("Tool") and (t.Name == knifeSkin or t.Name:lower():find("knife")) then
                    knife = t
                    break
                end
            end
        end
    end
    
    if not knife then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local oldCFrame = hrp.CFrame
    
    if knife.Parent ~= char then
        hum:EquipTool(knife)
        task.wait(0.08)
    end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
            local targetHum = p.Character:FindFirstChildOfClass("Humanoid")
            if targetHum and targetHum.Health > 0 then
                local isLobby = false
                local lobby = workspace:FindFirstChild("RegularLobby")
                if lobby then
                    local dist = (p.Character.HumanoidRootPart.Position - lobby:GetPivot().Position).Magnitude
                    if dist < 200 then isLobby = true end
                end
                
                if not isLobby then
                    local start = tick()
                    while targetHum.Health > 0 and hum.Health > 0 and char.Parent and p.Character and p.Character:FindFirstChild("HumanoidRootPart") do
                        if tick() - start > 1.5 then break end
                        hrp.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
                        knife:Activate()
                        task.wait(0.04)
                    end
                end
            end
        end
    end
    
    hrp.CFrame = oldCFrame
end

makeSectionHeader(tabs["Visuals"].Page, "Combat Hacks")
makeButton(tabs["Visuals"].Page, "kill_murderer_btn", "Убить Убийцу (Shoot Murderer)", autoHitMurderer)
makeButton(tabs["Visuals"].Page, "kill_all_btn", "Убить Всех (Kill All - Murderer Only)", killAll)

local customSpeed = 16
local customJump = 50
local speedEnabled = false
local jumpEnabled = false
local infJumpEnabled = false
local antiAfk = false
local noclip = false
local flingTargetName = ""

local function findTargetPlayer(name)
    if name == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():find(name:lower()) or p.DisplayName:lower():find(name:lower()) then
            return p
        end
    end
    return nil
end

local function flingPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    
    local targetHrp = targetPlayer.Character.HumanoidRootPart
    local oldCFrame = hrp.CFrame
    
    local noclipConn = RunService.Stepped:Connect(function()
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
    
    local startTime = tick()
    while tick() - startTime < 2.5 and targetPlayer.Parent and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and hum.Health > 0 do
        RunService.Heartbeat:Wait()
        hrp.Velocity = Vector3.new(0, 50000, 0)
        hrp.RotVelocity = Vector3.new(0, 50000, 0)
        local angle = tick() * 20
        hrp.CFrame = targetHrp.CFrame * CFrame.Angles(0, angle, 0) + targetHrp.Velocity * 0.05
    end
    
    noclipConn:Disconnect()
    hrp.Velocity = Vector3.new(0, 0, 0)
    hrp.RotVelocity = Vector3.new(0, 0, 0)
    task.wait(0.12)
    hrp.CFrame = oldCFrame
end

local function flingAll()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer then
            flingPlayer(p)
            task.wait(0.2)
        end
    end
end

makeSectionHeader(tabs["Player"].Page, "Movement")
makeToggle(tabs["Player"].Page, "player_noclip", "Noclip", false, function(v) noclip = v end)
makeToggle(tabs["Player"].Page, "player_infjump", "Infinite Jump", false, function(v) infJumpEnabled = v end)
makeToggle(tabs["Player"].Page, "player_antiafk", "Anti-AFK", false, function(v) antiAfk = v end)

makeSectionHeader(tabs["Player"].Page, "Values")
makeSlider(tabs["Player"].Page, "Walk Speed", 16, 150, 16, function(v)
    customSpeed = v
    speedEnabled = (v > 16)
end)
makeSlider(tabs["Player"].Page, "Jump Power", 50, 200, 50, function(v)
    customJump = v
    jumpEnabled = (v > 50)
end)

makeSectionHeader(tabs["Player"].Page, "Fling Exploits")
makeTextBox(tabs["Player"].Page, "Имя Игрока (Target Player)", "Никнейм...", function(v) flingTargetName = v end)
makeButton(tabs["Player"].Page, "fling_target_btn", "Выкинуть Игрока (Fling Player)", function()
    local t = findTargetPlayer(flingTargetName)
    if t then flingPlayer(t) end
end)
makeButton(tabs["Player"].Page, "fling_all_btn", "Выкинуть Всех (Fling All)", flingAll)

local function getDroppedGun()
    for _, v in ipairs(workspace:GetChildren()) do
        if v:IsA("Tool") and (v.Name:lower():find("gun") or v.Name:lower():find("revolver")) then
            return v
        end
    end
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name == "GunDrop" or v.Name == "DroppedGun" then
            return v
        end
    end
    return nil
end

local function tpToPart(part)
    if part and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        localPlayer.Character.HumanoidRootPart.CFrame = part:GetPivot() + Vector3.new(0, 3, 0)
    end
end

makeSectionHeader(tabs["Teleports"].Page, "Teleports")
makeButton(tabs["Teleports"].Page, "tp_murderer", "TP to Murderer", function() tpToPart(getMurderer()) end)
makeButton(tabs["Teleports"].Page, "tp_sheriff", "TP to Sheriff", function() tpToPart(getSheriff()) end)
makeButton(tabs["Teleports"].Page, "tp_dropped_gun", "TP & Grab Dropped Gun", function()
    local gun = getDroppedGun()
    if gun and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = localPlayer.Character.HumanoidRootPart
        local oldCFrame = hrp.CFrame
        hrp.CFrame = gun:GetPivot()
        task.wait(0.12)
        hrp.CFrame = oldCFrame
    end
end)
makeButton(tabs["Teleports"].Page, "tp_lobby", "TP to Lobby", function()
    local lobby = workspace:FindFirstChild("RegularLobby")
    if lobby then tpToPart(lobby) end
end)

makeSectionHeader(tabs["Settings"].Page, "Cheat Config")
makeButton(tabs["Settings"].Page, "uninstall_cheat", "Uninstall Cheat", cleanupAll)

local espLoop = task.spawn(function()
    while true do
        task.wait(0.1)
        
        local gun = getDroppedGun()
        if espEnabled and showGunDrop and gun then
            pcall(function()
                local hl = gun:FindFirstChild("SqwssGunESP_Highlight")
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "SqwssGunESP_Highlight"
                    hl.FillTransparency = 0.4
                    hl.OutlineTransparency = 0.1
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = gun
                end
                hl.FillColor = Color3.fromRGB(255, 215, 0)
                hl.OutlineColor = Color3.fromRGB(255, 215, 0)
                
                local primaryPart = gun:IsA("Tool") and gun:FindFirstChild("Handle") or gun:FindFirstChildWhichIsA("BasePart", true)
                if primaryPart then
                    local tag = primaryPart:FindFirstChild("SqwssGunESP_Tag")
                    if not tag then
                        tag = Instance.new("BillboardGui")
                        tag.Name = "SqwssGunESP_Tag"
                        tag.Size = UDim2.new(0, 120, 0, 40)
                        tag.AlwaysOnTop = true
                        tag.StudsOffset = Vector3.new(0, 2, 0)
                        
                        local tl = Instance.new("TextLabel")
                        tl.Size = UDim2.new(1, 0, 1, 0)
                        tl.BackgroundTransparency = 1
                        tl.Font = Enum.Font.GothamBold
                        tl.TextSize = 10
                        tl.Parent = tag
                        
                        tag.Parent = primaryPart
                    end
                    tag.TextLabel.Text = "[ Gun Drop ]"
                    tag.TextLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
                end
            end)
        else
            pcall(function()
                if gun then
                    if gun:FindFirstChild("SqwssGunESP_Highlight") then gun.SqwssGunESP_Highlight:Destroy() end
                    local primaryPart = gun:IsA("Tool") and gun:FindFirstChild("Handle") or gun:FindFirstChildWhichIsA("BasePart", true)
                    if primaryPart and primaryPart:FindFirstChild("SqwssGunESP_Tag") then
                        primaryPart.SqwssGunESP_Tag:Destroy()
                    end
                end
            end)
        end
        
        for _, p in ipairs(Players:GetPlayers()) do
            pcall(function()
                if p == localPlayer then return end
                local char = p.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") then
                    local isLobby = false
                    local lobby = workspace:FindFirstChild("RegularLobby")
                    if lobby then
                        local dist = (char.HumanoidRootPart.Position - lobby:GetPivot().Position).Magnitude
                        if dist < 200 then isLobby = true end
                    end
                    
                    local knifeSkin = p:GetAttribute("EquippedKnife")
                    local gunSkin = p:GetAttribute("EquippedGun")
                    
                    local hasKnife = false
                    local hasGun = false
                    
                    for _, t in ipairs(char:GetDescendants()) do
                        if t:IsA("Tool") or t:IsA("Model") then
                            local name = t.Name
                            if t ~= char then
                                if knifeSkin and name == knifeSkin then
                                    hasKnife = true
                                elseif gunSkin and name == gunSkin then
                                    hasGun = true
                                elseif name:lower():match("^knife$") or name:lower():match("^knifeskin$") then
                                    hasKnife = true
                                elseif name:lower():match("^gun$") or name:lower():match("^revolver$") then
                                    hasGun = true
                                end
                            end
                        end
                    end
                    for _, t in ipairs(p.Backpack:GetChildren()) do
                        local name = t.Name
                        if knifeSkin and name == knifeSkin then
                            hasKnife = true
                        elseif gunSkin and name == gunSkin then
                            hasGun = true
                        elseif name:lower():find("knife") then
                            hasKnife = true
                        elseif name:lower():find("gun") or name:lower():find("revolver") then
                            hasGun = true
                        end
                    end
                    
                    local role = "Innocent"
                    if isLobby then
                        role = "Lobby"
                    elseif hasKnife then
                        role = "Murderer"
                    elseif hasGun then
                        role = "Sheriff"
                    end
                    
                    local allowed = false
                    local color = Color3.fromRGB(50, 200, 50)
                    
                    if role == "Lobby" then
                        allowed = showLobby
                        color = Color3.fromRGB(150, 150, 150)
                    elseif role == "Murderer" then
                        allowed = showMurderers
                        color = Color3.fromRGB(255, 50, 50)
                    elseif role == "Sheriff" then
                        allowed = showSheriffs
                        color = Color3.fromRGB(50, 100, 255)
                    else
                        allowed = showInnocents
                        color = Color3.fromRGB(50, 200, 50)
                    end
                    
                    if espEnabled and allowed then
                        local hl = char:FindFirstChild("SqwssESP_Highlight")
                        if not hl then
                            hl = Instance.new("Highlight")
                            hl.Name = "SqwssESP_Highlight"
                            hl.FillTransparency = 0.5
                            hl.OutlineTransparency = 0.1
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Parent = char
                        end
                        hl.FillColor = color
                        hl.OutlineColor = color
                        
                        local head = char.Head
                        local tag = head:FindFirstChild("SqwssESP_Tag")
                        if not tag then
                            tag = Instance.new("BillboardGui")
                            tag.Name = "SqwssESP_Tag"
                            tag.Size = UDim2.new(0, 120, 0, 40)
                            tag.AlwaysOnTop = true
                            tag.StudsOffset = Vector3.new(0, 2, 0)
                            
                            local tl = Instance.new("TextLabel")
                            tl.Size = UDim2.new(1, 0, 1, 0)
                            tl.BackgroundTransparency = 1
                            tl.Font = Enum.Font.GothamBold
                            tl.TextSize = 10
                            tl.Parent = tag
                            
                            tag.Parent = head
                        end
                        tag.TextLabel.Text = p.DisplayName .. "\n[" .. role .. "]"
                        tag.TextLabel.TextColor3 = color
                    else
                        if char:FindFirstChild("SqwssESP_Highlight") then char.SqwssESP_Highlight:Destroy() end
                        local head = char:FindFirstChild("Head")
                        if head and head:FindFirstChild("SqwssESP_Tag") then head.SqwssESP_Tag:Destroy() end
                    end
                end
            end)
        end
    end
end)
table.insert(globalEnv.SqwssMM2Threads, espLoop)

local playerUpdateLoop = RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = localPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                if speedEnabled then
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
            
            if espEnabled then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= localPlayer and p.Character then
                        local isLobby = false
                        local lobby = workspace:FindFirstChild("RegularLobby")
                        if lobby and p.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (p.Character.HumanoidRootPart.Position - lobby:GetPivot().Position).Magnitude
                            if dist < 200 then isLobby = true end
                        end
                        
                        if not isLobby then
                            for _, part in ipairs(p.Character:GetDescendants()) do
                                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                                    if part.Transparency > 0.1 then
                                        part.Transparency = 0.3
                                    end
                                elseif part:IsA("Decal") then
                                    if part.Transparency > 0.1 then
                                        part.Transparency = 0.3
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end)
table.insert(globalEnv.SqwssMM2Connections, playerUpdateLoop)

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
table.insert(globalEnv.SqwssMM2Connections, jumpConn)

local afkConn = localPlayer.Idled:Connect(function()
    if antiAfk then
        pcall(function()
            game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
    end
end)
table.insert(globalEnv.SqwssMM2Connections, afkConn)
