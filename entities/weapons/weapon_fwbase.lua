/*
	weapon base for FW stuff (weps/skills)
	some extra functions, but 90% just wepaon_base
*/
AddCSLuaFile()

SWEP.Base = "weapon_base"

SWEP.Spawnable          = false

SWEP.HoldType 			= "pistol"
SWEP.AutoSwitchTo       = false
SWEP.AutoSwitchFrom     = false
SWEP.Tracer				= 2
SWEP.Distance 			= 10000
SWEP.UseHands			= true
SWEP.Slot 				= 0

SWEP.Primary.Damage 		= 10
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"
SWEP.Primary.NumShots       = 1

SWEP.Primary.Slot 			= 0
SWEP.Secondary.Slot 		= 1

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

SWEP.DeploySpeed = 20 -- high deploy speed since you need to switch for additional abilities

SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_357.mdl"

--almost copied from weapon_base

function SWEP:Initialize()
	self:SetDeploySpeed( self.DeploySpeed )	-- set deployspeed for every wepaon (very fast by default)
    self:SetWeaponHoldType( self.HoldType ) -- Allow custom weapon hold type since it's just "pistol" in weapon_base
end

function SWEP:ShootBullet( damage, num_bullets, aimcone )
	
	local bullet = {}
	bullet.Num 			= num_bullets
	bullet.Src 			= self.Owner:GetShootPos()			-- Source
	bullet.Dir 			= self.Owner:GetAimVector()			-- Dir of bullet
	bullet.Distance 	= self.Distance 					-- Distance
	bullet.Spread 		= Vector( aimcone, aimcone, 0 )		-- Aim Cone
	if self.TracerName then bullet.TracerName 	= self.TracerName end					-- TracerName
	bullet.Tracer		= self.Tracer				-- Show a tracer on every x bullets 
	bullet.Force		= 1									-- Amount of force to give to phys objects
	bullet.Damage		= damage
	bullet.AmmoType 	= "Pistol"
	
	self.Owner:FireBullets( bullet )
	
	self:ShootEffects()
	
end


function SWEP:StartCooldown(slot, duration)
	if CLIENT then return end -- function should only be available for servers since all data is stored serverside

	if duration <= 0 then return end -- if duration < or 0 there is no need for a cooldown

	local cdcallname = self.Owner:Nick()..".Cooldown."..slot -- Create Timer and Network name

	if self:IsOnCooldown( cdcallname ) then return end -- check if a cooldown exists already in case player died with ability on cd (Maybe uneeded here because it should be chekecd in the Attack functions)

	self.Owner:StartWarriorCooldown(cdcallname,duration) -- we need to call the timer in the player table so it still works if the swep owner dies
	
end

function SWEP:IsOnCooldown( slot, supressmsg )

	if  self.Owner:GetNWInt( self.Owner:Nick()..".Cooldown."..slot ,0) == 0 then -- return if NWInt exists (is it safe to check the nwint!?)

		return false

	else
		if not supressmsg then self.Owner:PrintMessage( HUD_PRINTTALK, "Wait "..self.Owner:GetNWInt( self.Owner:Nick()..".Cooldown."..slot ,0).." more seconds to use that again.") end
		return true

	end
end

function SWEP:IsLevelAchieved(lvl)

	if team.GetLevel(self.Owner:Team()) < lvl then

		self.Owner:PrintMessage( HUD_PRINTTALK, "You need Level ["..lvl.."] to use that ability.")

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