AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType 			= "physgun"
SWEP.TracerName 		= "garry_bullettracer"
SWEP.Tracer				= 1

SWEP.Primary.Damage 		= 12
SWEP.Primary.Cone           = 0.005
SWEP.Primary.Delay 			= 0.2
SWEP.Primary.Automatic      = true

SWEP.Primary.Slot 			= 0
SWEP.Secondary.Slot 		= 1
SWEP.Secondary.Level 		= 2

SWEP.Primary.Sound = Sound( "Weapon_MegaPhysCannon.ChargeZap" )

SWEP.ViewModel  = "models/weapons/v_superphyscannon.mdl"
SWEP.WorldModel = "models/weapons/w_Physics.mdl"

function SWEP:PrimaryAttack()
	self.Weapon:EmitSound(self.Primary.Sound)

	self:ShootBullet( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAbility() then return end

	local trace = self:CompensatedTraceLine()

	self:CustomTracer( "garry_stuntracer", trace.HitPos )

	self:ShootEffects()
		
	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT
		local cooldown = 10
		local hitEntity = trace.Entity
		if trace.Hit and IsValid(hitEntity) and hitEntity:Team() != self.Owner:Team() then -- if tracer hits player freeze him

			--fancy sparks
			local effectdata = EffectData()
			effectdata:SetOrigin( hitEntity:GetPos() )
			effectdata:SetNormal( hitEntity:GetPos() )
			effectdata:SetMagnitude( 8 )
			effectdata:SetScale( 1 )
			effectdata:SetRadius( 16 )
			util.Effect( "Sparks", effectdata )

			local status = {}
			status.Name = "Garry_Stun"
			status.Inflictor = self.Owner
			status.DisplayName = "Froozen by Garry"
			status.Duration = 1.5
			status.FuncStart = function() hitEntity:Freeze( true ) end
			status.FuncEnd = function() hitEntity:Freeze( false ) end

			hitEntity:SetStatus( status )

		else
			cooldown = cooldown/5 -- if target not hit reset to a lower cooldown
		end

		self:StartSecondaryCooldown( cooldown )-- Start cooldown for first "ability"

	end
end