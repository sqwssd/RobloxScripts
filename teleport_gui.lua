local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local globalEnv = (getgenv and getgenv()) or _G

if globalEnv.SqwssTeleportThread then
    pcall(function() task.cancel(globalEnv.SqwssTeleportThread) end)
    globalEnv.SqwssTeleportThread = nil
end

local function cleanup()
    if globalEnv.SqwssTeleportThread then
        pcall(function() task.cancel(globalEnv.SqwssTeleportThread) end)
        globalEnv.SqwssTeleportThread = nil
    end
    if CoreGui:FindFirstChild("SqwssTeleport") then
        CoreGui.SqwssTeleport:Destroy()
    end
    if localPlayer:WaitForChild("PlayerGui"):FindFirstChild("SqwssTeleport") then
        localPlayer.PlayerGui.SqwssTeleport:Destroy()
    end
end
cleanup()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SqwssTeleport"
ScreenGui.ResetOnSpawn = false
local parent = (RunService:IsStudio() or not pcall(function() local x = CoreGui.Name end)) and localPlayer:WaitForChild("PlayerGui") or CoreGui
ScreenGui.Parent = parent

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 300)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -150)
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
    cleanup()
end)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 20, 0, 20)
MinBtn.Position = UDim2.new(1, -55, 0, 10)
MinBtn.BackgroundColor3 = Color3.fromRGB(66, 133, 244)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14
MinBtn.Parent = MainFrame

local MBCorner = Instance.new("UICorner")
MBCorner.CornerRadius = UDim.new(0.5, 0)
MBCorner.Parent = MinBtn

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

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -65, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "TELEPORT PANEL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -30, 1, -60)
ScrollFrame.Position = UDim2.new(0, 15, 0, 45)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(66, 133, 244)
ScrollFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 6)
ListLayout.SortOrder = Enum.SortOrder.Name
ListLayout.Parent = ScrollFrame

local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        ScrollFrame.Visible = false
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 340, 0, 40)}):Play()
        MinBtn.Text = "+"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 340, 0, 300)}):Play()
        task.delay(0.15, function()
            if not isMinimized then
                ScrollFrame.Visible = true
            end
        end)
        MinBtn.Text = "-"
    end
end)

local function updateList()
    local currentFrameCount = 0
    local existingFrames = {}
    
    for _, child in ipairs(ScrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            existingFrames[child.Name] = child
            currentFrameCount = currentFrameCount + 1
        end
    end
    
    local players = Players:GetPlayers()
    local activePlayerNames = {}
    local totalCount = 0
    
    for _, player in ipairs(players) do
        if player ~= localPlayer then
            totalCount = totalCount + 1
            activePlayerNames[player.Name] = true
            
            local Row = existingFrames[player.Name]
            if not Row then
                Row = Instance.new("Frame")
                Row.Name = player.Name
                Row.Size = UDim2.new(1, -6, 0, 36)
                Row.BackgroundColor3 = Color3.fromRGB(33, 35, 44)
                Row.BorderSizePixel = 0
                Row.Parent = ScrollFrame
                
                local RowCorner = Instance.new("UICorner")
                RowCorner.CornerRadius = UDim.new(0, 6)
                RowCorner.Parent = Row
                
                local NameLabel = Instance.new("TextLabel")
                NameLabel.Size = UDim2.new(0.5, -5, 1, 0)
                NameLabel.Position = UDim2.new(0, 10, 0, 0)
                NameLabel.BackgroundTransparency = 1
                NameLabel.Text = player.DisplayName .. " (@" .. player.Name .. ")"
                NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                NameLabel.Font = Enum.Font.GothamMedium
                NameLabel.TextSize = 10
                NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
                NameLabel.TextXAlignment = Enum.TextXAlignment.Left
                NameLabel.Parent = Row
                
                local TPBtn = Instance.new("TextButton")
                TPBtn.Size = UDim2.new(0.2, 0, 0, 24)
                TPBtn.Position = UDim2.new(0.55, 0, 0.5, -12)
                TPBtn.BackgroundColor3 = Color3.fromRGB(66, 133, 244)
                TPBtn.Text = "ТП"
                TPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                TPBtn.Font = Enum.Font.GothamBold
                TPBtn.TextSize = 10
                TPBtn.Parent = Row
                
                local TPBtnCorner = Instance.new("UICorner")
                TPBtnCorner.CornerRadius = UDim.new(0, 4)
                TPBtnCorner.Parent = TPBtn
                
                local BringBtn = Instance.new("TextButton")
                BringBtn.Size = UDim2.new(0.2, 0, 0, 24)
                BringBtn.Position = UDim2.new(0.78, 0, 0.5, -12)
                BringBtn.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
                BringBtn.Text = "BRING"
                BringBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                BringBtn.Font = Enum.Font.GothamBold
                BringBtn.TextSize = 10
                BringBtn.Parent = Row
                
                local BringBtnCorner = Instance.new("UICorner")
                BringBtnCorner.CornerRadius = UDim.new(0, 4)
                BringBtnCorner.Parent = BringBtn
                
                TPBtn.MouseButton1Click:Connect(function()
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local myChar = localPlayer.Character
                        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                            myChar.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                        end
                    end
                end)
                
                BringBtn.MouseButton1Click:Connect(function()
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local myChar = localPlayer.Character
                        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                            player.Character.HumanoidRootPart.CFrame = myChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                        end
                    end
                end)
            end
        end
    end
    
    for name, frame in pairs(existingFrames) do
        if not activePlayerNames[name] then
            frame:Destroy()
        end
    end
    
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalCount * 42)
end

updateList()

globalEnv.SqwssTeleportThread = task.spawn(function()
    while true do
        pcall(updateList)
        task.wait(2.5)
    end
end)
