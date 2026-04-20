local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Audio Hub: Scanner & Player",
   LoadingTitle = "Loading Tools...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = { Enabled = false }
})

-- Global variable for the Preview Sound
local previewSound = Instance.new("Sound")
previewSound.Parent = game.Workspace
previewSound.Name = "Gemini_Preview_Audio"

-- SCANNER TAB
local TabScanner = Window:CreateTab("Scanner", 4483362458) -- Search Icon

TabScanner:CreateSection("Workspace Tools")

TabScanner:CreateButton({
   Name = "Scan Workspace & Copy IDs",
   Callback = function()
       local soundList = "List of Sounds Found:\n\n"
       local count = 0
       
       -- Scans every object in the Workspace
       for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
           if v:IsA("Sound") then
               count = count + 1
               soundList = soundList .. string.format("Name: %s | ID: %s\n", v.Name, v.SoundId)
           end
       end

       if count > 0 then
           -- Copies to clipboard
           setclipboard(soundList)
           Rayfield:Notify({
               Title = "Success!",
               Content = count .. " sounds copied to your clipboard.",
               Duration = 5,
               Image = 4483362458,
           })
       else
           Rayfield:Notify({
               Title = "Scanner",
               Content = "No sounds were found in Workspace.",
               Duration = 5,
           })
       end
   end,
})

-- PLAYER TAB
local TabPlayer = Window:CreateTab("Player", 6023426926) -- Speaker Icon

local InputID = ""

TabPlayer:CreateSection("Audio Controls")

TabPlayer:CreateInput({
   Name = "Sound ID",
   PlaceholderText = "Paste ID or Link here...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
       -- Automatically filters only the numbers (removes 'rbxassetid://', etc.)
       InputID = Text:match("%d+")
   end,
})

TabPlayer:CreateButton({
   Name = "▶️ Play Audio",
   Callback = function()
       if InputID and InputID ~= "" then
           previewSound:Stop()
           previewSound.SoundId = "rbxassetid://" .. InputID
           previewSound:Play()
           
           Rayfield:Notify({
               Title = "Audio Player",
               Content = "Playing ID: " .. InputID,
               Duration = 3,
           })
       else
           Rayfield:Notify({
               Title = "Error",
               Content = "Please enter a valid ID first.",
               Duration = 3,
           })
       end
   end,
})

TabPlayer:CreateButton({
   Name = "🛑 Stop Audio",
   Callback = function()
       previewSound:Stop()
       Rayfield:Notify({
           Title = "Audio Player",
           Content = "Playback stopped.",
           Duration = 2,
       })
   end,
})

TabPlayer:CreateSlider({
   Name = "Volume Control",
   Range = {0, 10},
   Increment = 0.5,
   Suffix = "Vol",
   CurrentValue = 1,
   Callback = function(Value)
       previewSound.Volume = Value
   end,
})

TabPlayer:CreateLabel("The player works with any Roblox Audio ID.")
