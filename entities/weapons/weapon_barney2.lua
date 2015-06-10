
AddCSLuaFile()

SWEP.Base = "weapon_fwbase"
SWEP.Slot = 1
SWEP.HoldType 			= "ar2"

SWEP.Primary.Distance        = 60
SWEP.Primary.Damage 		= 40
SWEP.Primary.Delay 			= 0.5
SWEP.Primary.Automatic = true

SWEP.Primary.Slot 		= 2
SWEP.Primary.Level      = 4
SWEP.Secondary.Slot 		= 3
SWEP.Secondary.Level    = 6

SWEP.Primary.Sound       	= Sound( "Weapon_Crowbar.Single" )

SWEP.ViewModel				= "models/weapons/c_crossbow.mdl"
SWEP.WorldModel				= "models/weapons/w_crossbow.mdl"

function SWEP:PrimaryAttack()
   if not self:CanPrimaryAbility() then return end

   if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT

      local cooldown = 15

      self:StartPrimaryCooldown( cooldown)-- Start cooldown for first "ability"

   end

end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAbility() then return end

	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT

		local cooldown = 15

		self:StartSecondaryCooldown( cooldown)-- Start cooldown for first "ability"

	end
end
