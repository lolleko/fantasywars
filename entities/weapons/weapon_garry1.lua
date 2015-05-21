AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType 			= "physgun"
SWEP.AutoSwitchTo       = false
SWEP.AutoSwitchFrom     = false
SWEP.TracerName 		= "garry_bullettracer"
SWEP.Tracer				= 2

SWEP.Primary.Damage 		= 10
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"

SWEP.Primary.NumShots       = 1
SWEP.Primary.Cone           = 0.005
SWEP.Primary.Delay 			= 0.1

SWEP.Primary.Slot 			= 0
SWEP.Secondary.Slot 		= 1

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

SWEP.Primary.Sound = Sound( "Weapon_MegaPhysCannon.ChargeZap" )

SWEP.ViewModel  = "models/weapons/v_superphyscannon.mdl"
SWEP.WorldModel = "models/weapons/w_Physics.mdl"

function SWEP:PrimaryAttack()
	self.Weapon:EmitSound(self.Primary.Sound)

	self:ShootBullet( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
end

function SWEP:SecondaryAttack()
	if self:IsOnCooldown( self.Secondary.Slot ) then return end --check if ability is on cooldow

		-- check if required level is achieved if not return
		if not self:IsLevelAchieved(2) then return end

		--laser effect (modified green laser)
		local trace = self.Owner:GetEyeTrace()
		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetStart( self.Owner:GetShootPos() )
		effectdata:SetAttachment( 1 )
		effectdata:SetEntity( self.Weapon )
		util.Effect( "garry_stuntracer", effectdata )

		if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT
			local cooldown = 10
			local hitEntity = trace.Entity
			if trace.Hit and hitEntity:IsPlayer() then -- if tracer hits player freeze him
				hitEntity:SetStatus( 1.5, "Garry_Stungun", function() hitEntity:Freeze(true) end , function() hitEntity:Freeze( false ) end ) -- unfreeze after 1.5sec
			else
				cooldown = cooldown/5 -- if target not hit reset to a lower cooldown
			end

			self:StartCooldown( self.Secondary.Slot ,cooldown)-- Start cooldown for first "ability"

		end
end