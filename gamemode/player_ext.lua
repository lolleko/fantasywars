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
	return self.Warrior
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
	local warrior = FW:GetWarrior( name )
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
	war.Cooldowns = {}

	self.Warrior = war

	self:SetupHands()
end

function plymeta:RemoveWarrior()
	self:ClearStatus()
	self:ResetCooldowns()
	self.Warrior = nil
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
	self:SetWarriorSpeed(self:GetWarriorSpeed())

	self:SetJumpPower( self:GetWarriorJumpPower() )

	--health
	local health = self:GetWarriorHealth()
	self:SetMaxHealth( health )
	self:SetHealth( health )
	self:SetArmor( self:GetWarriorArmor() )
end


function plymeta:SetWarriorSpeed( speed )
	self:SetRunSpeed(speed)
	self:SetWalkSpeed(speed)
end
/*function plymeta:LevelUpPlayer()
	--levelup while alive
	local healthgain = self:GetWarriorHealthGain()
	self:SetMaxHealth( self:GetWarriorMaxHealth() + healthgain)
	self:SetHealth( self:Health() + healthgain)
end
*/

function plymeta:StartWarriorCooldown( name, duration )
	self:GetWarrior().Cooldowns[name] = duration
	self:SetNWInt(name,duration) -- Sent cooldown to client  HUD
	timer.Create( self:SteamID()..name, 1, duration, function() self:CooldownThink( name ) end) -- reduce cooldown till 0
end

function plymeta:CooldownThink( name )
	self:GetWarrior().Cooldowns[name] = self:GetWarrior().Cooldowns[name] - 1
	self:SetNWInt( name, self:GetWarrior().Cooldowns[name])
	if self:GetWarrior().Cooldowns[name] == 0 then if timer.Exists(self:SteamID()..name) then timer.Destroy(self:SteamID()..name) end end
end

function plymeta:ResetCooldown( cdname )
	if timer.Exists(self:SteamID()..cdname) then timer.Destroy(self:SteamID()..cdname) end
	self:SetNWInt(cdname, 0)
	self:GetWarrior().Cooldowns[cdname] = 0
end

function plymeta:ResetCooldowns()
	if !self:HasWarrior() or  !self:GetWarrior().Cooldowns then return end
	for cdname,_ in pairs(self:GetWarrior().Cooldowns) do
		self:ResetCooldown( cdname )
	end
end

function plymeta:IsOnCooldown( cdname )
	if self:GetWarrior().Cooldowns[name] == 0 or self:GetWarrior().Cooldowns[name] == nil then
		return false
	else
		return true
	end
end
--Status Table for setting Status effects on players

function plymeta:GetStatusTable()
	if !self:HasWarrior() then return nil end
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

function plymeta:HasStatus( name )
	if self:GetStatus( name ) then
		return true
	else
		return false
	end
end

function plymeta:CreateStatusTimerName( name )
	return self:SteamID().."."..name
end
/*
	-- Sets a Status --

	Status Table Structure:

	local status = {}
	status.Name = String required
	status.Inflictor = Playeroptional default: self
	status.DisplayName = String optional
	status.Description = String optional
	status.Duration = Integer optional, but required with functick or funcend pass 0 for infinite duration
	status.TickDuration = Integer the length of a tick optional default: 1
	status.FuncStart = Function optional
	status.FuncTick = Function optional
	status.FuncEnd = Function optional
	status.ScreenEffect = String optional
	status.Icon = String(path) optional if not set default icon will be used 
	status.DeBuff = Boolean optional default: false
	status.Show = Boolean optional default: true
	status.Log = Boolean optional default: true
	
*/
function plymeta:SetStatus( status )
	if status.FuncStart then status.FuncStart() end

	local funcend = status.FuncEnd
	local functick = status.FuncTick
	local tickDuration = status.TickDuration or 1
	local newstatus = {} -- save only required stuff for later usage
	if status.Inflictor then newstatus.Inflictor = status.Inflictor:Nick() else newstatus.Inflictor = self:Nick() end
	newstatus.DisplayName = status.DisplayName or status.Name
	if status.Description then newstatus.Description = status.Description end
	if status.ScreenEffect then newstatus.ScreenEffect = status.ScreenEffect end
	newstatus.Icon = status.Icon or "path/to/default"
	newstatus.DeBuff = status.Debuff or false
	if status.Show then newstatus.Show = status.Show else newstatus.Show = true end
	if status.Log then newstatus.Log = status.Log else newstatus.Log = true end
	net.Start( "FW_SetStatus" ) --Send info to client before adding functions
		net.WriteString( status.Name )
		net.WriteTable( newstatus )
	net.Send( self )
	if status.Inflictor then newstatus.Inflictor = status.Inflictor else newstatus.Inflictor = self end
	if funcend then newstatus.FuncEnd = funcend end --save end function to be able to call it in RemoveStatus

	self:GetStatusTable()[status.Name] = newstatus
	tname = self:CreateStatusTimerName( status.Name )

	if timer.Exists( tname..".Tick" ) then -- if timer already exists adjust it
		timer.Adjust( tname..".Tick", 1, status.Duration, functick  )
	else
		if functick and status.Duration then functick() timer.Create( tname..".Tick", tickDuration, status.Duration/tickDuration, functick ) end
	end
	
	if timer.Exists( tname..".End" ) then -- if timer already exists adjust it
		timer.Adjust( tname..".End", status.Duration, 1, function() self:RemoveStatus( status.Name ) end  )
	else
		if funcend and status.Duration or status.Duration and status.Duration != 0 then timer.Create( tname..".End", status.Duration, 1, function() self:RemoveStatus( status.Name ) end  ) end
	end
end

--Removes named Status
function plymeta:RemoveStatus( name )

	local funcend

	if self:GetStatusFuncend( name ) then  funcend = self:GetStatusFuncend( name ) end

	tname = self:CreateStatusTimerName( name )

	if timer.Exists( tname..".Tick" ) then
		timer.Destroy( tname..".Tick" )
	end
	if timer.Exists( tname..".End" ) then
		timer.Destroy( tname..".End" )
	end

	if funcend then funcend() end

	net.Start( "FW_RemoveStatus" )
		net.WriteString( name )
	net.Send( self )

	self:GetStatusTable()[name] = nil

end

--Clears every status called on GM:PlayerDeath
function plymeta:ClearStatus()
	if !self:GetStatusTable() then return end
	for name ,_ in pairs(self:GetStatusTable()) do
		self:RemoveStatus( name )
	end
end