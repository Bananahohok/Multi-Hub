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
local TabScripts = Window:CreateTab("Scripts", 4483364237) -- A aba que você pediu
local TabNetwork = Window:CreateTab("Network", 4483345998)
local TabFavorites = Window:CreateTab("Favorites", 4384403532)

-- --- SCRIPTS TAB (Conteúdo do arquivo enviado) ---
TabScripts:CreateSection("Auto Farm & Chests")

TabScripts:CreateToggle({
   Name = "Teleport To Chests",
   CurrentValue = false,
   Callback = function(Value)
       AutoFarmEnabled = Value
       if Value then
           -- Criação do BodyVelocity/Gyro para estabilidade (como no original)
           local BV = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)
           local BG = Instance.new("BodyGyro", game.Players.LocalPlayer.Character.HumanoidRootPart)
           BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
           BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
           BV.Velocity = Vector3.new(0,0,0)

           while AutoFarmEnabled do
               for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                   if (v.Name:find("Chest") or v.Parent.Name == "chests") and v:IsA("BasePart") then
                       if IsSafe(v) then
                           game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
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
    Name = "Auto Collect Chests",
    CurrentValue = false,
    Callback = function(Value)
        AutoCollectEnabled = Value
        while AutoCollectEnabled do
            for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                if v:IsA("ProximityPrompt") and IsSafe(v.Parent) then
                    fireproximityprompt(v)
                end
            end
            wait(0.1)
        end
    end,
})

TabScripts:CreateSection("Inventory Management")

TabScripts:CreateToggle({
    Name = "Auto Open Chests",
    CurrentValue = false,
    Callback = function(Value)
        AutoOpenEnabled = Value
        while AutoOpenEnabled do
            for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                if v.Name:find("Chest") then
                    v.Parent = game.Players.LocalPlayer.Character
                    v:Activate()
                    wait(0.1)
                end
            end
            wait(1)
        end
    end,
})

TabScripts:CreateToggle({
    Name = "Auto Delete Useless Items",
    CurrentValue = false,
    Callback = function(Value)
        AutoDeleteEnabled = Value
        while AutoDeleteEnabled do
            for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                if v.Name == "Oil Cup" or v.Name == "Blood Cup" or v.Name == "Fish" then
                    v:Destroy()
                end
            end
            wait(1)
        end
    end,
})

TabScripts:CreateSection("Utilities")

TabScripts:CreateButton({
    Name = "Teleport To Secret Shop",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1245, -52, 538)
    end,
})

TabScripts:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
        for _, s in pairs(servers) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id)
                break
            end
        end
    end,
})

TabScripts:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end,
})

-- --- AUDIO SCANNER TAB ---
TabScanner:CreateSection("Quick Controls")
TabScanner:CreateButton({
   Name = "STOP ALL PREVIEWS",
   Callback = function() previewSound:Stop() end,
})

TabScanner:CreateButton({
   Name = "Scan Workspace Sounds",
   Callback = function()
       for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
           if v:IsA("Sound") then
               local cleanID = v.SoundId:match("%d+")
               if cleanID then
                   TabScanner:CreateSection("Audio: " .. v.Name)
                   TabScanner:CreateButton({
                       Name = "Play & Copy ID: " .. cleanID,
                       Callback = function()
                           previewSound:Stop()
                           previewSound.SoundId = "rbxassetid://" .. cleanID
                           previewSound:Play()
                           setclipboard(cleanID)
                       end
                   })
                   TabScanner:CreateButton({
                       Name = "Add to Favorites",
                       Callback = function() AddToFavorites(v.Name, cleanID) end
                   })
               end
           end
       end
   end,
})

-- --- NETWORK TAB ---
TabNetwork:CreateSection("Remote Spy")
TabNetwork:CreateButton({
    Name = "Scan Remotes",
    Callback = function()
        for _, v in pairs(game:GetDescendants()) do
            if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and IsSafe(v) then
                TabNetwork:CreateButton({
                    Name = "[" .. v.ClassName .. "] " .. v.Name,
                    Callback = function() setclipboard(v:GetFullName()) end
                })
            end
        end
    end,
})
