
AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType 			= "melee"

SWEP.Primary.Distance        = 60
SWEP.Primary.Damage 		= 40
SWEP.Primary.Delay 			= 1

SWEP.Primary.Slot 		= 0
SWEP.Secondary.Slot 		= 1

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

SWEP.Primary.Sound       	= Sound( "Weapon_Crowbar.Single" )

SWEP.ViewModel				= "models/weapons/c_crowbar.mdl"
SWEP.WorldModel				= "models/weapons/w_crowbar.mdl"

function SWEP:PrimaryAttack()
--stolen from weapon_zm_improvised (TTT) mayb i will recode it from scratch at somepoint

   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   self.Weapon:EmitSound(self.Primary.Sound)

   self:MeleeAttack( self.Primary.Damage, self.Primary.Distance)

end

function SWEP:SecondaryAttack()
	-- check if required level is achieved if not return
	if not self:IsLevelAchieved(2) then return end
	if self:IsOnCooldown( self.Secondary.Slot ) then return end --check if ability is on cooldow

	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT

		local cooldown = 15

		self.Owner:SetArmor(200)
		self.Owner:SetStatus( 3, "Gordon_ArmorCharge", function() self.Owner:SetWalkSpeed(-1) self.Owner:SetRunSpeed(-1) end , function() self.Owner:SetWalkSpeed( self.Owner:GetWarriorSpeed() ) self.Owner:SetRunSpeed( self.Owner:GetWarriorSpeed() ) end )

		self:StartCooldown( self.Secondary.Slot ,cooldown)-- Start cooldown for first "ability"

	end
end
