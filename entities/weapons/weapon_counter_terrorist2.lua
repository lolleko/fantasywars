AddCSLuaFile()

SWEP.Base = "weapon_fwbase"
SWEP.Slot            = 1

SWEP.HoldType        = "ar2"
SWEP.TracerName      = "Tracer"
SWEP.Tracer          = 4
SWEP.Primary.Distance   = 10000

SWEP.Primary.Damage     = 15
SWEP.Primary.Cone       = 0.001
SWEP.Primary.Slot          = 1
SWEP.Primary.Level       = 6
SWEP.Primary.Delay 			= 0.15
SWEP.Primary.Recoil 		= 1.05
SWEP.Primary.ClipSize       = 10
SWEP.Primary.DefaultClip    = 20
SWEP.Primary.Ammo           = "Pistol"

SWEP.ViewModelFOV    = 54
SWEP.ViewModel			= "models/weapons/cstrike/c_pist_usp.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_usp_silencer.mdl"
SWEP.Primary.Sound = Sound( "weapons/usp/usp1.wav" )

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK_SILENCED
SWEP.ReloadAnim = ACT_VM_RELOAD_SILENCED

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end

	self.Weapon:EmitSound(self.Primary.Sound)

	local trace = self.Owner:GetEyeTrace()

	if ( trace.Entity:IsValid() and ( trace.Entity:IsPlayer() or trace.Entity:IsNPC() ) and ( (trace.Entity:GetAimVector() ):Dot( self.Owner:GetAimVector() ) > 0 ) ) then
		dmg = self.Primary.Damage * 2.5 -- More damage when hit in back
	else
		dmg = self.Primary.Damage
	end

	self:ShootBullet( dmg, self.Primary.NumShots, self.Primary.Cone , self.Primary.Distance, self.Primary.Recoil )

	if SERVER then
		self:TakePrimaryAmmo(1)
		self.Owner:GiveAmmo(1, "Pistol", true)
	end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

end

function SWEP:Deploy()
   self:SendWeaponAnim(ACT_VM_DRAW_SILENCED)
   return true
end
