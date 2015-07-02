AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType 			= "revolver"
SWEP.Tracer				= 1

SWEP.Primary.Damage 		= 30
SWEP.Primary.Cone           = 0.08
SWEP.Primary.Delay 			= 0.7

SWEP.Primary.Slot 			= 0
SWEP.Secondary.Slot 		= 1

SWEP.Primary.Sound = Sound( "Weapon_357.Single" )

SWEP.ViewModel  = "models/weapons/c_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"

function SWEP:PrimaryAttack()
	self.Weapon:EmitSound(self.Primary.Sound)

	self:ShootBullet( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, 10000, 3 )

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAbility() then return end

	self.Weapon:EmitSound(self.Primary.Sound)

	local r = math.random(1,6)

	if r == 1 then 
		self:ShootBullet( self.Primary.Damage*4, self.Primary.NumShots, self.Primary.Cone, 10000, 3 )
	else
		self:ShootBullet( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, 10000, 3 )
	end

	if SERVER then self:StartSecondaryCooldown( 10 ) end
	
end
