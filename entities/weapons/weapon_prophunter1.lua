AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType 			= "smg"
SWEP.Primary.Damage 		= 1
SWEP.Primary.Delay 			= 0.1
SWEP.Primary.Damage 		= 10
SWEP.Primary.Automatic 		= true
SWEP.Primary.Cone 			= 0.035

SWEP.Primary.Slot 			= 0
SWEP.Secondary.Slot 		= 1

SWEP.ViewModel = "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"

SWEP.Primary.Sound = Sound("Weapon_SMG1.Single")
SWEP.Secondary.Sound = Sound("Weapon_Mortar.Single")

function SWEP:PrimaryAttack()
	self.Weapon:EmitSound(self.Primary.Sound)

	self:ShootBullet( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAbility() then return end

	self.Weapon:EmitSound(self.Secondary.Sound)

	local ent = ents.Create( "prophunter_nuke" )
	if ( !IsValid( ent ) ) then return end
	ent:SetPos( self.Owner:EyePos() + ( self.Owner:GetAimVector() ) )
	ent:SetAngles( self.Owner:EyeAngles() )
	ent:Spawn()
	local phys = ent:GetPhysicsObject()
	if ( !IsValid( phys ) ) then ent:Remove() return end
	local velocity = self.Owner:GetAimVector()
	velocity = velocity * 4700 + Vector(0,0,500)
	phys:ApplyForceCenter( velocity )

	if SERVER then self:StartSecondaryCooldown( 10 ) end
end