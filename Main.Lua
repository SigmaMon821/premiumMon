local player = game.Players.LocalPlayer 
widocal hwid = (gethwid and gethwid()) or game:GetService("RbxAnalyticsService"):GetClientId()

local whitelist_url = "https://pastebin.com/raw/VYuKUsTh"

local success, whitelist = pcall(function()
    return loadstring(game:HttpGet(whitelist_url))()
end)

-- เช็กว่าโหลดสำเร็จไหม, ข้อมูลเป็นตารางไหม และ HWID ตรงไหม
if not success or type(whitelist) ~= "table" or not whitelist[hwid] then
    
    if setclipboard then
        pcall(function() setclipboard(hwid) end)
    end

    -- เตะผู้เล่นและโชว์ข้อความ
    player:Kick("\n❌ ไม่พบสิทธิ์การใช้งาน (Paid Version)\n\n" ..
                "รหัสเครื่องของคุณคือ:\n" .. hwid .. "\n\n" ..
                "(ระบบได้คัดลอกรหัสนี้ไว้ให้แล้ว สามารถกดวางในแชทได้เลย)\n\n" ..
                "ติดต่อ FB: ม่อนพ่อพวกมึง\n")
    
    return 
end

-- ==========================================
-- [2] ระบบจัดการ UI (แก้บั๊ก CoreGui สำหรับมือถือ)
-- ==========================================
local TargetGui = (gethui and gethui()) or game:GetService("CoreGui")
local successGui = pcall(function() local _ = TargetGui.Name end)
if not successGui then
    TargetGui = player:WaitForChild("PlayerGui")
end
-- ==========================================

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

if TargetGui:FindFirstChild("FluentToggle") then TargetGui.FluentToggle:Destroy() end

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
    MinimizeKey = Enum.KeyCode.LeftControl
})

local ToggleButton = Instance.new("ScreenGui")
ToggleButton.Name = "FluentToggle"
ToggleButton.ResetOnSpawn = false
ToggleButton.Parent = TargetGui

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
    for _, gui in pairs(TargetGui:GetChildren()) do
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

-- [[ MAIN TAB: AUTO FEATURES ]] --

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

Tabs.Main:AddToggle("AutoPackage", {Title = "Auto Package", Default = false}):OnChanged(function(v)
    _G.AutoPackage = v
    if v then
        pcall(function()
            loadstring(game:HttpGet("https://pastebin.com/raw/mz25jTgu"))()
        end)
    end
end)
-- ==========================================

local autoRemoteKill = false
local hakiArgs = {
    [1] = "On",
    [2] = 2
}

Tabs.Main:AddToggle("AutoRemoteKill", {Title = "Auto Farm Haki (OP)", Default = false}):OnChanged(function(v)
    autoRemoteKill = v
    if autoRemoteKill then
        task.spawn(function()
            local userFolder = workspace.UserData:FindFirstChild("User_" .. tostring(player.UserId))
            local remoteEvent = userFolder and userFolder:FindFirstChild("III")

            if remoteEvent then
                while autoRemoteKill do
                    remoteEvent:FireServer(unpack(hakiArgs))
                    task.wait(0.55) 
                end
            else
                Fluent:Notify({
                    Title = "Error",
                    Content = "UserData or RemoteEvent 'III' not found",
                    Duration = 3
                })
            end
        end)
    end
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

local autoFindHaki = false
Tabs.Main:AddToggle("AutoHakiNPC", {Title = "Auto Teleport to Haki NPC", Default = false}):OnChanged(function(v)
    autoFindHaki = v
    if autoFindHaki then
        task.spawn(function()
            while autoFindHaki do
                local npc = workspace:FindFirstChild("QuestHakiMerchant", true)
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")

                if npc and npc:FindFirstChild("HumanoidRootPart") and hrp then
                    Fluent:Notify({
                        Title = "Haki Merchant Found!",
                        Content = "Teleporting...",
                        Duration = 3
                    })
                    hrp.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                    task.wait(5) 
                end
                task.wait(2) 
            end
        end)
    end
end)

local wantedItems = {
    ["Rare Box"]=true, ["Ultra Rare Box"]=true, ["Chilly Fruit"]=true, ["Vampire Fruit"]=true,
    ["Sand Fruit"]=true, ["Plasma Fruit"]=true, ["Snow Fruit"]=true, ["Light Fruit"]=true,
    ["Candy Fruit"]=true, ["Quake Fruit"]=true, ["Blood Fruit"]=true, ["Ope Fruit"]=true,
    ["Gum Fruit"]=true, ["Dark Fruit"]=true, ["Rumble Fruit"]=true, ["Gravity Fruit"]=true,
    ["Venom Fruit"]=true, ["Magma Fruit"]=true, ["Gas Fruit"]=true, ["Hollow Fruit"]=true, ["Flare Fruit"]=true
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
            text.Text = "⭐ " .. plr.Name .. " Has: " .. found
        else
            local text = tag:FindFirstChildOfClass("TextLabel")
            if text then text.Text = "⭐ " .. plr.Name .. " Has: " .. found end
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
    ["Castle"] = safePos * CFrame.new(0, 2, 0),
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
    ["Fish Spot"] = CFrame.new(1767.62, 215, 814.59),
    ["Merlin"] = CFrame.new(-1700.5365, 215.999985, -328.792603, -0.801688135, 1.01198889e-08, -0.597742558, -7.09675385e-09, 1, 2.6448296e-08, 0.597742558, 2.5445317e-08, -0.801688135)
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

-- [[ MERCHANTS TELEPORT SYSTEM  ]] --
getgenv().Tabs = Tabs
getgenv().Fluent = Fluent
pcall(function() 
    loadstring(game:HttpGet("https://pastebin.com/raw/v7SLRDsm"))() 
end)

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

Tabs.Misc:AddParagraph({ Title = "Safety & Character Mods", Content = "Character and movement modifications" })

-- [[ ANTI ADMIN TOGGLE ADDED HERE ]] --
local antiAdminLoaded = false
Tabs.Misc:AddToggle("AntiAdminToggle", {Title = "Anti Admin/Mod (Kick)", Default = false}):OnChanged(function(v)
    if v and not antiAdminLoaded then
        antiAdminLoaded = true
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://pastebin.com/raw/fuDuZziN"))()
            end)
        end)
    elseif not v and antiAdminLoaded then
        Fluent:Notify({
            Title = "Notice",
            Content = "Anti Admin script is already loaded and active.",
            Duration = 3
        })
    end
end)

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

Tabs.Misc:AddButton({
    Title = "Drop Item",
    Callback = function()
        if player.Character and player.Character:FindFirstChildOfClass("Tool") then
            player.Character:FindFirstChildOfClass("Tool").Parent = workspace
        end
    end
})

Tabs.Server:AddParagraph({ Title = "Server Management", Content = "Current Job ID:\n" .. tostring(game.JobId) })

Tabs.Server:AddButton({
    Title = "Copy Current Job ID",
    Callback = function()
        if setclipboard then
            setclipboard(tostring(game.JobId))
            Fluent:Notify({Title = "Copied!", Content = "Job ID copied to clipboard.", Duration = 3})
        else
            Fluent:Notify({Title = "Error", Content = "Executor doesn't support setclipboard.", Duration = 3})
        end
    end
})

local targetJobId = ""
Tabs.Server:AddInput("InputJobId", {
    Title = "Enter Job ID",
    Default = "",
    Placeholder = "Paste Job ID here...",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        targetJobId = Value
    end
})

Tabs.Server:AddButton({
    Title = "Join Server",
    Callback = function()
        if targetJobId ~= "" then
            Fluent:Notify({Title = "Teleporting...", Content = "Joining target server.", Duration = 5})
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, targetJobId, player)
            end)
        else
            Fluent:Notify({Title = "Error", Content = "Please enter a Job ID first.", Duration = 3})
        end
    end
})

Window:SelectTab(1)
Fluent:Notify({
    Title = "Mon ver.Paid",
    Content = "Welcome! (Paid Version)",
    Duration = 5
})
   
  "ItemESP");if (itemESP and found) then if  not tag then tag=Instance.new("BillboardGui",plr.Character.Head);tag.Name="ItemESP";tag.Size=UDim2.new(0,150,0,30);tag.        
  AlwaysOnTop=true;tag.ExtentsOffset=Vector3.new(0,3,0);local text=Instance.new("TextLabel",tag);text.Size=UDim2.new(1,0,1,0);text.BackgroundTransparency=1;text.TextColor3 
  =Color3.fromRGB(255,255,0);text.TextScaled=true;text.Text="โญ "   .. plr.Name   .. " Has: "   .. found ;else local text=tag:FindFirstChildOfClass("TextLabel");if text     
  then text.Text="โญ "   .. plr.Name   .. " Has: "   .. found ;end end elseif tag then tag:Destroy();end end Tabs.Main:AddToggle("ItemESP",{Title="Item ESP",Default=false}) 
  :OnChanged(function(v) itemESP=v;if v then task.spawn(function() while itemESP do for _,p in pairs(Players:GetPlayers()) do pcall(function() updateItemESP(p);end);end    
  task.wait(2);end end);end end);local autoPickup=false;Tabs.Main:AddToggle("AutoPickup",{Title="Auto Pickup & Return",Default=false}):OnChanged(function(v) autoPickup=v;  
  if v then task.spawn(function() while autoPickup do task.wait(0.5);local char=player.Character;local hrp=char and char:FindFirstChild("HumanoidRootPart") ;if hrp then    
  local originalPos=hrp.CFrame;local collectedSomething=false;for _,obj in pairs(workspace:GetDescendants()) do if (obj:IsA("Tool") and obj:FindFirstChild("Handle")) then  
  local isWanted=false;for name,_ in pairs(wantedItems) do if obj.Name:find(name) then isWanted=true;break;end end if obj.Name:find("Compass") then isWanted=true;end if (  
  isWanted and obj.Parent and  not obj.Parent:FindFirstChild("Humanoid")) then collectedSomething=true;hrp.CFrame=obj.Handle.CFrame;task.wait(0.2);firetouchinterest(hrp,   
  obj.Handle,0);task.wait(0.1);firetouchinterest(hrp,obj.Handle,1);local click=obj.Handle:FindFirstChildOfClass("ClickDetector");if click then fireclickdetector(click);end 
   local prompt=obj:FindFirstChildOfClass("ProximityPrompt",true);if prompt then fireproximityprompt(prompt);end task.wait(0.5);end end end if (collectedSomething and hrp) 
   then hrp.CFrame=originalPos;task.wait(1);end end end end);end end);Tabs.Main:AddButton({Title="Auto Smelt",Callback=function() pcall(function() loadstring(game:       
  HttpGet("https://pastebin.com/raw/6yBSTgmm"))();end);end});Tabs.Main:AddButton({Title="Auto Fish MB",Callback=function() pcall(function() loadstring(game:HttpGet(      
  "https://pastebin.com/raw/Fy54yU3P"))();end);end});Tabs.Main:AddButton({Title="Auto Fish PC",Callback=function() pcall(function() loadstring(game:HttpGet(              
    "https://pastebin.com/raw/Vx68tpY4"))();end);end});local tpLocations={["AFK FISHING"]=CFrame.new( -5700.45,222.97, -14696.02),Castle=safePos * CFrame.new(0,2,0) ,[   
    "Sam (Main)"]=CFrame.new( -1281.53,215, -1339.01),["Bob & Crab"]=CFrame.new(25.95,221, -95.08),["Cave Diamond (Lvl.40)"]=CFrame.new( -86.44,213, -894.27),[           
    "Rayleigh Cave"]=CFrame.new(2057.18,487, -667.79),["Snow Mountains"]=CFrame.new(6648.43,415.99, -1460.59),["Evill Island"]=CFrame.new( -5311.14,213, -7618.62),       
    Pyramid=CFrame.new(118.52,307,4946.11),["Vokun Island"]=CFrame.new(4573.06,214,5055.81),Club=CFrame.new(1509.47,257.38,2165.49),Desert=CFrame.new(1078.03,242.2, -    
      3333.11),Forest=CFrame.new( -6042.84,399, -10.66),["Fish Spot"]=CFrame.new(1767.62,215,814.59),Merlin=CFrame.new( -1700.5365,215.999985, -328.792603, -           
      0.801688135,1.0119889e-8, -0.597742558, -7.096754e-9,1,2.6448296e-8,0.597742558,2.5445317e-8, -0.801688135)};for name,cf in pairs(tpLocations) do Tabs.       
      Teleport:AddButton({Title="Teleport to "   .. name ,Callback=function() local lp=game:GetService("Players").LocalPlayer;if (lp and lp.Character and lp.Character: 
        FindFirstChild("HumanoidRootPart")) then lp.Character.HumanoidRootPart.CFrame=cf;end end});end getgenv().Tabs=Tabs;getgenv().Fluent=Fluent;pcall(function()     
        loadstring(game:HttpGet("https://pastebin.com/raw/v7SLRDsm"))();end);local selectedPlr=nil;local function getPlrs() local t={};for _,p in pairs(game:GetService 
        ("Players"):GetPlayers()) do if (p~=player) then table.insert(t,p.Name);end end if ( #t==0) then table.insert(t,"No other players");end return t;end local      
          PDrop=Tabs.Player:AddDropdown("PlayerSelector",{Title="Select Target Player",Values=getPlrs(),Callback=function(v) selectedPlr=v;end});Tabs.Player:         
            AddButton({Title="Refresh Player List",Callback=function() PDrop:SetValues(getPlrs());end});Tabs.Player:AddButton({Title="Teleport to Player",Callback=   
              function() local target=game:GetService("Players"):FindFirstChild(selectedPlr);if (player.Character and player.Character:FindFirstChild(                
                "HumanoidRootPart") and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")) then player.Character.HumanoidRootPart.  
                  CFrame=target.Character.HumanoidRootPart.CFrame;end end});Tabs.Misc:AddParagraph({Title="Safety & Character Mods",Content=                        
                      "Character and movement modifications"});local antiAdminLoaded=false;Tabs.Misc:AddToggle("AntiAdminToggle",{Title="Anti Admin/Mod (Kick)",    
                                  Default=false}):OnChanged(function(v) if (v and  not antiAdminLoaded) then antiAdminLoaded=true;task.spawn(function() pcall(      
                                      function() loadstring(game:HttpGet("https://pastebin.com/raw/fuDuZziN"))();end);end);elseif ( not v and antiAdminLoaded) then 
                                       Fluent:Notify({Title="Notice",Content=                               "Anti Admin script is already loaded and active.",      
                                      Duration=3});end end);local noclip=false;RunService.Stepped:          Connect(function() if (noclip and player.Character)   
                                      then for _,v in pairs(player.Character:GetDescendants()) do           if v:IsA("BasePart") then v.CanCollide=false;end end  
                                      end end);Tabs.Misc:AddToggle("NC",{Title="Noclip",Default=            false}):OnChanged(function(v) noclip=v;end);local     
                                      infJump=false;game:GetService("UserInputService").JumpRequest           :Connect(function() if (infJump and player.         
                                      Character) then player.Character.Humanoid:ChangeState(                  "Jumping");end end);Tabs.Misc:AddToggle("IJ",{Title 
                                      ="Infinite Jump",Default=false}):OnChanged(function(v)                  infJump=v;end);local VirtualUser=game:GetService( 
                                        "VirtualUser");local antiAfk=false;local afkConnection=nil;           Tabs.Misc:AddToggle("AntiAFK",{Title="Anti AFK",  
                                        Default=false}):OnChanged(function(v) antiAfk=v;if antiAfk              then if  not afkConnection then afkConnection=  
                                        player.Idled:Connect(function() VirtualUser:                            CaptureController();VirtualUser:ClickButton2( 
                                        Vector2.new());end);end elseif afkConnection then                       afkConnection:Disconnect();afkConnection=nil; 
                                        end end);Tabs.Misc:AddButton({Title="Drop Item",Callback=                 function() if (player.Character and       
                                        player.Character:FindFirstChildOfClass("Tool")) then                      player.Character:FindFirstChildOfClass(   
                                          "Tool").Parent=workspace;end end});Tabs.Server:                           AddParagraph({Title=                  
                                          "Server Management",Content="Current Job ID:\n"   ..                        tostring(game.JobId) });Tabs.   
                                            Server:AddButton({Title="Copy Current Job ID",                              Callback=function() if    
                                            setclipboard then setclipboard(tostring(game.                                     JobId));    
                                              Fluent:Notify({Title="Copied!",Content=       
                                                "Job ID copied to clipboard.",Duration=3} 
                                                    );else Fluent:Notify({Title="Error" 
                                                          ,Content=               


"Executor doesn't support setclipboard.",Duration=3});end end});local targetJobId="";Tabs.Server:AddInput("InputJobId",{Title="Enter Job ID",Default="",Placeholder="Paste Job ID here...",Numeric=false,Finished=false,Callback=function(Value) targetJobId=Value;end});Tabs.Server:AddButton({Title="Join Server",Callback=function() if (targetJobId~="") then Fluent:Notify({Title="Teleporting...",Content="Joining target server.",Duration=5});pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId,targetJobId,player);end);else Fluent:Notify({Title="Error",Content="Please enter a Job ID first.",Duration=3});end end});Window:SelectTab(1);Fluent:Notify({Title="Mon ver.Paid",Content="Welcome! (Paid Version)",Duration=5});
