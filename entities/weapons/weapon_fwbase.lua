/*
	weapon base for FW stuff (weps/skills)
	DO NOT MODIFY unless you know what you are doing
*/
AddCSLuaFile()

SWEP.Base = "weapon_base"

SWEP.Spawnable          = false
SWEP.ShowWorldModel 	= true
SWEP.ShowViewModel 		= true

SWEP.HoldType 			= "pistol"
SWEP.AutoSwitchTo       = false
SWEP.AutoSwitchFrom     = false
SWEP.Tracer				= 2
SWEP.UseHands			= true
SWEP.Slot 				= 0

SWEP.Primary.Damage 		= 10
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"
SWEP.Primary.NumShots       = 1
SWEP.Primary.Level 			= 1

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.Level 		= 1

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK
SWEP.ReloadAnim = ACT_VM_RELOAD

SWEP.DeploySpeed = 2 -- high deploy speed since you need to switch for additional abilities

SWEP.ViewModel		= "models/weapons/c_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_357.mdl"

function SWEP:Initialize()
	self:SetDeploySpeed( self.DeploySpeed )	-- set deployspeed for every wepaon (very fast by default)
    self:SetWeaponHoldType( self.HoldType ) -- Allow custom weapon hold type since it's just "pistol" in weapon_base
end

function SWEP:DrawWorldModel()
	if self.ShowWorldModel then
		self:DrawModel()
	end
end

function SWEP:PostDrawViewModel( vm, ply, weapon )
	self.Owner:DrawViewModel( self.ShowViewModel )
end

function SWEP:CanPrimaryAbility()
	--if not self:IsLevelAchieved( self.Primary.Level ) then return false end
	return not self:IsOnCooldown( self.Primary.Slot )
end

function SWEP:CanSecondaryAbility()
	--if not self:IsLevelAchieved( self.Secondary.Level ) then return false end
	return not self:IsOnCooldown( self.Secondary.Slot )
end

function SWEP:Reload()
	self.Weapon:DefaultReload( self.ReloadAnim );
end

function SWEP:ShootBullet( damage, num_bullets, aimcone, distance, recoil )
	
   self:SendWeaponAnim(self.PrimaryAnim)

   self.Owner:MuzzleFlash()
   self.Owner:SetAnimation( PLAYER_ATTACK1 )

   if not IsFirstTimePredicted() then return end

	local bullet = {}
	bullet.Num 			= num_bullets
	bullet.Src 			= self.Owner:GetShootPos()			-- Source
	bullet.Dir 			= self.Owner:GetAimVector()			-- Dir of bullet
	if distance then bullet.Distance 	= distance end			-- Distance
	bullet.Spread 		= Vector( aimcone, aimcone, 0 )		-- Aim Cone
	if self.TracerName then bullet.TracerName 	= self.TracerName end					-- TracerName
	bullet.Tracer		= self.Tracer				-- Show a tracer on every x bullets 
	bullet.Force		= 10									-- Amount of force to give to phys objects
	bullet.Damage		= damage
	bullet.AmmoType 	= "Pistol"
	
	if ((game.SinglePlayer() and SERVER) or --RECOIL on TTT base
       ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted())) then
		if recoil then
			local eyeang = self.Owner:EyeAngles()
		    eyeang.pitch = eyeang.pitch - recoil
		    self.Owner:SetEyeAngles( eyeang )
		end
	end

	self.Owner:FireBullets( bullet )
		
end


function SWEP:StartSecondaryCooldown( duration)
	if CLIENT then return end -- function should only be available for servers since all data is stored serverside

	if duration < 1 then return end -- if duration < 1 there is no need for a cooldown

	local cdcallname = "Cooldown."..self.Secondary.Slot -- Create Timer and Network name

	if self:IsOnCooldown( cdcallname ) then return end -- check if a cooldown exists already in case player died with ability on cd (Maybe uneeded here because it should be checked in the Attack functions)

	self.Owner:StartWarriorCooldown(cdcallname,duration) -- we need to call the timer in the player table so it still works if the swep owner dies
	
end

function SWEP:StartPrimaryCooldown( duration)
	if CLIENT then return end -- function should only be available for servers since all data is stored serverside

	if duration < 1 then return end -- if duration < 1 there is no need for a cooldown

	local cdcallname = "Cooldown."..self.Primary.Slot -- Create Timer and Network name

	if self:IsOnCooldown( cdcallname ) then return end -- check if a cooldown exists already in case player died with ability on cd (Maybe uneeded here because it should be checked in the Attack functions)

	self.Owner:StartWarriorCooldown(cdcallname,duration) -- we need to call the timer in the player table so it still works if the swep owner dies
	
end

function SWEP:IsOnCooldown( slot, supressmsg )
	if  self.Owner:GetNWInt( "Cooldown."..slot ,0) == 0 then -- return if NWInt exists (is it safe to check the nwint!?) since this function is only relevant client side its probably safe... prove me wrong

		return false

	else
		if not supressmsg then self.Owner:PrintMessage( HUD_PRINTTALK, "Wait "..self.Owner:GetNWInt( "Cooldown."..slot ,0).." more seconds to use that again.") end
		
		return true

	end
end

function SWEP:IsLevelAchieved(lvl, supressmsg)

	if team.GetLevel(self.Owner:Team()) < lvl then

		if not supressmsg then self.Owner:PrintMessage( HUD_PRINTTALK, "You need Level ["..lvl.."] to use that ability.") end

		return false

	else

		return true

	end -- return wether player is under or above/equal the passed lvl
end

function SWEP:CustomTracer( name, hitpos )--shitty tracer

	local effectdata = EffectData()
	effectdata:SetOrigin( hitpos )
	effectdata:SetStart( self.Owner:GetShootPos() )
	effectdata:SetAttachment( 1 )
	effectdata:SetEntity( self.Weapon )
	util.Effect( name , effectdata )

end

function SWEP:MeleeAttack( dmg, distance, type)

	if not IsValid(self.Owner) then return end
	type = type or DMG_CLUB
	distance = distance or 50

	local ply = self.Owner

	if self.Owner.LagCompensation then
	  self.Owner:LagCompensation(true)
	end

	local pos = ply:GetPos()
	local spos= ply:GetShootPos()
	local ang = ply:GetAimVector()

	local trace = util.TraceHull( {
	  start = spos,
	  endpos = spos + ( ang * distance ),
	  filter = ply,
	  mins = Vector( -5, -5, -5 ),
	  maxs = Vector( 5, 5, 5 ),
	  mask = MASK_SHOT_HULL
	} )

	local hitEntity = trace.Entity

	self.Owner:LagCompensation(false)

	ply:SetAnimation( PLAYER_ATTACK1 )

	if IsValid(hitEntity) or trace.HitWorld then
		self.Weapon:SendWeaponAnim( self.PrimaryAnim )
		if hitEntity:IsPlayer() or hitEntity:IsNPC() then
			if hitEntity:IsPlayer() or hitEntity:GetBloodColor() != DONT_BLEED or hitEntity:GetClass() == "prop_ragdoll" then
				local effectdata = EffectData()
				effectdata:SetOrigin( hitEntity:GetPos() + hitEntity:OBBCenter() + Vector(0,0,10) )
				util.Effect( "BloodImpact" , effectdata )
			end
			if SERVER then
				local dmginfo = DamageInfo()
				dmginfo:SetDamage(dmg)
				dmginfo:SetAttacker(ply)
				dmginfo:SetInflictor(self.Weapon)
				dmginfo:SetDamagePosition(ply:GetPos())
				dmginfo:SetDamageType(type)

				hitEntity:TakeDamageInfo(dmginfo)
			end
		else
			self:ShootBullet( 0, 1, 0, distance )
		end

	else
	  self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
	end
end

function SWEP:CompensatedTraceLine( distance )
	if self.Owner.LagCompensation then
		self.Owner:LagCompensation(true)
	end
	if not distance then
		local tr = self.Owner:GetEyeTrace()
		self.Owner:LagCompensation(false)
		return tr
	end
	local spos = self.Owner:GetShootPos()
	local sdest = spos + (self.Owner:GetAimVector() * distance)
    local tr = util.TraceLine({start=spos, endpos=sdest, filter=self.Owner, mask=MASK_SHOT_HULL})
    self.Owner:LagCompensation(false)
    return tr
end

local correctTick = math.floor(1 / engine.TickInterval())
local tick = 0

function SWEP:LessTicks( pS ) --function to only execute Think() content roughly once per second or however pS (per second) is set to
	pS = pS or 1
	tick = tick + 1
	if tick == math.floor(correctTick / pS) then
		tick = 0
		return true
	end
	return false
end