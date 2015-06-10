
AddCSLuaFile()

SWEP.Base = "weapon_fwbase"
SWEP.Slot = 1
SWEP.HoldType 			= "ar2"

SWEP.Primary.Distance        = 60
SWEP.Primary.Damage 		= 40
SWEP.Primary.Delay 			= 0.5
SWEP.Primary.Automatic = true

SWEP.Primary.Slot 		= 2
SWEP.Secondary.Slot 		= 3

SWEP.Primary.Sound       	= Sound( "Weapon_Crowbar.Single" )

SWEP.ViewModel				= "models/weapons/c_crossbow.mdl"
SWEP.WorldModel				= "models/weapons/w_crossbow.mdl"

function SWEP:PrimaryAttack()
   -- check if required level is achieved if not return
   if not self:IsLevelAchieved(4) then return end
   if self:IsOnCooldown( self.Primary.Slot ) then return end --check if ability is on cooldow

   if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT

      local cooldown = 15

      self:StartCooldown( self.Primary.Slot ,cooldown)-- Start cooldown for first "ability"

   end

end

function SWEP:SecondaryAttack()
	-- check if required level is achieved if not return
	if not self:IsLevelAchieved(6) then return end
	if self:IsOnCooldown( self.Secondary.Slot ) then return end --check if ability is on cooldow

	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT

		local cooldown = 15

		self:StartCooldown( self.Secondary.Slot ,cooldown)-- Start cooldown for first "ability"

	end
end
