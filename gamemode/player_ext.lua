/*
	All Warrior data and funcitons are handeled serverside
*/
local plymeta = FindMetaTable( "Player" )
if not plymeta then Error("FAILED TO FIND PLAYER TABLE") return end

function plymeta:HasWarrior()
	if self:GetWarrior() then return true end
	return false
end

function plymeta:GetWarrior()
	return self.war
end

function plymeta:GetWarriorName()
	return self:GetWarrior().Name
end

function plymeta:GetWarriorModel()
	return self:GetWarrior().Model
end

function plymeta:GetWarriorHealthGain()
	return self:GetWarrior().HealthGain
end

function plymeta:GetWarriorHealth()
	return self:GetWarrior().Health
end

function plymeta:GetWarriorSpeed()
	return self:GetWarrior().Speed
end

function plymeta:GetWarriorJumpPower()
	return self:GetWarrior().JumpPower
end

function plymeta:GetWarriorArmor()
	return self:GetWarrior().Armor
end

function plymeta:GetStatusTable()
	return self:GetWarrior().Status
end

function plymeta:HasStatus( name )
	if timer.Exists( self:Nick()..name ) then
		return true
	else
		return false
	end
end

function plymeta:SetWarrior( name )
	local warrior = WL:GetWarrior( name )
	local war = {}

	--All character specific values will be stored here
	war.Name = warrior.Name
	war.Model = warrior.Model
	war.HealthGain = warrior.HealthGain
	war.Health = warrior.Health
	war.Speed = warrior.Speed
	war.JumpPower = warrior.JumpPower
	war.Armor = warrior.Armor
	war.Weapons = warrior.Weapons
	war.Status = {}

	self.war = war
end

function plymeta:GetWarriorMaxHealth()
	return (team.GetLevel(self:Team())-1) * self:GetWarriorHealthGain() + self:GetWarriorHealth() --math for healthgain per lvl
end

function plymeta:SetUpLoadout()
	--give weapons
	--TODO maybe only give weapons when level requirement is hit (setting would be possible too)
	for _,wep in pairs(self:GetWarrior().Weapons) do
		self:Give(wep)
	end
end

function plymeta:SetUpStats()
	--movement
	local speed = self:GetWarriorSpeed()
	self:SetRunSpeed(speed)
	self:SetWalkSpeed(speed)

	self:SetJumpPower( self:GetWarriorJumpPower() )

	--health
	local health = self:GetWarriorMaxHealth()
	self:SetMaxHealth( health )
	self:SetHealth( health )
	self:SetArmor( self:GetWarriorArmor() )
end

function plymeta:LevelUpPlayer()
	--levelup while alive
	local healthgain = self:GetWarriorHealthGain()
	self:SetMaxHealth( self:GetWarriorMaxHealth() + healthgain)
	self:SetHealth( self:Health() + healthgain)
end

function plymeta:StartWarriorTimer( name, duration )
	self:SetNWInt(name,duration) -- Sent cooldown to client  HUD
	timer.Create( name, 1, duration, function() self:SetNWInt(name, self:GetNWInt(name,0)-1) end) -- reduce cooldown till 0
end

function plymeta:SetStatus( duration, name, funcstart, funcend )

	self:GetStatusTable()[name] = funcend

	funcstart()

	timer.Create( self:Nick()..name, duration, 1, function() self:RemoveStatus( name ) end  )

end

function plymeta:RemoveStatus( name )

	local funcend = self:GetStatusTable()[name]

	funcend()

	if timer.Exists( self:Nick()..name ) then
		timer.Destroy( self:Nick()..name )
	end

end

function plymeta:ClearStatus()
	for name ,_ in pairs(self:GetStatusTable()) do
		self:RemoveStatus( name )
	end
end