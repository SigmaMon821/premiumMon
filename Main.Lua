local player = game.Players.LocalPlayer
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()

local whitelist = {
    ["fe4b49cf-739c-4880-bd1b-967f53535bde"] = "hole", 
    ["2e976346-8ea2-40b4-8e88-a8700bf36fcc"] = "T!ne",
    ["0957ba2e-83d7-4510-afdf-c7978e10db6c"] = "TEE",
    ["7a1aaac1-eafb-4d3a-856b-c233dcdbdf42"] = "TEE2",
    ["983d6a73-8ad7-4ce1-9060-7a69c3fd3699"] = "ssss",
    ["45f19076-9698-4616-9285-d5f766c5c7c8"] = "67",

}

if not whitelist[hwid] then
    player:Kick([[
❌ ไม่พบสิทธิ์การใช้งาน (Paid Version)
รหัสเครื่องของคุณคือ:
]] .. hwid .. [[

ติดต่อ FB: ม่อนพ่อพวกมึง
]])
    return 
end

local safePos = CFrame.new(-1957.43555, 890.547974, 3335.74951, -0.999525309, -0.000334050157, -0.0308059342, -9.18123249e-07, 0.999941528, -0.0108132726, 0.0308077447, -0.0108081112, -0.999466896)
local partName = "SafeZonePlatform"

if not workspace:FindFirstChild(partName) then
    local platform = Instance.new("Part")
    platform.Name = partName
    platform.Size = Vector3.new(300, 1, 300)
    platform.CFrame = safePos
    platform.Anchored = true
    platform.Transparency = 0.5
    platform.BrickColor = BrickColor.new("Bright blue")
    platform.Parent = workspace
end

local afkPlatformName = "AFKFishingPlatform"
local afkCoords = Vector3.new(-5700.45, 220.97, -14696.02)

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

local Window = Fluent:CreateWindow({
    Title = "YT : MonPhopuakMung 2.0",
    SubTitle = "Paid Version | VIP: " .. (whitelist[hwid] or "พม่าลักลอบ"),
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 360),
    Acrylic = false, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
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
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" })
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

local autoRemoteKill = false
Tabs.Main:AddToggle("AutoRemoteKill", {Title = "Auto Farm Haki (OP)", Default = false}):OnChanged(function(v)
    autoRemoteKill = v
    task.spawn(function()
        while autoRemoteKill do
            local remote = workspace.UserData["User_" .. player.UserId]:FindFirstChild("III")
            if remote then remote:FireServer("On", 2) end
            task.wait(0.2)
        end
    end)
end)

local autoSam = false
Tabs.Main:AddToggle("AutoSam", {Title = "Auto Sam", Default = false}):OnChanged(function(v)
    autoSam = v
    if autoSam then
        task.spawn(function()
            local remote = game:GetService("ReplicatedStorage"):WaitForChild("Connections"):WaitForChild("Claim_Sam")
            while autoSam do
                pcall(function() remote:FireServer("Claim1") end)
                task.wait(3) 
            end
        end)
    end
end)

local wantedItems = {
    ["Rare Box"]=true, ["Ultra Rare Box"]=true, ["Chilly Fruit"]=true, ["Vampire Fruit"]=true,
    ["Sand Fruit"]=true, ["Plasma Fruit"]=true, ["Snow Fruit"]=true, ["Light Fruit"]=true,
    ["Candy Fruit"]=true, ["Quake Fruit"]=true, ["Blood Fruit"]=true, ["Ope Fruit"]=true,
    ["Gum Fruit"]=true, ["Dark Fruit"]=true, ["Rumble Fruit"]=true, ["Gravity Fruit"]=true,
    ["Venom Fruit"]=true, ["Magma Fruit"]=true, ["Gas Fruit"]=true, ["Hollow Fruit"]=true, ["Flame Fruit"]=true
}

local itemESP = false
local function updateItemESP(plr)
    if plr == player or not plr.Character or not plr.Character:FindFirstChild("Head") then return end
    local found = nil
    for _,item in pairs(plr.Backpack:GetChildren()) do
        for name, _ in pairs(wantedItems) do if item.Name:find(name) then found = item.Name break end end
        if found then break end
    end
    if not found then
        for _,item in pairs(plr.Character:GetChildren()) do
            if item:IsA("Tool") then
                for name, _ in pairs(wantedItems) do if item.Name:find(name) then found = item.Name break end end
                if found then break end
            end
        end
    end
    local tag = plr.Character.Head:FindFirstChild("ItemESP")
    if itemESP and found then
        if not tag then
            tag = Instance.new("BillboardGui", plr.Character.Head)
            tag.Name = "ItemESP"; tag.Size = UDim2.new(0, 150, 0, 30); tag.AlwaysOnTop = true; tag.ExtentsOffset = Vector3.new(0, 3, 0)
            local text = Instance.new("TextLabel", tag)
            text.Size = UDim2.new(1,0,1,0); text.BackgroundTransparency = 1; text.TextColor3 = Color3.fromRGB(255, 255, 0); text.TextScaled = true
            text.Text = "⭐ " .. plr.Name .. " มี: " .. found
        else
            local text = tag:FindFirstChildOfClass("TextLabel")
            if text then text.Text = "⭐ " .. plr.Name .. " มี: " .. found end
        end
    elseif tag then tag:Destroy() end
end

Tabs.Main:AddToggle("ItemESP", {Title = "Item ESP", Default = false}):OnChanged(function(v)
    itemESP = v
    if v then task.spawn(function() while itemESP do for _,p in pairs(Players:GetPlayers()) do pcall(function() updateItemESP(p) end) end task.wait(2) end end) end
end)

local autoPickup = false
Tabs.Main:AddToggle("AutoPickup", {Title = "Auto Pickup & Return", Default = false}):OnChanged(function(v)
    autoPickup = v
    if v then task.spawn(function()
        while autoPickup do
            task.wait(0.5)
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local originalPos = hrp.CFrame 
                local collectedSomething = false
                for _,obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
                        local isWanted = false
                        for name, _ in pairs(wantedItems) do if obj.Name:find(name) then isWanted = true break end end
                        
                        if obj.Name:find("Compass") then isWanted = true end

                        if isWanted and obj.Parent and not obj.Parent:FindFirstChild("Humanoid") then
                            collectedSomething = true
                            hrp.CFrame = obj.Handle.CFrame
                            task.wait(0.2)
                            firetouchinterest(hrp, obj.Handle, 0)
                            task.wait(0.1)
                            firetouchinterest(hrp, obj.Handle, 1)
                            local click = obj.Handle:FindFirstChildOfClass("ClickDetector")
                            if click then fireclickdetector(click) end
                            local prompt = obj:FindFirstChildOfClass("ProximityPrompt", true)
                            if prompt then fireproximityprompt(prompt) end
                            task.wait(0.5)
                        end
                    end
                end
                if collectedSomething and hrp then hrp.CFrame = originalPos; task.wait(1) end
            end
        end
    end) end
end)

Tabs.Main:AddButton({
    Title = "Auto Smelt",
    Callback = function()
        pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/6yBSTgmm"))() end)
    end
})

Tabs.Main:AddButton({
    Title = "Auto Fish MB",
    Callback = function()
        pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/Fy54yU3P"))() end)
    end
})

Tabs.Main:AddButton({
    Title = "Auto Fish PC",
    Callback = function()
        pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/Vx68tpY4"))() end)
    end
})

local tpLocations = {
    ["AFK FISHING"] = CFrame.new(-5700.45, 222.97, -14696.02),
    ["safe"] = safePos * CFrame.new(0, 2, 0),
    ["Sam (Main)"] = CFrame.new(-1281.53, 215, -1339.01),
    ["Bob & Crab"] = CFrame.new(25.95, 221, -95.08),
    ["Cave Diamond (Lvl.40)"] = CFrame.new(-86.44, 213, -894.27),
    ["Rayleigh Cave"] = CFrame.new(2057.18, 487, -667.79),
    ["Snow Mountains"] = CFrame.new(6648.43, 415.99, -1460.59),
    ["Evill Island"] = CFrame.new(-5311.14, 213, -7618.62),
    ["Pyramid"] = CFrame.new(118.52, 307, 4946.11),
    ["Vokun Island"] = CFrame.new(4573.06, 214, 5055.81),
    ["Club"] = CFrame.new(1509.47, 257.38, 2165.49),
    ["Desert"] = CFrame.new(1078.03, 242.2, -3333.11),
    ["Forest"] = CFrame.new(-6042.84, 399, -10.66),
    ["Fish Spot"] = CFrame.new(1767.62, 215, 814.59)
}

for name, cf in pairs(tpLocations) do
    Tabs.Teleport:AddButton({
        Title = "Teleport to " .. name,
        Callback = function()
            local lp = game:GetService("Players").LocalPlayer
            if lp and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                lp.Character.HumanoidRootPart.CFrame = cf
            end
        end
    })
end

local selectedPlr = nil
local function getPlrs()
    local t = {}
    for _,p in pairs(game:GetService("Players"):GetPlayers()) do 
        if p ~= player then table.insert(t, p.Name) end 
    end
    if #t == 0 then table.insert(t, "No other players") end
    return t
end

local PDrop = Tabs.Player:AddDropdown("PlayerSelector", {Title = "Select Target Player", Values = getPlrs(), Callback = function(v) selectedPlr = v end})

Tabs.Player:AddButton({Title = "Refresh Player List", Callback = function() PDrop:SetValues(getPlrs()) end})

Tabs.Player:AddButton({
    Title = "Teleport to Player", 
    Callback = function()
        local target = game:GetService("Players"):FindFirstChild(selectedPlr)
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then 
            player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame 
        end
    end
})

Tabs.Misc:AddParagraph({ Title = "Character Mods", Content = "ปรับแต่งตัวละครและการเคลื่อนไหว" })
local noclip = false
RunService.Stepped:Connect(function()
    if noclip and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)
Tabs.Misc:AddToggle("NC", {Title = "Noclip", Default = false}):OnChanged(function(v) noclip = v end)

local infJump = false
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump and player.Character then player.Character.Humanoid:ChangeState("Jumping") end
end)
Tabs.Misc:AddToggle("IJ", {Title = "Infinite Jump", Default = false}):OnChanged(function(v) infJump = v end)

Tabs.Misc:AddButton({
    Title = "Drop Item",
    Callback = function()
        if player.Character and player.Character:FindFirstChildOfClass("Tool") then
            player.Character:FindFirstChildOfClass("Tool").Parent = workspace
        end
    end
})

Window:SelectTab(1)
Fluent:Notify({
    Title = "Mon ver.Paid",
    Content = (whitelist[hwid] or "พม่าลักลอบ"),
    Duration = 5
})
