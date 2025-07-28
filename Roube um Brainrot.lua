local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- NOCLIP
local noclipEnabled = false

local function setNoclip(state)
	noclipEnabled = state
	if noclipEnabled then
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

-- Salva os valores escolhidos
local savedWalkSpeed = 5
local savedJumpPower = 50

-- Função que aplica os valores salvos ao Humanoid
local function applyValues()
	local char = LocalPlayer.Character
	if char then
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = savedWalkSpeed
			humanoid.JumpPower = savedJumpPower
		end
	end
end

-- Detecta quando o personagem reaparecer e aplica os valores
LocalPlayer.CharacterAdded:Connect(function()
	wait(0.1) -- Dá um tempo pro personagem carregar
	applyValues()
end)

-- GUI
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

maintab:AddSection({
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
	ValueName = "speed",
	Callback = function(Value)
		savedWalkSpeed = Value
		applyValues()
	end    
})

maintab:AddSlider({
	Name = "JUMP-POWER",
	Min = 0,
	Max = 200,
	Default = 50,
	Color = Color3.fromRGB(255,255,255),
	Increment = 5,
	ValueName = "power",
	Callback = function(Value)
		savedJumpPower = Value
		applyValues()
	end    
})

OrionLib:Init()