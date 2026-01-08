addcmd('viewpart', { 'viewp' }, function(args, speaker)
    StopFreecam()
    if args[1] then
        for i, v in pairs(workspace:GetDescendants()) do
            if v.Name:lower() == getstring(1):lower() and v:IsA("BasePart") then
                wait(0.1)
                workspace.CurrentCamera.CameraSubject = v
            end
        end
    end
end)

addcmd('unview', { 'unspectate' }, function(args, speaker)
    StopFreecam()
    if viewing ~= nil then
        viewing = nil
        notify('Spectate', 'View turned off')
    end
    if viewDied then
        viewDied:Disconnect()
        viewChanged:Disconnect()
    end
    workspace.CurrentCamera.CameraSubject = speaker.Character
end)


fcRunning = false
local Camera = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    local newCamera = workspace.CurrentCamera
    if newCamera then
        Camera = newCamera
    end
end)

local INPUT_PRIORITY = Enum.ContextActionPriority.High.Value

Spring = {}
do
    Spring.__index = Spring

    function Spring.new(freq, pos)
        local self = setmetatable({}, Spring)
        self.f = freq
        self.p = pos
        self.v = pos * 0
        return self
    end

    function Spring:Update(dt, goal)
        local f = self.f * 2 * math.pi
        local p0 = self.p
        local v0 = self.v

        local offset = goal - p0
        local decay = math.exp(-f * dt)

        local p1 = goal + (v0 * dt - offset * (f * dt + 1)) * decay
        local v1 = (f * dt * (offset * f - v0) + v0) * decay

        self.p = p1
        self.v = v1

        return p1
    end

    function Spring:Reset(pos)
        self.p = pos
        self.v = pos * 0
    end
end

local cameraPos = Vector3.new()
local cameraRot = Vector2.new()

local velSpring = Spring.new(5, Vector3.new())
local panSpring = Spring.new(5, Vector2.new())

Input = {}
do
    keyboard = {
        W = 0,
        A = 0,
        S = 0,
        D = 0,
        E = 0,
        Q = 0,
        Up = 0,
        Down = 0,
        LeftShift = 0,
    }

    mouse = {
        Delta = Vector2.new(),
    }

    NAV_KEYBOARD_SPEED = Vector3.new(1, 1, 1)
    PAN_MOUSE_SPEED = Vector2.new(1, 1) * (math.pi / 64)
    NAV_ADJ_SPEED = 0.75
    NAV_SHIFT_MUL = 0.25

    navSpeed = 1

    function Input.Vel(dt)
        navSpeed = math.clamp(navSpeed + dt * (keyboard.Up - keyboard.Down) * NAV_ADJ_SPEED, 0.01, 4)

        local kKeyboard = Vector3.new(
            keyboard.D - keyboard.A,
            keyboard.E - keyboard.Q,
            keyboard.S - keyboard.W
        ) * NAV_KEYBOARD_SPEED

        local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)

        return (kKeyboard) * (navSpeed * (shift and NAV_SHIFT_MUL or 1))
    end

    function Input.Pan(dt)
        local kMouse = mouse.Delta * PAN_MOUSE_SPEED
        mouse.Delta = Vector2.new()
        return kMouse
    end

    do
        function Keypress(action, state, input)
            keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
            return Enum.ContextActionResult.Sink
        end

        function MousePan(action, state, input)
            local delta = input.Delta
            mouse.Delta = Vector2.new(-delta.y, -delta.x)
            return Enum.ContextActionResult.Sink
        end

        function Zero(t)
            for k, v in pairs(t) do
                t[k] = v * 0
            end
        end

        function Input.StartCapture()
            ContextActionService:BindActionAtPriority("FreecamKeyboard", Keypress, false, INPUT_PRIORITY,
                Enum.KeyCode.W,
                Enum.KeyCode.A,
                Enum.KeyCode.S,
                Enum.KeyCode.D,
                Enum.KeyCode.E,
                Enum.KeyCode.Q,
                Enum.KeyCode.Up,
                Enum.KeyCode.Down
            )
            ContextActionService:BindActionAtPriority("FreecamMousePan", MousePan, false, INPUT_PRIORITY,
                Enum.UserInputType.MouseMovement)
        end

        function Input.StopCapture()
            navSpeed = 1
            Zero(keyboard)
            Zero(mouse)
            ContextActionService:UnbindAction("FreecamKeyboard")
            ContextActionService:UnbindAction("FreecamMousePan")
        end
    end
end

function GetFocusDistance(cameraFrame)
    local znear = 0.1
    local viewport = Camera.ViewportSize
    local projy = 2 * math.tan(cameraFov / 2)
    local projx = viewport.x / viewport.y * projy
    local fx = cameraFrame.rightVector
    local fy = cameraFrame.upVector
    local fz = cameraFrame.lookVector

    local minVect = Vector3.new()
    local minDist = 512

    for x = 0, 1, 0.5 do
        for y = 0, 1, 0.5 do
            local cx = (x - 0.5) * projx
            local cy = (y - 0.5) * projy
            local offset = fx * cx - fy * cy + fz
            local origin = cameraFrame.p + offset * znear
            local _, hit = workspace:FindPartOnRay(Ray.new(origin, offset.unit * minDist))
            local dist = (hit - origin).magnitude
            if minDist > dist then
                minDist = dist
                minVect = offset.unit
            end
        end
    end

    return fz:Dot(minVect) * minDist
end

local function StepFreecam(dt)
    local vel = velSpring:Update(dt, Input.Vel(dt))
    local pan = panSpring:Update(dt, Input.Pan(dt))

    local zoomFactor = math.sqrt(math.tan(math.rad(70 / 2)) / math.tan(math.rad(cameraFov / 2)))

    cameraRot = cameraRot + pan * Vector2.new(0.75, 1) * 8 * (dt / zoomFactor)
    cameraRot = Vector2.new(math.clamp(cameraRot.x, -math.rad(90), math.rad(90)), cameraRot.y % (2 * math.pi))

    local cameraCFrame = CFrame.new(cameraPos) * CFrame.fromOrientation(cameraRot.x, cameraRot.y, 0) *
    CFrame.new(vel * Vector3.new(1, 1, 1) * 64 * dt)
    cameraPos = cameraCFrame.p

    Camera.CFrame = cameraCFrame
    Camera.Focus = cameraCFrame * CFrame.new(0, 0, -GetFocusDistance(cameraCFrame))
    Camera.FieldOfView = cameraFov
end

local PlayerState = {}
do
    mouseBehavior = ""
    mouseIconEnabled = ""
    cameraType = ""
    cameraFocus = ""
    cameraCFrame = ""
    cameraFieldOfView = ""

    function PlayerState.Push()
        cameraFieldOfView = Camera.FieldOfView
        Camera.FieldOfView = 70

        cameraType = Camera.CameraType
        Camera.CameraType = Enum.CameraType.Custom

        cameraCFrame = Camera.CFrame
        cameraFocus = Camera.Focus

        mouseIconEnabled = UserInputService.MouseIconEnabled
        UserInputService.MouseIconEnabled = true

        mouseBehavior = UserInputService.MouseBehavior
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end

    function PlayerState.Pop()
        Camera.FieldOfView = 70

        Camera.CameraType = cameraType
        cameraType = nil

        Camera.CFrame = cameraCFrame
        cameraCFrame = nil

        Camera.Focus = cameraFocus
        cameraFocus = nil

        UserInputService.MouseIconEnabled = mouseIconEnabled
        mouseIconEnabled = nil

        UserInputService.MouseBehavior = mouseBehavior
        mouseBehavior = nil
    end
end

function StartFreecam(pos)
    if fcRunning then
        StopFreecam()
    end
    local cameraCFrame = Camera.CFrame
    if pos then
        cameraCFrame = pos
    end
    cameraRot = Vector2.new()
    cameraPos = cameraCFrame.p
    cameraFov = Camera.FieldOfView

    velSpring:Reset(Vector3.new())
    panSpring:Reset(Vector2.new())

    PlayerState.Push()
    RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
    Input.StartCapture()
    fcRunning = true
end

function StopFreecam()
    if not fcRunning then return end
    Input.StopCapture()
    RunService:UnbindFromRenderStep("Freecam")
    PlayerState.Pop()
    workspace.Camera.FieldOfView = 70
    fcRunning = false
end

addcmd('freecam', { 'fc' }, function(args, speaker)
    StartFreecam()
end)

addcmd('freecampos', { 'fcpos', 'fcp', 'freecamposition', 'fcposition' }, function(args, speaker)
    if not args[1] then return end
    local freecamPos = CFrame.new(args[1], args[2], args[3])
    StartFreecam(freecamPos)
end)

addcmd('freecamwaypoint', { 'fcwp' }, function(args, speaker)
    local WPName = tostring(getstring(1))
    if speaker.Character then
        for i, _ in pairs(WayPoints) do
            local x = WayPoints[i].COORD[1]
            local y = WayPoints[i].COORD[2]
            local z = WayPoints[i].COORD[3]
            if tostring(WayPoints[i].NAME):lower() == tostring(WPName):lower() then
                StartFreecam(CFrame.new(x, y, z))
            end
        end
        for i, _ in pairs(pWayPoints) do
            if tostring(pWayPoints[i].NAME):lower() == tostring(WPName):lower() then
                StartFreecam(CFrame.new(pWayPoints[i].COORD[1].Position))
            end
        end
    end
end)

addcmd('freecamgoto', { 'fcgoto', 'freecamtp', 'fctp' }, function(args, speaker)
    local players = getPlayer(args[1], speaker)
    for i, v in pairs(players) do
        StartFreecam(getRoot(Players[v].Character).CFrame)
    end
end)

addcmd('unfreecam', { 'nofreecam', 'unfc', 'nofc' }, function(args, speaker)
    StopFreecam()
end)

addcmd('freecamspeed', { 'fcspeed' }, function(args, speaker)
    local FCspeed = args[1] or 1
    if isNumber(FCspeed) then
        NAV_KEYBOARD_SPEED = Vector3.new(FCspeed, FCspeed, FCspeed)
    end
end)

addcmd('notifyfreecamposition', { 'notifyfcpos' }, function(args, speaker)
    if fcRunning then
        local X, Y, Z = workspace.CurrentCamera.CFrame.Position.X, workspace.CurrentCamera.CFrame.Position.Y,
            workspace.CurrentCamera.CFrame.Position.Z
        local Format, Round = string.format, math.round
        notify("Current Position", Format("%s, %s, %s", Round(X), Round(Y), Round(Z)))
    end
end)

addcmd('copyfreecamposition', { 'copyfcpos' }, function(args, speaker)
    if fcRunning then
        local X, Y, Z = workspace.CurrentCamera.CFrame.Position.X, workspace.CurrentCamera.CFrame.Position.Y,
            workspace.CurrentCamera.CFrame.Position.Z
        local Format, Round = string.format, math.round
        toClipboard(Format("%s, %s, %s", Round(X), Round(Y), Round(Z)))
    end
end)

addcmd('gotocamera', { 'gotocam', 'tocam' }, function(args, speaker)
    getRoot(speaker.Character).CFrame = workspace.Camera.CFrame
end)

addcmd('tweengotocamera', { 'tweengotocam', 'tgotocam', 'ttocam' }, function(args, speaker)
    TweenService:Create(getRoot(speaker.Character), TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear),
        { CFrame = workspace.Camera.CFrame }):Play()
end)

addcmd('fov', {}, function(args, speaker)
    local fov = args[1] or 70
    if isNumber(fov) then
        workspace.CurrentCamera.FieldOfView = fov
    end
end)

local preMaxZoom = Players.LocalPlayer.CameraMaxZoomDistance
local preMinZoom = Players.LocalPlayer.CameraMinZoomDistance
addcmd('lookat', {}, function(args, speaker)
    if speaker.CameraMaxZoomDistance ~= 0.5 then
        preMaxZoom = speaker.CameraMaxZoomDistance
        preMinZoom = speaker.CameraMinZoomDistance
    end
    speaker.CameraMaxZoomDistance = 0.5
    speaker.CameraMinZoomDistance = 0.5
    wait()
    local players = getPlayer(args[1], speaker)
    for i, v in pairs(players) do
        local target = Players[v].Character
        if target and target:FindFirstChild('Head') then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.p, target.Head.CFrame.p)
            wait(0.1)
        end
    end
    speaker.CameraMaxZoomDistance = preMaxZoom
    speaker.CameraMinZoomDistance = preMinZoom
end)

addcmd('fixcam', { 'restorecam' }, function(args, speaker)
    StopFreecam()
    execCmd('unview')
    workspace.CurrentCamera:remove()
    wait(.1)
    repeat wait() until speaker.Character ~= nil
    workspace.CurrentCamera.CameraSubject = speaker.Character:FindFirstChildWhichIsA('Humanoid')
    workspace.CurrentCamera.CameraType = "Custom"
    speaker.CameraMinZoomDistance = 0.5
    speaker.CameraMaxZoomDistance = 400
    speaker.CameraMode = "Classic"
    speaker.Character.Head.Anchored = false
end)
