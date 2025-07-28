local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local noclipEnabled = false
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Função para ativar/desativar o noclip
local function setNoclip(state)
	noclipEnabled = state
	if noclipEnabled then
		-- Loop para aplicar noclip enquanto estiver ativo
		RunService.Stepped:Connect(function()
			if noclipEnabled and LocalPlayer.Character then
				for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
					if part:IsA("BasePart") and part.CanCollide == true then
						part.CanCollide = false
					end
				end
			end
		end)
	end
end

local Window = OrionLib:MakeWindow({Name = "Zombies Camp", HidePremium = false, SaveConfig = true, ConfigFolder = "ZombiesConfig"})

local maintab = Window:MakeTab({
	Name = "Roube Bases",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

OrionLib:MakeNotification({
	Name = "OBRIGADO POR EXECUTAR NOSSO ZOMBIECAMP SCRIPT",
	Content = "APROVEITE AS FUNÇÕES DO NOSSO SCRIPT!",
	Image = "rbxassetid://4483345998",
	Time = 7
})

local Section = maintab:AddSection({
	Name = "DOM LORENZO"
})


maintab:AddButton({
	Name = "ZOMBIE CLIP",
	Callback = function()
        noclipEnabled = not noclipEnabled
		setNoclip(noclipEnabled)
  	end    
})

maintab:AddSlider({
	Name = "WALK-SPEED",
	Min = 0,
	Max = 20,
	Default = 5,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	Callback = function
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
		LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
	end    
})

maintab:AddSlider({
	Name = "JUMP-POWER",
	Min = 0,
	Max = 20,
	Default = 5,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	Callback = function
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
		LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = value
	end    
})

OrionLib:Init()