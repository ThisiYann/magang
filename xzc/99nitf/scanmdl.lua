local ScanModule = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local scanPlayer = Players.LocalPlayer
local scanHumanoidRootPart = nil
local scanCenterPosition = Vector3.new(13.287, 100, 0.362)
local scanMaxRadius = 1380
local scanAngleStep = math.rad(10)
local scanRadiusStep = 15
local scanSpeed = 100
local mapMinX = -1386.61
local mapMaxX = 1385.55
local mapMinZ = -1396.19
local mapMaxZ = 1376.45
local mapArea = (mapMaxX - mapMinX) * (mapMaxZ - mapMinZ)

local scanEnabled = false
local scanRunning = false
local scanAngle = 0
local scanRadius = 0

local scanScreenGui = nil
local mainFrame = nil
local titleLabel = nil
local explorationLabel = nil
local percentageLabel = nil
local progressBarFrame = nil
local progressBar = nil
local progressGlow = nil
local scanBodyVelocity = nil

local function initializeUI()
    if scanScreenGui then return end
    
    local scanPlayerGui = scanPlayer:WaitForChild("PlayerGui")
    scanScreenGui = Instance.new("ScreenGui")
    scanScreenGui.Name = "ScanMapUI"
    scanScreenGui.Parent = scanPlayerGui

    -- Main container frame with modern design
    mainFrame = Instance.new("Frame")
    mainFrame.Parent = scanScreenGui
    mainFrame.Size = UDim2.new(0, 320, 0, 120)
    mainFrame.Position = UDim2.new(0.5, -160, 0.08, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 16)
    mainCorner.Parent = mainFrame

    -- Subtle shadow/glow effect
    local shadow = Instance.new("ImageLabel")
    shadow.Parent = mainFrame
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.ZIndex = 0

    -- Title label
    titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = mainFrame
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.Text = "MAP EXPLORATION"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Percentage display (large)
    percentageLabel = Instance.new("TextLabel")
    percentageLabel.Parent = mainFrame
    percentageLabel.Size = UDim2.new(0, 80, 0, 35)
    percentageLabel.Position = UDim2.new(1, -90, 0, 8)
    percentageLabel.Text = "0%"
    percentageLabel.BackgroundTransparency = 1
    percentageLabel.Font = Enum.Font.GothamBold
    percentageLabel.TextSize = 32
    percentageLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    percentageLabel.TextXAlignment = Enum.TextXAlignment.Right

    -- Exploration status label
    explorationLabel = Instance.new("TextLabel")
    explorationLabel.Parent = mainFrame
    explorationLabel.Size = UDim2.new(1, -20, 0, 20)
    explorationLabel.Position = UDim2.new(0, 10, 0, 45)
    explorationLabel.Text = "Scanning area..."
    explorationLabel.BackgroundTransparency = 1
    explorationLabel.Font = Enum.Font.Gotham
    explorationLabel.TextSize = 12
    explorationLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
    explorationLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Progress bar background frame
    progressBarFrame = Instance.new("Frame")
    progressBarFrame.Parent = mainFrame
    progressBarFrame.Size = UDim2.new(1, -20, 0, 8)
    progressBarFrame.Position = UDim2.new(0, 10, 1, -20)
    progressBarFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    progressBarFrame.BorderSizePixel = 0

    local barFrameCorner = Instance.new("UICorner")
    barFrameCorner.CornerRadius = UDim.new(0, 4)
    barFrameCorner.Parent = progressBarFrame

    -- Progress glow (behind progress bar)
    progressGlow = Instance.new("Frame")
    progressGlow.Parent = progressBarFrame
    progressGlow.Size = UDim2.new(0, 0, 1, 0)
    progressGlow.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    progressGlow.BackgroundTransparency = 0.7
    progressGlow.BorderSizePixel = 0
    progressGlow.ZIndex = 1

    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 4)
    glowCorner.Parent = progressGlow

    -- Progress bar (gradient)
    progressBar = Instance.new("Frame")
    progressBar.Parent = progressBarFrame
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    progressBar.BorderSizePixel = 0
    progressBar.ZIndex = 2

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 4)
    barCorner.Parent = progressBar

    -- Gradient for progress bar
    local gradient = Instance.new("UIGradient")
    gradient.Parent = progressBar
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 180, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 220, 255))
    }
    gradient.Rotation = 90

    -- Scanning animation effect
    local scanLine = Instance.new("Frame")
    scanLine.Parent = progressBar
    scanLine.Size = UDim2.new(0, 3, 1, 0)
    scanLine.Position = UDim2.new(1, -3, 0, 0)
    scanLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    scanLine.BackgroundTransparency = 0.3
    scanLine.BorderSizePixel = 0
    scanLine.ZIndex = 3

    -- Animate scan line
    task.spawn(function()
        while scanScreenGui do
            if mainFrame.Visible then
                local tween = TweenService:Create(scanLine, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                    BackgroundTransparency = 0.8
                })
                tween:Play()
            end
            task.wait(1)
        end
    end)

    scanBodyVelocity = Instance.new("BodyVelocity")
    scanBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    scanBodyVelocity.P = 5000
    scanBodyVelocity.Velocity = Vector3.zero
end

local function calculateOverlapArea(centerX, centerZ, radius, minX, minZ, maxX, maxZ)
    local sampleCount = 10000
    local insideCount = 0
    for _ = 1, sampleCount do
        local angle = math.random() * 2 * math.pi
        local distance = math.sqrt(math.random()) * radius
        local pointX = centerX + distance * math.cos(angle)
        local pointZ = centerZ + distance * math.sin(angle)
        if minX <= pointX and pointX <= maxX and minZ <= pointZ and pointZ <= maxZ then
            insideCount = insideCount + 1
        end
    end
    return insideCount / sampleCount * math.pi * radius * radius
end

local function attachBodyVelocity()
    if not scanHumanoidRootPart then return end
    if scanBodyVelocity.Parent ~= scanHumanoidRootPart then
        scanBodyVelocity.Parent = scanHumanoidRootPart
    end
end

local function detachBodyVelocity()
    if scanBodyVelocity and scanBodyVelocity.Parent then
        scanBodyVelocity.Parent = nil
    end
end

local function moveToPosition(targetPosition)
    if not scanHumanoidRootPart then return end
    while scanEnabled and (scanHumanoidRootPart.Position - targetPosition).Magnitude > 5 do
        local direction = targetPosition - scanHumanoidRootPart.Position
        if direction.Magnitude == 0 then
            break
        end
        scanBodyVelocity.Velocity = direction.Unit * scanSpeed
        task.wait()
    end
end

local function updateProgress(percentage)
    local clampedPercentage = math.min(percentage, 100)
    
    -- Smooth tween for percentage
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    -- Update percentage label with color transition
    percentageLabel.Text = clampedPercentage .. "%"
    
    -- Color transition based on percentage
    local color
    if clampedPercentage < 33 then
        color = Color3.fromRGB(100, 200, 255) -- Blue
    elseif clampedPercentage < 66 then
        color = Color3.fromRGB(100, 255, 200) -- Cyan
    else
        color = Color3.fromRGB(100, 255, 100) -- Green
    end
    
    local colorTween = TweenService:Create(percentageLabel, tweenInfo, {TextColor3 = color})
    colorTween:Play()
    
    local barTween = TweenService:Create(progressBar, tweenInfo, {
        Size = UDim2.new(clampedPercentage / 100, 0, 1, 0),
        BackgroundColor3 = color
    })
    barTween:Play()
    
    local glowTween = TweenService:Create(progressGlow, tweenInfo, {
        Size = UDim2.new(clampedPercentage / 100, 0, 1, 0),
        BackgroundColor3 = color
    })
    glowTween:Play()
end

local function runScanLoop()
    if scanRunning then return end
    
    local character = scanPlayer.Character or scanPlayer.CharacterAdded:Wait()
    scanHumanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    scanRunning = true
    mainFrame.Visible = true
    
    -- Fade in animation
    mainFrame.BackgroundTransparency = 1
    local fadeIn = TweenService:Create(mainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0})
    fadeIn:Play()
    
    attachBodyVelocity()
    
    while scanEnabled and scanRadius < scanMaxRadius do
        local posX = scanCenterPosition.X + math.cos(scanAngle) * scanRadius
        local posZ = scanCenterPosition.Z + math.sin(scanAngle) * scanRadius
        moveToPosition(Vector3.new(posX, scanCenterPosition.Y, posZ))
        scanAngle = scanAngle + scanAngleStep
        scanRadius = scanRadius + scanRadiusStep * (scanAngleStep / (2 * math.pi))
        
        local overlapArea = calculateOverlapArea(
            scanCenterPosition.X, scanCenterPosition.Z, scanRadius,
            mapMinX, mapMinZ, mapMaxX, mapMaxZ
        )
        local percentage = math.floor(overlapArea / mapArea * 100)
        updateProgress(percentage)
        
        task.wait()
    end
    
    scanBodyVelocity.Velocity = Vector3.zero
    detachBodyVelocity()
    
    -- Fade out animation
    local fadeOut = TweenService:Create(mainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
    fadeOut:Play()
    fadeOut.Completed:Wait()
    
    mainFrame.Visible = false
    scanRunning = false
end

local function stopScan()
    scanEnabled = false
    if scanBodyVelocity then
        scanBodyVelocity.Velocity = Vector3.zero
    end
    detachBodyVelocity()
    
    if mainFrame then
        local fadeOut = TweenService:Create(mainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
        fadeOut:Play()
        fadeOut.Completed:Wait()
        mainFrame.Visible = false
    end
    
    if percentageLabel then
        percentageLabel.Text = "0%"
    end
    if progressBar then
        progressBar.Size = UDim2.new(0, 0, 1, 0)
    end
    if progressGlow then
        progressGlow.Size = UDim2.new(0, 0, 1, 0)
    end
    
    scanRadius = 0
    scanAngle = 0
end

function ScanModule.ToggleScan(enabled)
    initializeUI()
    if enabled then
        scanEnabled = true
        task.spawn(runScanLoop)
    else
        stopScan()
    end
end

function ScanModule.SetScanSpeed(speed)
    scanSpeed = speed
end

function ScanModule.SetScanRadius(radius)
    scanRadiusStep = radius
end

function ScanModule.SetScanAngle(angle)
    scanAngleStep = math.rad(angle)
end

function ScanModule.Cleanup()
    stopScan()
    if scanScreenGui then
        scanScreenGui:Destroy()
        scanScreenGui = nil
    end
    if scanBodyVelocity then
        scanBodyVelocity:Destroy()
        scanBodyVelocity = nil
    end
end

return ScanModule
