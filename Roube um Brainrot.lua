-- Carrega OrionLib
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

-- Cria a janela
local Window = OrionLib:MakeWindow({
	Name = "ZOMBIE CAMP", 
	HidePremium = false, 
	SaveConfig = true, 
	ConfigFolder = "ZombieCampConfig"
})

-- Cria aba principal
local maintab = Window:MakeTab({
	Name = "MAIN",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local secoundtab = Window:MakeTab({
	Name = "EXPERIMENTAL RESOURCES",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- Variáveis
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local NoclipEnabled = false
local RunService = game:GetService("RunService")

-- Função de noclip (mantém colisão com o chão)
local function ToggleNoclip()
	NoclipEnabled = not NoclipEnabled
	if NoclipEnabled then
		RunService.Stepped:Connect(function()
			if NoclipEnabled and Character and Character:FindFirstChild("HumanoidRootPart") then
				for _, part in pairs(Character:GetDescendants()) do
					if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Name ~= "LowerTorso" and part.Name ~= "RightFoot" and part.Name ~= "LeftFoot" then
						part.CanCollide = false
					end
				end
			end
		end)
	else
		for _, part in pairs(Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end
end

-- Botão Noclip
maintab:AddButton({
	Name = "ZOMBIE CLIP",
	Callback = function()
		ToggleNoclip()
	end
})

-- Slider de velocidade
maintab:AddSlider({
	Name = "WALK-SPEED",
	Min = 0,
	Max = 20,
	Default = 5,
	Color = Color3.fromRGB(255, 255, 255),
	Increment = 1,
	ValueName = "Studs",
	Callback = function(Value)
		Humanoid.WalkSpeed = Value
	end    
})

-- Slider de pulo
maintab:AddSlider({
	Name = "JUMP-POWER",
	Min = 0,
	Max = 150,
	Default = 50,
	Color = Color3.fromRGB(255, 255, 255),
	Increment = 1,
	ValueName = "Power",
	Callback = function(Value)
		Humanoid.JumpPower = Value
	end    
})

-- Anti-Kick básico (não impede todos os métodos)
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
	local method = getnamecallmethod()
	local args = {...}
	
	-- Bloqueia tentativa de kick
	if method == "Kick" and self == LocalPlayer then
		warn("Tentativa de Kick bloqueada!")
		return
	end
	
	-- Bloqueia teleport para outro jogo
	if method == "TeleportToPlaceInstance" then
		warn("Tentativa de teleport bloqueada!")
		return
	end

	return oldNamecall(self, unpack(args))
end)

OrionLib:Init()