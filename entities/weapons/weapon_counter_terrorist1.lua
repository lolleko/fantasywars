AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType 			= "ar2"
SWEP.TracerName 		= "Tracer"
SWEP.Tracer				= 4
SWEP.Primary.Distance 	= 1500
SWEP.CSMuzzleFlashes	= true

SWEP.Primary.Damage 		= 18
SWEP.Primary.Cone           = 0.005
SWEP.Primary.Delay 			= 0.18
SWEP.Primary.Automatic 		= true
SWEP.Primary.Recoil 		= 1.1
SWEP.Primary.Slot 			= 0
SWEP.Primary.ClipSize       = 20
SWEP.Primary.DefaultClip    = 60
SWEP.Primary.Ammo           = "Pistol"

SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_rif_m4a1.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_m4a1_silencer.mdl"
SWEP.Primary.Sound			= Sound( "Weapon_m4a1.Silenced" )

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK_SILENCED
SWEP.ReloadAnim = ACT_VM_RELOAD_SILENCED

local shots = 0

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end

	local aimcone = self.Primary.Cone

	if SERVER then if self.Owner:HasStatus("CT_Spray") then aimcone = (2^(shots/300)-1) + aimcone else shots = 0  end end
	if CLIENT then if FW:HasStatus("CT_Spray") then aimcone = (2^(shots/300)-1) + aimcone else shots = 0  end end --For proper tracers and decals
	
	self.Weapon:EmitSound(self.Primary.Sound)

	self:ShootBullet( self.Primary.Damage, self.Primary.NumShots, aimcone, self.Primary.Distance, self.Primary.Recoil )

	if SERVER then
		self:TakePrimaryAmmo(1)
		self.Owner:GiveAmmo(1, "Pistol", true)
	end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if SERVER then self.Owner:SetStatus({Name = "CT_Spray", Duration = 0.2}) end

	shots = shots +1

end

function SWEP:Deploy()
   self:SendWeaponAnim(ACT_VM_DRAW_SILENCED)
   return true
end