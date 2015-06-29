
AddCSLuaFile()

SWEP.Base = "weapon_fwbase"
SWEP.Slot = 1
SWEP.ViewModelFOV = 42
SWEP.HoldType 			= "ar2"

SWEP.Primary.Slot 		= 2
SWEP.Primary.Level      = 4

SWEP.Primary.Sound       	= Sound( "Weapon_Crowbar.Single" )

SWEP.ViewModel				= "models/weapons/c_crossbow.mdl"
SWEP.WorldModel				= "models/weapons/w_crossbow.mdl"

function SWEP:PrimaryAttack()
   if not self:CanPrimaryAbility() then return end

   if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT

      local cooldown = 5

      local trace = self:CompensatedTraceLine( 2000 )


      local hitEntity = trace.Entity


      if trace.Hit and IsValid(hitEntity) then
         hitEntity:SetPos(trace.StartPos)
      end

      self:StartPrimaryCooldown( cooldown)-- Start cooldown for first "ability"

   end

end

function SWEP:SecondaryAttack()
end
