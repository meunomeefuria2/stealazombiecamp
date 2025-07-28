local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local noclipEnabled = false
local connection
local lastUpdate = 0

local Window = Rayfield:CreateWindow({
   Name = "ZOMBIE-CAMP HUB",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "MIA KHALIFA COM PINTO",
   LoadingSubtitle = "by Kaby/BlueFurry",
   ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Amethyst", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

Rayfield:Notify({
   Title = "Obrigado Por Executar Nosso Script",
   Content = "Aproveite as funções do nosso script",
   Duration = 6.5,
   Image = 4483362458,
})

local MainTab = Window:CreateTab("PRINCIPAL", 4483362458) -- Title, Image
local EXPTab = Window:CreateTab("RECURSOS EXPERIMENTAIS", 4483362458) -- Title, Image

local NoclipButton = MainTab:CreateButton({
   Name = "ZOMBIE-CLIP",
   Callback = function()
   noclipEnabled = not noclipEnabled
       
       if noclipEnabled then
           connection = RunService.Heartbeat:Connect(function()
               local currentTime = tick()
               
               -- Atualizar apenas a cada 0.1 segundos para reduzir lag
               if currentTime - lastUpdate > 0.1 then
                   lastUpdate = currentTime
                   
                   if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                       for _, part in pairs(player.Character:GetChildren()) do
                           if part:IsA("BasePart") then
                               part.CanCollide = false
                           end
                       end
                       
                       -- Manter o HumanoidRootPart sempre sem colisão
                       player.Character.HumanoidRootPart.CanCollide = false
                   end
               end
           end)
           print("Noclip ON")
       else
           if connection then
               connection:Disconnect()
               connection = nil
           end
           
           -- Restaurar colisão
           if player.Character then
               for _, part in pairs(player.Character:GetChildren()) do
                   if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                       part.CanCollide = true
                   end
               end
               -- HumanoidRootPart sempre sem colisão por padrão
               if player.Character:FindFirstChild("HumanoidRootPart") then
                   player.Character.HumanoidRootPart.CanCollide = false
               end
           end
           print("Noclip OFF")
       end
   end,
})

-- Slider para JumpPower
local JumpPowerSlider = MainTab:CreateSlider({
   Name = "Jump Power",
   Range = {10, 200},
   Increment = 5,
   Suffix = " Power",
   CurrentValue = 50,
   Flag = "JumpPowerSlider",
   Callback = function(Value)
       if player.Character and player.Character:FindFirstChild("Humanoid") then
           player.Character.Humanoid.JumpPower = Value
       end
   end,
})