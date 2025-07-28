-- Carrega OrionLib
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

-- Cria janela principal
local Window = OrionLib:MakeWindow({
	Name = "ZOMBIE CAMP",
	HidePremium = false,
	SaveConfig = true,
	ConfigFolder = "ZombieCampFolder"
})

-- Cria aba principal
local maintab = Window:MakeTab({
	Name = "Principal",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- Serviços e variáveis
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Aguarda personagem e humanoid
local function getCharacter()
	local char = LocalPlayer.Character
	if not char or not char.Parent then
		char = LocalPlayer.CharacterAdded:Wait()
	end
	return char
end

local Character = getCharacter()
local Humanoid = Character:WaitForChild("Humanoid")
local noclipConnection

-- Estado do noclip
local noclipEnabled = false

-- Função para ativar/desativar noclip
local function toggleNoclip(state)
	if state then
		noclipConnection = RunService.Stepped:Connect(function()
			local char = getCharacter()
			if not char then return end

			for _, part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
					-- Só desativa colisão para partes acima do chão (para não cair)
					if part.Position.Y >= char.HumanoidRootPart.Position.Y - 3 then
						part.CanCollide = false
					end
				end
			end
		end)
	else
		if noclipConnection then
			noclipConnection:Disconnect()
			noclipConnection = nil
		end

		local char = getCharacter()
		if char then
			for _, part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = true
				end
			end
		end
	end
end

-- Anti Kick / Teleport básico
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
	local method = getnamecallmethod()
	if method == "Kick" and self == LocalPlayer then
		warn("[ZOMBIE CAMP] Tentativa de Kick bloqueada")
		return
	end
	if method == "TeleportToPlaceInstance" or method == "Teleport" then
		warn("[ZOMBIE CAMP] Tentativa de Teleport bloqueada")
		return
	end
	return oldNamecall(self, ...)
end)

setreadonly(mt, true)

-- Toggle do noclip
maintab:AddToggle({
	Name = "ZOMBIE CLIP",
	Default = false,
	Callback = function(Value)
		noclipEnabled = Value
		toggleNoclip(Value)
		OrionLib:MakeNotification({
			Name = "ZOMBIE CLIP",
			Content = Value and "Ativado!" or "Desativado!",
			Image = "rbxassetid://4483345998",
			Time = 3
		})
	end    
})

-- Slider de WalkSpeed
maintab:AddSlider({
	Name = "WALK-SPEED",
	Min = 0,
	Max = 20,
	Default = 16,
	Color = Color3.fromRGB(255, 255, 255),
	Increment = 1,
	ValueName = "studs/s",
	Callback = function(Value)
		local char = getCharacter()
		if char and char:FindFirstChildOfClass("Humanoid") then
			char:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
		end
	end    
})

-- Slider de JumpPower
maintab:AddSlider({
	Name = "JUMP-POWER",
	Min = 0,
	Max = 150,
	Default = 50,
	Color = Color3.fromRGB(255, 255, 255),
	Increment = 1,
	ValueName = "power",
	Callback = function(Value)
		local char = getCharacter()
		if char and char:FindFirstChildOfClass("Humanoid") then
			char:FindFirstChildOfClass("Humanoid").JumpPower = Value
		end
	end    
})

-- Inicializa o Orion UI
OrionLib:Init()
