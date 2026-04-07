
local ApiUrl = "https://script.google.com/macros/s/AKfycbxLXa65hXwaEaq5YyvDM7MtEhbz_3PGJnxrvMHfJMEHau5rkbboclS5EF-XKZrRATUCXA/exec"

local nameofthescript = "YT : MonPhopuakMung 2.0 (Paid)"
local whoisitmadeby = "Mon"
local thenoteofthekey = "" 

local function LoadMainScript()
    local player = game.Players.LocalPlayer 
    local safePos = CFrame.new(-6.88, 200004.47, 194.75)
    local afkPlatformName = "AFKFishingPlatform"
    local afkCoords = Vector3.new(-5700.45, 216.97, -14696.02)

    if not workspace:FindFirstChild(afkPlatformName) then
        local afkFloor = Instance.new("Part")
        afkFloor.Name = afkPlatformName
        afkFloor.Size = Vector3.new(50, 1, 50)
        afkFloor.Position = afkCoords
        afkFloor.Anchored = true
        afkFloor.Transparency = 0.5
        afkFloor.BrickColor = BrickColor.new("Dark green")
        afkFloor.Material = Enum.Material.Neon
        afkFloor.Parent = workspace
    end

    if game.CoreGui:FindFirstChild("FluentToggle") then game.CoreGui.FluentToggle:Destroy() end

    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TeleportService = game:GetService("TeleportService")

    local Window = Fluent:CreateWindow({
        Title = "YT : MonPhopuakMung 2.0",
        SubTitle = "PaidVersion",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 360),
        Acrylic = false, 
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftAlt
    })

    local ToggleButton = Instance.new("ScreenGui", game.CoreGui)
    ToggleButton.Name = "FluentToggle"
    ToggleButton.ResetOnSpawn = false
    local MainButton = Instance.new("TextButton", ToggleButton)
    MainButton.Size = UDim2.new(0, 50, 0, 50)
    MainButton.Position = UDim2.new(0.05, 0, 0.15, 0)
    MainButton.Text = "🧩"
    MainButton.TextSize = 30
    MainButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainButton.TextColor3 = Color3.new(1, 1, 1)
    MainButton.Draggable = true
    MainButton.Active = true
    local UICorner = Instance.new("UICorner", MainButton)
    UICorner.CornerRadius = UDim.new(0, 12)

    MainButton.MouseButton1Click:Connect(function()
        for _, gui in pairs(game.CoreGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui:FindFirstChild("Frame") and gui.Name ~= "FluentToggle" then
                gui.Enabled = not gui.Enabled
            end
        end
    end)

    local Tabs = {
        Main = Window:AddTab({ Title = "Home", Icon = "home" }),
        Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
        Player = Window:AddTab({ Title = "Player", Icon = "user" }),
        Misc = Window:AddTab({ Title = "Misc", Icon = "settings" }),
        Server = Window:AddTab({ Title = "Server", Icon = "globe" })
    }

    local autoClick = false
    Tabs.Main:AddToggle("AutoClick", {Title = "Auto Click", Default = false}):OnChanged(function(v)
        autoClick = v
        task.spawn(function()
            while autoClick do
                local char = player.Character
                if char then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
                task.wait(0.12)
            end
        end)
    end)

    Tabs.Main:AddButton({Title = "Auto Smelt", Callback = function() pcall(function()
    Tabs.Main:AddButton({Title = "Auto Fish PC", Callback = function() pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/Vx68tpY4"))() end) end})


    local VirtualUser = game:GetService("VirtualUser")
    local antiAfk = false
    local afkConnection = nil

    Tabs.Misc:AddToggle("AntiAFK", {Title = "Anti AFK", Default = false}):OnChanged(function(v)
        antiAfk = v
        if antiAfk then
            if not afkConnection then
                afkConnection = player.Idled:Connect(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end
        else
            if afkConnection then
                afkConnection:Disconnect()
                afkConnection = nil
            end
        end
    end)

    Window:SelectTab(1)
    Fluent:Notify({Title = "Mon ver.Paid", Content = "Welcome! (Paid Version)", Duration = 5})
end

local function LoadUI()
    local ScreenGui = Instance.new("ScreenGui")
    local KeySystem = Instance.new("Frame")
    local KeyTextbox = Instance.new("TextBox")
    local UICorner = Instance.new("UICorner")
    local UICorner_2 = Instance.new("UICorner")
    local title = Instance.new("TextLabel")
    local TextButton = Instance.new("TextButton")
    local UICorner_3 = Instance.new("UICorner")
    local scriptname = Instance.new("TextLabel")
    local madeby = Instance.new("TextLabel")
    local note = Instance.new("TextLabel")

    pcall(function() ScreenGui.Parent = game.CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    KeySystem.Name = "KeySystem"
    KeySystem.Parent = ScreenGui
    KeySystem.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    KeySystem.Position = UDim2.new(0.379, 0, 0.329, 0)
    KeySystem.Size = UDim2.new(0.24, 0, 0.34, 0)
    KeySystem.Active = true
    KeySystem.Draggable = true

    KeyTextbox.Name = "KeyTextbox"
    KeyTextbox.Parent = KeySystem
    KeyTextbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    KeyTextbox.BackgroundTransparency = 0.950
    KeyTextbox.Position = UDim2.new(0.093, 0, 0.734, 0)
    KeyTextbox.Size = UDim2.new(0.813, 0, 0.161, 0)
    KeyTextbox.Font = Enum.Font.Gotham
    KeyTextbox.Text = "Enter Key"
    KeyTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyTextbox.TextScaled = true

    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = KeyTextbox
    UICorner_2.CornerRadius = UDim.new(0, 15)
    UICorner_2.Parent = KeySystem

    title.Name = "title"
    title.Parent = KeySystem
    title.BackgroundTransparency = 1.000
    title.Position = UDim2.new(0, 0, 0.032, 0)
    title.Size = UDim2.new(1, 0, 0.197, 0)
    title.Font = Enum.Font.Gotham
    title.Text = "Key System"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true

    TextButton.Parent = KeySystem
    TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.BackgroundTransparency = 0.950
    TextButton.Position = UDim2.new(0.092, 0, 0.504, 0)
    TextButton.Size = UDim2.new(0.813, 0, 0.161, 0)
    TextButton.Font = Enum.Font.Gotham
    TextButton.Text = "Check Key"
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.TextScaled = true

    UICorner_3.CornerRadius = UDim.new(0, 15)
    UICorner_3.Parent = TextButton

    scriptname.Parent = KeySystem
    scriptname.BackgroundTransparency = 1.000
    scriptname.Position = UDim2.new(0, 0, 0.262, 0)
    scriptname.Size = UDim2.new(1, 0, 0.08, 0)
    scriptname.Font = Enum.Font.Gotham
    scriptname.Text = nameofthescript
    scriptname.TextColor3 = Color3.fromRGB(255, 255, 255)
    scriptname.TextScaled = true

    madeby.Parent = KeySystem
    madeby.BackgroundTransparency = 1.000
    madeby.Position = UDim2.new(0, 0, 0.368, 0)
    madeby.Size = UDim2.new(1, 0, 0.08, 0)
    madeby.Font = Enum.Font.Gotham
    madeby.Text = "Made by: " .. whoisitmadeby
    madeby.TextColor3 = Color3.fromRGB(255, 255, 255)
 