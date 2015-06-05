AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType 			= "physgun"
SWEP.TracerName 		= "garry_bullettracer"
SWEP.Tracer				= 1

SWEP.Primary.Damage 		= 12
SWEP.Primary.Cone           = 0.005
SWEP.Primary.Delay 			= 0.2

SWEP.Primary.Slot 			= 0
SWEP.Secondary.Slot 		= 1

SWEP.Primary.Sound = Sound( "Weapon_MegaPhysCannon.ChargeZap" )

SWEP.ViewModel  = "models/weapons/v_superphyscannon.mdl"
SWEP.WorldModel = "models/weapons/w_Physics.mdl"

function SWEP:PrimaryAttack()
	self.Weapon:EmitSound(self.Primary.Sound)

	self:ShootBullet( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
end

function SWEP:SecondaryAttack()
	-- check if required level is achieved if not return
	if not self:IsLevelAchieved(2) then return end
	if self:IsOnCooldown( self.Secondary.Slot ) then return end --check if ability is on cooldow

	--laser effect (modified green laser)
	local trace = self.Owner:GetEyeTrace()

	self:CustomTracer( "garry_stuntracer", trace.HitPos )

	self:ShootEffects()
		
	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT
		local cooldown = 10
		local hitEntity = trace.Entity
		if trace.Hit and hitEntity:IsPlayer() and hitEntity:Team() != self.Owner:Team() then -- if tracer hits player freeze him
			hitEntity:SetStatus( 1.5, "Garry_Stungun", function() hitEntity:Freeze(true) end , function() hitEntity:Freeze( false ) end ) -- unfreeze after 1.5sec
		else
			cooldown = cooldown/5 -- if target not hit reset to a lower cooldown
		end

		self:StartCooldown( self.Secondary.Slot ,cooldown)-- Start cooldown for first "ability"

	end
end