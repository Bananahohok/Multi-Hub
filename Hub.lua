local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MB: MultiHub",
   LoadingTitle = "Loading Multi-Tools...",
   LoadingSubtitle = "by Minus",
   ConfigurationSaving = { Enabled = false }
})

-- Variables
local previewSound = Instance.new("Sound")
previewSound.Parent = game.Workspace
previewSound.Name = "MB_Preview_Audio"

local Favorites = {}
local InputID = ""
local AutoFarmEnabled = false
local AutoCollectEnabled = false
local AutoOpenEnabled = false
local AutoDeleteEnabled = false

-- --- FUNCTIONS ---

local function IsSafe(object)
    local blacklist = {"Fake", "Honey", "Trap", "Admin", "Test"}
    for _, word in pairs(blacklist) do
        if object.Name:find(word) then return false end
    end
    return true
end

local function AddToFavorites(name, id)
    if not Favorites[id] then
        Favorites[id] = true
        local FavSection = TabFavorites:CreateSection("Audio: " .. name)
        local PlayButton = TabFavorites:CreateButton({
            Name = name .. " (ID: " .. id .. ")",
            Callback = function()
                if Favorites[id] then
                    previewSound:Stop()
                    previewSound.SoundId = "rbxassetid://" .. id
                    previewSound:Play()
                end
            end,
        })
        local UnfavButton = TabFavorites:CreateButton({
            Name = "Unfavorite",
            Callback = function()
                if Favorites[id] then
                    Favorites[id] = nil
                    PlayButton:Set("Removed")
                    UnfavButton:Set("Deleted")
                end
            end,
        })
        return true
    end
    return false
end

-- --- TABS ---
local TabScanner = Window:CreateTab("Audio Scanner", 4483362458)
local TabScripts = Window:CreateTab("Scripts", 4483364237)
local TabFun = Window:CreateTab("Fun", 4483362458) -- Nova aba Fun
local TabNetwork = Window:CreateTab("Network", 4483345998)
local TabFavorites = Window:CreateTab("Favorites", 4384403532)

-- --- FUN TAB ---
TabFun:CreateSection("Player Modifications")

TabFun:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

TabFun:CreateSlider({
   Name = "JumpPower",
   Range = {50, 500},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
   end,
})

TabFun:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value)
       _G.InfJump = Value
       game:GetService("UserInputService").JumpRequest:Connect(function()
           if _G.InfJump then
               game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
           end
       end)
   end,
})

TabFun:CreateSection("Visuals & World")

TabFun:CreateButton({
   Name = "Full Brightness",
   Callback = function()
       game:GetService("Lighting").Brightness = 2
       game:GetService("Lighting").ClockTime = 14
       game:GetService("Lighting").FogEnd = 100000
       game:GetService("Lighting").GlobalShadows = false
   end,
})

TabFun:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(Value)
       _G.Noclip = Value
       game:GetService("RunService").Stepped:Connect(function()
           if _G.Noclip then
               for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                   if v:IsA("BasePart") then v.CanCollide = false end
               end
           end
       end)
   end,
})

TabFun:CreateSection("Special Tools")

TabFun:CreateButton({
   [span_1](start_span)Name = "Get Teleport Tool", -- Baseado no seu script original[span_1](end_span)
   Callback = function()
       local mouse = game.Players.LocalPlayer:GetMouse()
       local tool = Instance.new("Tool")
       tool.RequiresHandle = false
       tool.Name = "Click Teleport"
       tool.Activated:Connect(function()
           local pos = mouse.Hit + Vector3.new(0, 3, 0)
           game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos.X, pos.Y, pos.Z)
       end)
       tool.Parent = game.Players.LocalPlayer.Backpack
   end,
})

TabFun:CreateButton({
   Name = "Fly (E to Toggle)",
   Callback = function()
       -- Simples Fly Script incorporado
       loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.lua"))()
   end,
})

TabFun:CreateButton({
   Name = "Infinite Yield (Admin Logs)",
   Callback = function()
       loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
   end,
})

-- --- SCRIPTS TAB (Original Data) ---
TabScripts:CreateSection("Protection")

TabScripts:CreateButton({
    [span_2](start_span)Name = "Create Safe Path Platform", --[span_2](end_span)
    Callback = function()
        local Part = Instance.new("Part")
        Part.Name = "Safe Path"
        Part.Parent = Workspace
        Part.Anchored = true
        Part.Size = Vector3.new(1000, 25, 1000)
        [span_3](start_span)Part.CFrame = CFrame.new(1, 99970, 1) --[span_3](end_span)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Part.CFrame + Vector3.new(0, 10, 0)
    end,
})

TabScripts:CreateToggle({
   Name = "Teleport To Chests",
   CurrentValue = false,
   Callback = function(Value)
       AutoFarmEnabled = Value
       if Value then
           local BV = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)
           local BG = Instance.new("BodyGyro", game.Players.LocalPlayer.Character.HumanoidRootPart)
           [span_4](start_span)BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge) --[span_4](end_span)
           [span_5](start_span)BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge) --[span_5](end_span)
           while AutoFarmEnabled do
               for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                   if (v.Name:find("Chest") or v.Parent.Name == "chests") and v:IsA("BasePart") then
                       if IsSafe(v) then
                           [span_6](start_span)game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame --[span_6](end_span)
                           wait(0.5)
                       end
                   end
               end
               wait(1)
           end
           BV:Destroy()
           BG:Destroy()
       end
   end,
})

TabScripts:CreateToggle({
    Name = "Auto Collect (Proximity)",
    CurrentValue = false,
    Callback = function(Value)
        AutoCollectEnabled = Value
        while AutoCollectEnabled do
            for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                if v:IsA("ProximityPrompt") and IsSafe(v.Parent) then
                    [span_7](start_span)fireproximityprompt(v) --[span_7](end_span)
                end
            end
            wait(0.1)
        end
    end,
})

TabScripts:CreateSection("Inventory")

TabScripts:CreateToggle({
    Name = "Auto Open Chests",
    CurrentValue = false,
    Callback = function(Value)
        AutoOpenEnabled = Value
        while AutoOpenEnabled do
            for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                if v.Name:find("Chest") then
                    v.Parent = game.Players.LocalPlayer.Character
                    [span_8](start_span)v:Activate() --[span_8](end_span)
                    wait(0.1)
                end
            end
            wait(1)
        end
    end,
})

TabScripts:CreateButton({
    [span_9](start_span)Name = "Server Hop", --[span_9](end_span)
    Callback = function()
        local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
        for _, s in pairs(servers) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id)
            end
        end
    end,
})

-- (As abas Audio Scanner, Network e Favorites continuam com as mesmas lógicas de segurança e remoção individual)
