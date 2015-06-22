
AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType 			= "melee"

SWEP.Primary.Distance        = 80
SWEP.Primary.Damage 		= 40
SWEP.Primary.Delay 			= 0.5
SWEP.Primary.Automatic = true

SWEP.Primary.Slot 		= 0
SWEP.Secondary.Slot 		= 1
SWEP.Secondary.Level    = 2

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
	if not self:CanSecondaryAbility() then return end

	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT

		local cooldown = 15
      local ply = self.Owner

      local status = {}
      status.Name = "Gordon_ArmorCharge"
      status.DisplayName = "POWER"
      status.Duration = 3
      status.FuncStart = function() ply:SetWarriorSpeed(-1) ply:SetArmor(200) end
      status.FuncEnd = function() ply:SetWarriorSpeed( ply:GetWarriorSpeed() ) end
		
		self.Owner:SetStatus( status  )

		self:StartSecondaryCooldown( cooldown )-- Start cooldown for first "ability"

	end
end