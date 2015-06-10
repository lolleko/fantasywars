
AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType 			= "melee"

SWEP.Primary.Distance        = 60
SWEP.Primary.Damage 		= 40
SWEP.Primary.Delay 			= 0.5
SWEP.Primary.Automatic = true

SWEP.Primary.Slot 		= 0
SWEP.Secondary.Slot 		= 1

SWEP.Primary.Sound       	= Sound( "Weapon_Crowbar.Single" )

SWEP.ViewModel				= "models/weapons/c_crowbar.mdl"
SWEP.WorldModel				= "models/weapons/w_crowbar.mdl"

function SWEP:PrimaryAttack()

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
      local ply = self.Owner

      local status = {}
      status.Name = "Gordon_ArmorCharge"
      status.DisplayName = "POWER"
      status.Duration = 3
      status.FuncStart = function() ply:SetWalkSpeed(-1) ply:SetRunSpeed(-1) ply:SetArmor(200) end
      status.FuncEnd = function() ply:SetWalkSpeed( ply:GetWarriorSpeed() ) ply:SetRunSpeed( ply:GetWarriorSpeed() ) end
		
		self.Owner:SetStatus( status  )

		self:StartCooldown( self.Secondary.Slot ,cooldown)-- Start cooldown for first "ability"

	end
end
