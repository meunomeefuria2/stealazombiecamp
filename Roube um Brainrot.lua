-- Carrega OrionLib
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

-- Cria a Janela
local Window = OrionLib:MakeWindow({Name = "HUB DO CURSEDX", HidePremium = false, SaveConfig = false, IntroText = "Player096ofc"})

-- Cria a aba principal
local maintab = Window:MakeTab({
	Name = "Principal",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- Variáveis globais
local noclipEnabled = false
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Função Noclip (somente paredes)
game:GetService("RunService").Stepped:Connect(function()
	if noclipEnabled then
		local touchingParts = humanoidRootPart:GetTouchingParts()
		for _, part in ipairs(touchingParts) do
			if part:IsA("BasePart") and not part.CanCollide then
				continue
			end
			if math.abs(humanoidRootPart.Position.Y - part.Position.Y) > 3 then
				continue -- ignora chão e teto
			end
			-- Colide com o chão, não com paredes
			humanoidRootPart.CanCollide = false
			return
		end
	end
	humanoidRootPart.CanCollide = true
end)

-- Botão de Noclip
maintab:AddButton({
	Name = "ZOMBIE CLIP",
	Callback = function()
		noclipEnabled = not noclipEnabled
		OrionLib:MakeNotification({
			Name = "Noclip",
			Content = noclipEnabled and "Ativado" or "Desativado",
			Time = 2
		})
	end
})

-- Slider de WalkSpeed
maintab:AddSlider({
	Name = "WALK-SPEED",
	Min = 0,
	Max = 50,
	Default = 16,
	Color = Color3.fromRGB(255, 255, 255),
	Increment = 1,
	ValueName = "speed",
	Callback = function(Value)
		local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = Value
		end
	end
})

-- Slider de JumpPower
maintab:AddSlider({
	Name = "JUMP-POWER",
	Min = 0,
	Max = 200,
	Default = 50,
	Color = Color3.fromRGB(255, 255, 255),
	Increment = 5,
	ValueName = "pulo",
	Callback = function(Value)
		local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.JumpPower = Value
		end
	end
})

-- Anti Kick e Anti Teleport de servidor
local oldKick = player.Kick
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
	local args = {...}
	local method = getnamecallmethod()
	if tostring(self) == "Kick" or method == "Kick" then
		warn("[!] Tentativa de Kick bloqueada.")
		return
	end
	if method == "TeleportToPlaceInstance" or method == "Teleport" then
		warn("[!] Tentativa de troca de experiência bloqueada.")
		return
	end
	return oldNamecall(self, unpack(args))
end)

setreadonly(mt, true)

OrionLib:Init()