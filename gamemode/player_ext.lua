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
	return (team.GetLevel(self:Team())-1) * self:GetWarriorHealthGain() + self:GetWarriorHealth() --"math" for healthgain per lvl
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

function plymeta:StartWarriorCooldown( name, duration )
	self:SetNWInt(name,duration) -- Sent cooldown to client  HUD
	timer.Create( name, 1, duration, function() self:SetNWInt(name, self:GetNWInt(name,0)-1) end) -- reduce cooldown till 0
end

--Status Table for setting Status effects on players

--TODO table structure for args like bullet or effecdata

function plymeta:GetStatusTable()
	return self:GetWarrior().Status
end

function plymeta:GetStatus( name )
	return self:GetStatusTable()[name]
end

function plymeta:GetStatusFuncend( name )
	return self:GetStatus( name ).FuncEnd
end

function plymeta:GetStatusScreenEffect( name )
	return self:GetStatus( name ).ScreenEffect
end

function plymeta:SetStatusScreenEffect( effectname )

	net.Start( "FW_SetScreenEffect" )
			net.WriteString( effectname )
	net.Send( self )

end

function plymeta:RemoveStatusScreenEffect( effectname )

	net.Start( "FW_RemoveScreenEffect" )
			net.WriteString( effectname )
	net.Send( self )

end

function plymeta:HasStatus( name )
	if self:GetStatus( name ) then
		return true
	else
		return false
	end
end

function plymeta:CreateStatusTimerName( name )
	return self:Nick().."."..name
end
/*
	-- Sets a Status --

	Status Table Structure:

	local status = {}
	status.Name = String required
	status.DisplayName = String optional
	status.Duration = optional, but required with functick or funcend pass 0 for infinite duration
	status.FuncStart = Function optional
	status.FuncTick = Function optional
	status.FuncEnd = Function optional
	status.ScreenEffect = String optional
	status.Icon = String(path) optional if not set default icon will be used 
	status.DeBuff = Boolean optional default: false
	
*/
function plymeta:SetStatus( status )

	if status.FuncStart then status.FuncStart() end

	local funcend = status.FuncEnd
	local functick = status.FuncTick
	local screeneffect = status.ScreenEffect

	local newstatus = {} -- save only required stuff for later usage
	newstatus.DisplayName = status.DisplayName or status.Name
	if funcend then newstatus.FuncEnd = funcend end
	if screeneffect then newstatus.ScreenEffect = screeneffect end
	newstatus.Icon = status.Icon or "path/to/default"
	newstatus.DeBuff = status.Debuff or false

	self:GetStatusTable()[status.Name] = newstatus

	tname = self:CreateStatusTimerName( status.Name )

	if functick and status.Duration then functick() timer.Create( tname..".Tick", 1, status.Duration, functick ) end

	if status.ScreenEffect then self:SetStatusScreenEffect( status.ScreenEffect ) end
	
	-- TODO self:SetStatusIcon( status.Icon, status.DeBuff )

	if funcend and status.Duration then timer.Create( tname..".End", status.Duration, 1, function() self:RemoveStatus( status.Name ) end  ) end

end

--Removes named Status
function plymeta:RemoveStatus( name )

	local funcend = self:GetStatusFuncend( name )

	tname = self:CreateStatusTimerName( name )

	if self:GetStatusScreenEffect( name ) then self:RemoveStatusScreenEffect( self:GetStatusScreenEffect( name ) ) end

	if funcend then funcend() end

	self:GetStatusTable()[name] = nil

	if timer.Exists( tname..".Tick" ) then
		timer.Destroy( tname..".Tick" )
	end
	if timer.Exists( tname..".End" ) then
		timer.Destroy( tname..".End" )
	end

end

--Clears every status called on GM:PlayerDeath
function plymeta:ClearStatus()
	for name ,_ in pairs(self:GetStatusTable()) do
		self:RemoveStatus( name )
	end
end

