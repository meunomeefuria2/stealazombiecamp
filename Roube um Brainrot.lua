local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local noclipEnabled = false
local connection

local Window = Rayfield:CreateWindow({
   Name = "ZOMBIE-CAMP HUB",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "BRR BRR PATAPIM",
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
           -- Ativar noclip
           connection = RunService.Stepped:Connect(function()
               if player.Character and player.Character:FindFirstChild("Humanoid") then
                   local character = player.Character
                   
                   -- Desativar colisão apenas para partes do corpo (não para os pés)
                   for _, part in pairs(character:GetChildren()) do
                       if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                           if part.Name == "LeftFoot" or part.Name == "RightFoot" or 
                              part.Name == "LeftLowerLeg" or part.Name == "RightLowerLeg" then
                               -- Manter colisão nos pés e pernas inferiores para não cair
                               part.CanCollide = true
                           else
                               -- Remover colisão do resto do corpo para atravessar paredes
                               part.CanCollide = false
                           end
                       end
                   end
                   
                   -- Alternativa: usar apenas a HumanoidRootPart
                   if character:FindFirstChild("HumanoidRootPart") then
                       character.HumanoidRootPart.CanCollide = false
                   end
               end
           end)
           
           print("Noclip ativado - você pode atravessar paredes!")
       else
           -- Desativar noclip
           if connection then
               connection:Disconnect()
               connection = nil
           end
           
           if player.Character then
               -- Restaurar colisão normal
               for _, part in pairs(player.Character:GetChildren()) do
                   if part:IsA("BasePart") then
                       part.CanCollide = true
                   end
               end
           end
           
           print("Noclip desativado!")
       end
   end,
})

local WalkSpeedSlider = Tab:CreateSlider({
   Name = "Walk Speed",
   Range = {1, 300},
   Increment = 1,
   Suffix = " Speed",
   CurrentValue = 16,
   Flag = "WalkSpeedSlider",
   Callback = function(Value)
       if player.Character and player.Character:FindFirstChild("Humanoid") then
           player.Character.Humanoid.WalkSpeed = Value
       end
   end,
})

-- Slider para JumpPower
local JumpPowerSlider = Tab:CreateSlider({
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