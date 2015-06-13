AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType 			= "ar2"
SWEP.TracerName 		= "Tracer"
SWEP.Tracer				= 4
SWEP.Primary.Distance 	= 1500

SWEP.Primary.Damage 		= 21
SWEP.Primary.Cone           = 0.01
SWEP.Primary.Delay 			= 0.18
SWEP.Primary.Automatic 		= true
SWEP.Primary.Recoil 		= 1.1
SWEP.Primary.Slot 			= 0
SWEP.Primary.ClipSize       = 30
SWEP.Primary.DefaultClip    = 60
SWEP.Primary.Ammo           = "Pistol"

SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_rif_m4a1.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_m4a1.mdl"
SWEP.Primary.Sound			= Sound( "Weapon_m4a1.Single" )

local shots = 0
local precise = true

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end

	local aimcone = self.Primary.Cone

	if SERVER then if self.Owner:HasStatus("CT_Spray") then aimcone = (2^(shots/300)-1) + aimcone else shots = 0  end end

	print(aimcone)

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

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAbility() then return end

	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT

		local cooldown = 15
		local ply = self.Owner

		
		self:StartSecondaryCooldown( cooldown)-- Start cooldown for first "ability"

	end
end