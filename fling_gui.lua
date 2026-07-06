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
local screenGuiName = "SqwssFlingGui"

if globalEnv.SqwssFlingConnections then
    for _, conn in ipairs(globalEnv.SqwssFlingConnections) do
        pcall(function() conn:Disconnect() end)
    end
end
globalEnv.SqwssFlingConnections = {}

if globalEnv.SqwssFlingThreads then
    for _, thread in ipairs(globalEnv.SqwssFlingThreads) do
        pcall(function() task.cancel(thread) end)
    end
end
globalEnv.SqwssFlingThreads = {}

local function cleanupFling()
    if globalEnv.SqwssFlingConnections then
        for _, conn in ipairs(globalEnv.SqwssFlingConnections) do
            pcall(function() conn:Disconnect() end)
        end
    end
    if globalEnv.SqwssFlingThreads then
        for _, thread in ipairs(globalEnv.SqwssFlingThreads) do
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
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = screenGuiName
ScreenGui.ResetOnSpawn = false
local parent = (RunService:IsStudio() or not pcall(function() local x = CoreGui.Name end)) and localPlayer:WaitForChild("PlayerGui") or CoreGui
ScreenGui.Parent = parent

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 46, 0, 46)
ToggleButton.Position = UDim2.new(0, 20, 0.7, -23)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 16, 20)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "🌀"
ToggleButton.TextColor3 = Color3.fromRGB(66, 133, 244)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 20
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
MainFrame.Size = UDim2.new(0, 320, 0, 380)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
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

local function updateDragInput(input)
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

table.insert(globalEnv.SqwssFlingConnections, UserInputService.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateDragInput(input)
    end
end))

local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 45)
Topbar.BackgroundTransparency = 1
Topbar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Fling Controls"
Title.TextColor3 = Color3.fromRGB(240, 240, 245)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

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
    cleanupFling()
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
TopSeparator.Size = UDim2.new(1, 0, 0, 1)
TopSeparator.Position = UDim2.new(0, 0, 0, 45)
TopSeparator.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
TopSeparator.BorderSizePixel = 0
TopSeparator.Parent = MainFrame

local SearchFrame = Instance.new("Frame")
SearchFrame.Size = UDim2.new(1, -20, 0, 28)
SearchFrame.Position = UDim2.new(0, 10, 0, 55)
SearchFrame.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
SearchFrame.BorderSizePixel = 0
SearchFrame.Parent = MainFrame

local SFCorner = Instance.new("UICorner")
SFCorner.CornerRadius = UDim.new(0, 6)
SFCorner.Parent = SearchFrame

local SearchIcon = Instance.new("TextLabel")
SearchIcon.Size = UDim2.new(0, 28, 1, 0)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Text = "🔍"
SearchIcon.TextColor3 = Color3.fromRGB(100, 103, 112)
SearchIcon.Font = Enum.Font.GothamMedium
SearchIcon.TextSize = 11
SearchIcon.Parent = SearchFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -34, 1, 0)
SearchBox.Position = UDim2.new(0, 30, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.Text = ""
SearchBox.PlaceholderText = "Search player name..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(80, 83, 92)
SearchBox.TextColor3 = Color3.fromRGB(240, 240, 245)
SearchBox.Font = Enum.Font.GothamMedium
SearchBox.TextSize = 11
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.Parent = SearchFrame

local ListContainer = Instance.new("ScrollingFrame")
ListContainer.Size = UDim2.new(1, -20, 1, -190)
ListContainer.Position = UDim2.new(0, 10, 0, 95)
ListContainer.BackgroundColor3 = Color3.fromRGB(12, 13, 17)
ListContainer.BorderSizePixel = 0
ListContainer.ScrollBarThickness = 3
ListContainer.ScrollBarImageColor3 = Color3.fromRGB(66, 133, 244)
ListContainer.Parent = MainFrame

local LCCorner = Instance.new("UICorner")
LCCorner.CornerRadius = UDim.new(0, 8)
LCCorner.Parent = ListContainer

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = ListContainer
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 2)

local LCStroke = Instance.new("UIStroke")
LCStroke.Color = Color3.fromRGB(24, 26, 32)
LCStroke.Thickness = 1
LCStroke.Parent = ListContainer

local selectedPlayer = nil
local playerItems = {}

local function updatePlayerList()
    for _, item in ipairs(ListContainer:GetChildren()) do
        if item:IsA("TextButton") then item:Destroy() end
    end
    playerItems = {}
    
    local filter = SearchBox.Text:lower()
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer then
            if filter == "" or p.Name:lower():find(filter) or p.DisplayName:lower():find(filter) then
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 0, 28)
                Btn.BackgroundColor3 = (selectedPlayer == p) and Color3.fromRGB(33, 58, 105) or Color3.fromRGB(24, 26, 32)
                Btn.BackgroundTransparency = (selectedPlayer == p) and 0 or 1
                Btn.BorderSizePixel = 0
                Btn.Text = "  " .. p.DisplayName .. " (@" .. p.Name .. ")"
                Btn.TextColor3 = (selectedPlayer == p) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 185, 195)
                Btn.Font = Enum.Font.GothamMedium
                Btn.TextSize = 11
                Btn.TextXAlignment = Enum.TextXAlignment.Left
                Btn.Parent = ListContainer
                
                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 4)
                Corner.Parent = Btn
                
                Btn.MouseButton1Click:Connect(function()
                    selectedPlayer = p
                    updatePlayerList()
                end)
                
                playerItems[p] = Btn
            end
        end
    end
    
    ListContainer.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(updatePlayerList)
table.insert(globalEnv.SqwssFlingConnections, Players.PlayerAdded:Connect(updatePlayerList))
table.insert(globalEnv.SqwssFlingConnections, Players.PlayerRemoving:Connect(function(p)
    if selectedPlayer == p then selectedPlayer = nil end
    updatePlayerList()
end))

local FlingBtn = Instance.new("TextButton")
FlingBtn.Size = UDim2.new(1, -20, 0, 36)
FlingBtn.Position = UDim2.new(0, 10, 1, -85)
FlingBtn.BackgroundColor3 = Color3.fromRGB(66, 133, 244)
FlingBtn.Text = "Fling Selected Player"
FlingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingBtn.Font = Enum.Font.GothamBold
FlingBtn.TextSize = 12
FlingBtn.Parent = MainFrame

local FBCorner = Instance.new("UICorner")
FBCorner.CornerRadius = UDim.new(0, 6)
FBCorner.Parent = FlingBtn

local FlingAllBtn = Instance.new("TextButton")
FlingAllBtn.Size = UDim2.new(1, -20, 0, 36)
FlingAllBtn.Position = UDim2.new(0, 10, 1, -42)
FlingAllBtn.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
FlingAllBtn.Text = "Fling Everyone (Fling All)"
FlingAllBtn.TextColor3 = Color3.fromRGB(180, 185, 195)
FlingAllBtn.Font = Enum.Font.GothamBold
FlingAllBtn.TextSize = 12
FlingAllBtn.Parent = MainFrame

local FABCorner = Instance.new("UICorner")
FABCorner.CornerRadius = UDim.new(0, 6)
FABCorner.Parent = FlingAllBtn

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

FlingBtn.MouseButton1Click:Connect(function()
    if selectedPlayer then
        FlingBtn.Text = "Flinging..."
        FlingBtn.BackgroundColor3 = Color3.fromRGB(244, 67, 54)
        pcall(function() flingPlayer(selectedPlayer) end)
        FlingBtn.Text = "Fling Selected Player"
        FlingBtn.BackgroundColor3 = Color3.fromRGB(66, 133, 244)
    end
end)

FlingAllBtn.MouseButton1Click:Connect(function()
    FlingAllBtn.Text = "Flinging All..."
    FlingAllBtn.BackgroundColor3 = Color3.fromRGB(244, 67, 54)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer then
            pcall(function() flingPlayer(p) end)
            task.wait(0.2)
        end
    end
    FlingAllBtn.Text = "Fling Everyone (Fling All)"
    FlingAllBtn.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
end)

updatePlayerList()
