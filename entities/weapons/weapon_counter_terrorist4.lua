
AddCSLuaFile()

SWEP.Base = "weapon_fwbase"
SWEP.Slot            = 3

SWEP.HoldType 			= "melee"
SWEP.CSMuzzleFlashes	= true

SWEP.Primary.Distance        = 80
SWEP.Primary.Damage 		= 30
SWEP.Primary.Delay 			= 0.9
SWEP.Primary.Automatic = true

SWEP.Primary.Slot 		= 0
SWEP.Primary.Slot        = 3
SWEP.Secondary.Level    = 2

SWEP.Primary.Sound       	= Sound( "Weapon_Crowbar.Single" )

SWEP.ViewModelFOV    = 54
SWEP.ViewModel          = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel         = "models/weapons/w_knife_t.mdl"

function SWEP:Deploy()
   if SERVER then self.Owner:SetWarriorSpeed( self.Owner:GetWarriorSpeed() + 100 ) end
   return true
end

function SWEP:Holster()
   if SERVER then self.Owner:SetWarriorSpeed( self.Owner:GetWarriorSpeed() ) end
   return true
end

function SWEP:PrimaryAttack()

   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   self.Weapon:EmitSound(self.Primary.Sound)

   self:MeleeAttack( self.Primary.Damage, self.Primary.Distance)

end

function SWEP:SecondaryAttack()
end