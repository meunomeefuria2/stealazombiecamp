-- Carrega OrionLib
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

-- Serviços e variáveis
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Proteção contra Kick e Teleport
local mt = getrawmetatable(game)
setreadonly(mt, false)

local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
	local method = getnamecallmethod()
	if method == "Kick" or method == "kick" then
		warn("[PROTEÇÃO] Tentativa de kick bloqueada.")
		return -- impede kick
	end
	if self == game:GetService("TeleportService") and method == "Teleport" then
		warn("[PROTEÇÃO] Tentativa de teleport bloqueada.")
		return -- impede teleport
	end
	return oldNamecall(self, ...)
end)

-- Valores salvos
local savedWalkSpeed = 5
local savedJumpPower = 50

-- Aplicar WalkSpeed e JumpPower
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

-- Atualiza ao renascer
LocalPlayer.CharacterAdded:Connect(function()
	wait(0.1)
	applyValues()
end)

-- Noclip
local noclipEnabled = false
local noclipConnection = nil

local function setNoclip(state)
	noclipEnabled = state
	if noclipConnection then
		noclipConnection:Disconnect()
	end

	if noclipEnabled then
		noclipConnection = RunService.Heartbeat:Connect(function()
			local char = LocalPlayer.Character
			if char then
				local humanoid = char:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid:ChangeState(Enum.HumanoidStateType.Physics)
				end
				for _, part in pairs(char:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end
		end)
	end
end

-- GUI Orion
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