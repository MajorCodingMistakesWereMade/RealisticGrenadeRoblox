local replicated = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")
local players = game:GetService("Players")

local function getHumanoid(part:Part)
	local humanoid = part.Parent:FindFirstChild("Humanoid")
	if humanoid then
		return humanoid
	else
		return false
	end
end

local list = {
	Vector3.new(100, 0, 100),	
	Vector3.new(100, 0, -100),
	Vector3.new(-100, 0, -100),	
	Vector3.new(100, 0, -100),	
	Vector3.new(100, 20, 0),
	Vector3.new(-100, 20, 0),
	Vector3.new(-100, -20, 0),
	Vector3.new(100, -20, 0),
	Vector3.new(0, 20, 100),	
	Vector3.new(0, 20, -100),
	Vector3.new(0, -20, 100),	
	Vector3.new(0, -20, -100),	
	Vector3.new(0, 0, -100),	
	Vector3.new(0, 0, 100),	
	Vector3.new(-100, 0, 0),	
	Vector3.new(100, 0, 0)
	

	

}


local function raycastResultThing(position:Vector3, endPos:Vector3)
	local raycastParams1 = RaycastParams.new()

	raycastParams1.FilterDescendantsInstances = {script.Parent}

	raycastParams1.FilterType = Enum.RaycastFilterType.Exclude

	raycastParams1.IgnoreWater = true
	local distance = position - endPos
	local raycastResult = workspace:Raycast(position, distance, raycastParams1)
	
	if raycastResult then
		if raycastResult.Instance:FindFirstAncestorOfClass("Model") then -- getting the first ancestor that is a Model
			local char = raycastResult.Instance:FindFirstAncestorOfClass("Model")
			if char:FindFirstChildOfClass("Humanoid") then -- checking if a Humanoid exists in said ancestor
				local humanoid = char:FindFirstChildOfClass("Humanoid")
				return raycastResult, humanoid
			end
		end
		return raycastResult, nil		
	end
	return nil, nil
end

local function blowup()
	local destroyTable = {}
	script.Parent.explosion:Play()
	for _, x in pairs(list) do

		
		local postion = script.Parent.Position
		local endPos = script.Parent.Position + x
		
		local result, humanoid = raycastResultThing(postion, endPos)
		
		local attatchment1 = Instance.new("Attachment")
		attatchment1.Parent = script.Parent
		local attatchment2 = Instance.new("Attachment")
		attatchment2.Parent = script.Parent
		local beam = Instance.new("Beam")
		beam.Parent = script.Parent
		
		beam.Attachment0 = attatchment1
		beam.Attachment1 = attatchment2
		
		beam.Enabled = true
		beam.Width0 = 0.5
		beam.Width1 = 1.5
		
		attatchment2.Position = x
		
		if humanoid then
			print("I hit a player!")
			humanoid:TakeDamage(20)
		end
		
		table.insert(destroyTable, attatchment1)
		table.insert(destroyTable, attatchment2)
		table.insert(destroyTable, beam)

	end
	
	local explosion = replicated.Explosion:Clone()
	
	local Cuncussion1 = explosion.Cuncussion
	local ImpactDamage1 = explosion.ImpactHarm
	local ImpactKill1 = explosion.ImpactKill
	
	Cuncussion1.Position = script.Parent.Position
	ImpactDamage1.Position = script.Parent.Position
	ImpactKill1.Position = script.Parent.Position

	
	Cuncussion1.Touched:Connect(function(otherPart)
		local humanoid = getHumanoid(otherPart)

		if humanoid then
			humanoid.WalkSpeed = 10
			local player = players:GetPlayerFromCharacter(humanoid.Parent)
			if player then
				replicated.Boom:FireClient(player)
			end
			wait(3)
			humanoid.WalkSpeed = 16
		end

	end)
	ImpactDamage1.Touched:Connect(function(otherPart)
		local humanoid:Humanoid = getHumanoid(otherPart)

		if humanoid then
			humanoid:TakeDamage(3)
			humanoid.WalkSpeed = 8
			local player = players:GetPlayerFromCharacter(humanoid.Parent)
			if player then
				replicated.Boom:FireClient(player)
				
			end
			wait(20)
			humanoid.WalkSpeed = 16
		end

	end)
	ImpactKill1.Touched:Connect(function(otherPart)
		local humanoid:Humanoid = getHumanoid(otherPart)
		if humanoid then
			humanoid:TakeDamage(150)
			local player = players:GetPlayerFromCharacter(humanoid.Parent)
			if player then
				replicated.Boom2:FireClient(player)
			end
		end
	end)
	
	local CuncussionSize = Cuncussion1.Size
	local ImpactDamageSize = ImpactDamage1.Size
	local ImpactKillSize = ImpactKill1.Size
	
	Cuncussion1.Size = Vector3.new(1, 1, 1)
	ImpactDamage1.Size = Vector3.new(1, 1, 1)
	ImpactKill1.Size = Vector3.new(1,1, 1)
	
	
	
	local bigList = {
		ImpactKill = {
			Size = ImpactKillSize
		},
		ImpactHarm = {
			Size = ImpactDamageSize
		},
		Cuncussion = {
			Size = CuncussionSize
		}
	}
	
	local tween1 = tweenService:Create(Cuncussion1, TweenInfo.new(.3), bigList.Cuncussion)
	local tween2 = tweenService:Create(ImpactDamage1, TweenInfo.new(.3), bigList.ImpactHarm)
	local tween3 = tweenService:Create(ImpactKill1, TweenInfo.new(.3), bigList.ImpactKill)

	explosion.Parent = script.Parent
	tween1:Play()
	tween2:Play()
	tween3:Play()

	
	tween1.Completed:Wait()
	
	explosion:Destroy()

	
	wait(2)
	
	for _, x in pairs(destroyTable) do
		x:Destroy()
		wait(.001)
	end
	
end

replicated.Boom2.OnServerEvent:Connect(blowup)

wait(10)
print(5)
wait(1)
print(4)
wait(1)
print(3)
wait(1)
print(2)
wait(1)
print(1)
wait(1)
print("Meow")
blowup()


