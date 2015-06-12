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

SWEP.DeploySpeed = 10 -- high deploy speed since you need to switch for additional abilities

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

function SWEP:CanPrimaryAbility()
	if not self:IsLevelAchieved( self.Primary.Level ) then return false end

	if self:IsOnCooldown( self.Primary.Slot ) then
		return false
	end

	return true
end

function SWEP:CanSecondaryAbility()
	if not self:IsLevelAchieved( self.Secondary.Level ) then return false end

	if self:IsOnCooldown( self.Secondary.Slot ) then
		return false
	end

	return true
end

function SWEP:ShootBullet( damage, num_bullets, aimcone, distance, recoil )
	
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
	
	if recoil then
		local eyeang = self.Owner:EyeAngles()
	    eyeang.pitch = eyeang.pitch - recoil
	    self.Owner:SetEyeAngles( eyeang )
	end

	self.Owner:FireBullets( bullet )
	
	self:ShootEffects()
	
end


function SWEP:StartSecondaryCooldown( duration)
	if CLIENT then return end -- function should only be available for servers since all data is stored serverside

	if duration < 1 then return end -- if duration < 1 there is no need for a cooldown

	local cdcallname = self.Owner:Nick()..".Cooldown."..self.Secondary.Slot -- Create Timer and Network name

	if self:IsOnCooldown( cdcallname ) then return end -- check if a cooldown exists already in case player died with ability on cd (Maybe uneeded here because it should be checked in the Attack functions)

	self.Owner:StartWarriorCooldown(cdcallname,duration) -- we need to call the timer in the player table so it still works if the swep owner dies
	
end

function SWEP:StartPrimaryCooldown( duration)
	if CLIENT then return end -- function should only be available for servers since all data is stored serverside

	if duration < 1 then return end -- if duration < 1 there is no need for a cooldown

	local cdcallname = self.Owner:Nick()..".Cooldown."..self.Primary.Slot -- Create Timer and Network name

	if self:IsOnCooldown( cdcallname ) then return end -- check if a cooldown exists already in case player died with ability on cd (Maybe uneeded here because it should be checked in the Attack functions)

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
   local pos = ply:GetPos()
   local spos= ply:GetShootPos()
   local ang = ply:GetAimVector()
    
   local trace = util.TraceHull( {
      start = spos,
      endpos = spos + ( ang * distance ),
      filter = ply,
      mins = Vector( -10, -10, -10 ),
      maxs = Vector( 10, 10, 10 ),
      mask = MASK_SHOT_HULL
   } )
    
   local hitEntity = trace.Entity

   ply:SetAnimation( PLAYER_ATTACK1 )

   if IsValid(hitEntity) or trace.HitWorld then
      self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )

      if SERVER then
         if trace.Hit then
         	self:ShootBullet( dmg, 1, 0, distance )
         end
      end

   else
      self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
   end

end