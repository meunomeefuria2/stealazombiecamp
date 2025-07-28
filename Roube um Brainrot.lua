-- Carrega OrionLib
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main')))()

-- Cria a janela principal
local Window = OrionLib:MakeWindow({Name = "ZOMBIE CAMP", HidePremium = false, SaveConfig = true, ConfigFolder = "ZombieCampFolder"})

-- Cria a aba principal
local maintab = Window:MakeTab({
	Name = "Principal",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local secoundtab = Window:MakeTab({
	Name = "RECURSOS EXPERIMENTAIS",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- Variáveis
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local noclipEnabled = false
local noclipConnection

-- Proteção contra kick/desconectar
local mt = getrawmetatable(game)
local backup; backup = hookfunction(mt.__namecall, newcclosure(function(self, ...)
	local args = {...}
	local method = getnamecallmethod()

	if self == LocalPlayer and (method == "Kick" or method == "kick") then
		return warn("Tentativa de kick bloqueada")
	end

	if self:IsA("RemoteEvent") and (self.Name:lower():find("kick") or self.Name:lower():find("load")) then
		return warn("RemoteEvent suspeito bloqueado")
	end

	return backup(self, ...)
end))

-- Função para ativar/desativar noclip
local function toggleNoclip(state)
	if state then
		noclipConnection = game:GetService("RunService").Stepped:Connect(function()
			for _, v in pairs(Character:GetDescendants()) do
				if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" and v.Position.Y > HumanoidRootPart.Position.Y - 3 then
					v.CanCollide = false
				end
			end
		end)
	else
		if noclipConnection then
			noclipConnection:Disconnect()
		end
		for _, v in pairs(Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = true
			end
		end
	end
end

-- Toggle do noclip
maintab:AddToggle({
	Name = "ZOMBIE CLIP",
	Default = false,
	Callback = function(Value)
		noclipEnabled = Value
		toggleNoclip(Value)
	end    
})

-- Slider de WalkSpeed
maintab:AddSlider({
	Name = "WALK-SPEED",
	Min = 0,
	Max = 20,
	Default = 5,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "velocidade",
	Callback = function(Value)
		Humanoid.WalkSpeed = Value
	end    
})

-- Slider de JumpPower
maintab:AddSlider({
	Name = "JUMP-POWER",
	Min = 0,
	Max = 150,
	Default = 50,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "força",
	Callback = function(Value)
		Humanoid.JumpPower = Value
	end    
})

OrionLib:Init()