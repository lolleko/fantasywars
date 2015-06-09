AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType 			= "ar2"
SWEP.TracerName 		= "AirboatGunTracer"
SWEP.Tracer				= 1

SWEP.Primary.Damage 		= 20
SWEP.Primary.Cone           = 0.008
SWEP.Primary.Delay 			= 0.4
SWEP.Primary.Automatic 		= true

SWEP.Primary.Slot 			= 0

SWEP.Primary.Sound = Sound( "weapons/ar2/fire1.wav" )

SWEP.ViewModel  = "models/weapons/c_IRifle.mdl"
SWEP.WorldModel = "models/weapons/w_IRifle.mdl"

function SWEP:PrimaryAttack()
	self.Weapon:EmitSound(self.Primary.Sound)

	self:ShootBullet( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
end