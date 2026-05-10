local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "??",
    SubTitle = "doll",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main    = Window:AddTab({ Title = "Combat",  Icon = "crosshair" }),
    Visual  = Window:AddTab({ Title = "Visual",  Icon = "eye"       }),
    Players = Window:AddTab({ Title = "Players", Icon = "users"     })
}

local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

_G.HitboxEnabled      = false
_G.HitboxSize         = 60
_G.HitboxTransparency = 0.7
_G.ESPEnabled         = false
_G.PullEnabled        = false
_G.PullDistance       = 2
_G.LockMeEnabled      = false

-- ========================
-- HITBOX
-- ========================
local hitboxParts = {}

local function enableHitboxForPlayer(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if hitboxParts[player] then
        hitboxParts[player]:Destroy()
        hitboxParts[player] = nil
    end

    local part = Instance.new("Part")
    part.Name         = "HitboxExpander"
    part.Size         = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
    part.Transparency = _G.HitboxTransparency
    part.BrickColor   = BrickColor.new("Really blue")
    part.Material     = Enum.Material.Neon
    part.CanCollide   = false
    part.Massless     = true
    part.Anchored     = false
    part.Parent       = char

    local weld = Instance.new("WeldConstraint")
    weld.Part0  = part
    weld.Part1  = hrp
    weld.Parent = part

    hitboxParts[player] = part
end

local function disableAllHitbox()
    for p, part in pairs(hitboxParts) do
        if part then part:Destroy() end
        hitboxParts[p] = nil
    end
end

-- ========================
-- ESP
-- ========================
local espTags = {}

local function createESP(player)
    if player == LocalPlayer then return end
    local function onCharacter(char)
        local head = char:WaitForChild("Head", 5)
        if not head then return end
        if head:FindFirstChild("ESP_BB") then head:FindFirstChild("ESP_BB"):Destroy() end

        local bb = Instance.new("BillboardGui")
        bb.Name        = "ESP_BB"
        bb.Adornee     = head
        bb.Size        = UDim2.new(0, 120, 0, 30)
        bb.StudsOffset = Vector3.new(0, 2.5, 0)
        bb.AlwaysOnTop = true
        bb.Parent      = head

        local lbl = Instance.new("TextLabel")
        lbl.Size                   = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text                   = player.Name
        lbl.TextColor3             = Color3.fromRGB(255, 255, 0)
        lbl.TextStrokeTransparency = 0
        lbl.TextScaled             = true
        lbl.Font                   = Enum.Font.GothamBold
        lbl.Parent                 = bb

        espTags[player] = bb
    end
    if player.Character then onCharacter(player.Character) end
    player.CharacterAdded:Connect(onCharacter)
end

local function removeESP(player)
    if espTags[player] then espTags[player]:Destroy() espTags[player] = nil end
end

local function clearAllESP()
    for p in pairs(espTags) do removeESP(p) end
end

-- ========================
-- PULL + FREEZE
-- ========================
local frozenCFrames  = {}
local savedPositions = {}
local pulledOnce     = {}
local freezeConn     = nil
local myLockedCFrame = nil  -- ล็อคตำแหน่งเรา

local function ejectFromVehicle(player)
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.SeatPart then
        hum.Sit = false
        task.wait(0.2)
    end
end

local function startFreezeLoop()
    if freezeConn then return end
    freezeConn = RunService.Heartbeat:Connect(function()

        -- ล็อคเรา
        if _G.LockMeEnabled and myLockedCFrame then
            local lc = LocalPlayer.Character
            if lc then
                local lhrp = lc:FindFirstChild("HumanoidRootPart")
                if lhrp then
                    lhrp.CFrame                  = myLockedCFrame
                    lhrp.AssemblyLinearVelocity  = Vector3.zero
                    lhrp.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end

        -- ล็อคเป้า
        for player, cf in pairs(frozenCFrames) do
            if player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local hum = player.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.SeatPart then hum.Sit = false end
                    hrp.CFrame                  = cf
                    hrp.AssemblyLinearVelocity  = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end
    end)
end

local function stopFreezeLoopIfUnneeded()
    if not _G.PullEnabled and not _G.LockMeEnabled then
        if freezeConn then
            freezeConn:Disconnect()
            freezeConn = nil
        end
    end
end

local function pullAndFreeze()
    local lc = LocalPlayer.Character
    if not lc then return end
    local lhrp = lc:FindFirstChild("HumanoidRootPart")
    if not lhrp then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp and not pulledOnce[player] then
                if not savedPositions[player] then
                    savedPositions[player] = hrp.CFrame
                end
                task.spawn(function()
                    ejectFromVehicle(player)
                    local targetCF = lhrp.CFrame * CFrame.new(0, 0, -_G.PullDistance)
                    hrp.CFrame                  = targetCF
                    hrp.AssemblyLinearVelocity  = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                    frozenCFrames[player]       = targetCF
                    pulledOnce[player]          = true
                end)
            end
        end
    end
    startFreezeLoop()
end

local function stopAllPull()
    frozenCFrames  = {}
    pulledOnce     = {}

    local toReturn = {}
    for player, cf in pairs(savedPositions) do
        toReturn[player] = cf
    end
    savedPositions = {}

    stopFreezeLoopIfUnneeded()

    task.delay(5, function()
        for player, cf in pairs(toReturn) do
            if player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = cf end
            end
        end
    end)
end

local function refreshAll()
    for player, cf in pairs(savedPositions) do
        if player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = cf end
        end
    end

    frozenCFrames  = {}
    pulledOnce     = {}
    savedPositions = {}
    _G.PullEnabled = false

    stopFreezeLoopIfUnneeded()

    if Fluent.Options and Fluent.Options.PullToggle then
        Fluent.Options.PullToggle:SetValue(false)
    end

    Fluent:Notify({
        Title    = "Refreshed",
        Content  = "ส่งผู้เล่นทั้งหมดกลับที่เดิมแล้ว",
        Duration = 3
    })
end

-- ========================
-- Main Heartbeat
-- ========================
RunService.Heartbeat:Connect(function()
    if _G.HitboxEnabled then
        for _, part in pairs(hitboxParts) do
            if part and part.Parent then
                part.Size         = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                part.Transparency = _G.HitboxTransparency
            end
        end
    end

    if _G.PullEnabled then
        pullAndFreeze()
    end
end)

-- ========================
-- COMBAT TAB
-- ========================
Tabs.Main:AddToggle("HitboxToggle", {
    Title    = "Enable Hitbox Expander",
    Default  = false,
    Callback = function(Value)
        _G.HitboxEnabled = Value
        if Value then
            for _, player in pairs(Players:GetPlayers()) do
                enableHitboxForPlayer(player)
            end
            for _, p in pairs(Players:GetPlayers()) do
                p.CharacterAdded:Connect(function()
                    task.wait(1)
                    if _G.HitboxEnabled then enableHitboxForPlayer(p) end
                end)
            end
            Players.PlayerAdded:Connect(function(p)
                p.CharacterAdded:Connect(function()
                    task.wait(1)
                    if _G.HitboxEnabled then enableHitboxForPlayer(p) end
                end)
            end)
        else
            disableAllHitbox()
        end
    end
})

Tabs.Main:AddInput("HitboxSizeInput", {
    Title       = "Hitbox Size (ไม่มีลิมิต)",
    Description = "พิมพ์ขนาด hitbox แล้วกด Enter",
    Default     = "60",
    Numeric     = true,
    Finished    = true,
    Callback    = function(Value)
        local num = tonumber(Value)
        if num and num > 0 then
            _G.HitboxSize = num
            if _G.HitboxEnabled then
                disableAllHitbox()
                for _, player in pairs(Players:GetPlayers()) do
                    enableHitboxForPlayer(player)
                end
            end
        end
    end
})

Tabs.Main:AddSlider("TransparencySlider", {
    Title       = "Hitbox Transparency",
    Description = "ความโปร่งแสง (0 = ทึบ, 10 = ใส)",
    Default     = 7,
    Min         = 0,
    Max         = 10,
    Rounding    = 1,
    Callback    = function(Value)
        _G.HitboxTransparency = Value / 10
    end
})

-- ========================
-- VISUAL TAB
-- ========================
Tabs.Visual:AddToggle("ESPToggle", {
    Title    = "ESP — แสดงชื่อบนหัว",
    Default  = false,
    Callback = function(Value)
        _G.ESPEnabled = Value
        if Value then
            for _, player in pairs(Players:GetPlayers()) do createESP(player) end
            Players.PlayerAdded:Connect(function(p)
                if _G.ESPEnabled then createESP(p) end
            end)
            Players.PlayerRemoving:Connect(removeESP)
        else
            clearAllESP()
        end
    end
})

-- ========================
-- PLAYERS TAB
-- ========================
Tabs.Players:AddToggle("LockMeToggle", {
    Title       = "Lock Me (ล็อคตัวเราอยู่กับที่)",
    Description = "ขยับไม่ได้เลย — ปิดเพื่อเดินได้อีกครั้ง",
    Default     = false,
    Callback    = function(Value)
        _G.LockMeEnabled = Value
        if Value then
            local lc = LocalPlayer.Character
            if lc then
                local lhrp = lc:FindFirstChild("HumanoidRootPart")
                if lhrp then
                    myLockedCFrame = lhrp.CFrame  -- บันทึกตำแหน่งตอนกด
                end
            end
            startFreezeLoop()
        else
            myLockedCFrame = nil
            stopFreezeLoopIfUnneeded()
        end
    end
})

Tabs.Players:AddToggle("PullToggle", {
    Title       = "Pull + Freeze Players",
    Description = "ดึงเฉพาะตัวคน ล็อคนิ่ง — ปิดแล้วรอ 5 วิวาปกลับ",
    Default     = false,
    Callback    = function(Value)
        _G.PullEnabled = Value
        if not Value then stopAllPull() end
    end
})

Tabs.Players:AddInput("PullDistanceInput", {
    Title       = "Pull Distance (studs)",
    Description = "ระยะห่างด้านหน้า (แนะนำ 2-5)",
    Default     = "2",
    Numeric     = true,
    Finished    = true,
    Callback    = function(Value)
        local num = tonumber(Value)
        if num and num >= 0 then
            _G.PullDistance = num
        end
    end
})

Tabs.Players:AddButton({
    Title       = "Refresh (ส่งทุกคนกลับทันที)",
    Description = "วาปทุกคนกลับตำแหน่งเดิม + reset state",
    Callback    = function()
        refreshAll()
    end
})

-- ========================
-- Init
-- ========================
Window:SelectTab(1)

Fluent:Notify({
    Title    = "Loaded",
    Content  = "Hitbox + ESP + Pull/Freeze + Lock Me พร้อมใช้งาน",
    Duration = 5
})
