AddCSLuaFile()

SWEP.Base = "weapon_fwplaceable"

SWEP.HoldType = "grenade"
SWEP.ViewModelFOV = 74
local WorldModel = Model("models/combine_turrets/floor_turret.mdl")
SWEP.ViewModel = "models/weapons/c_Grenade.mdl"
SWEP.WorldModel = WorldModel
SWEP.PreviewModel = WorldModel
SWEP.Slot 				= 1
SWEP.ShowViewModel = false

SWEP.Primary.Slot 			= 1
SWEP.Primary.Level 			= 2

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAbility() then return end

	if not self:CanPlace() then return end

	self:ShootEffects()
		
	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT
		local cooldown = 10

		if self.Owner:HasStatus("Turret_Placed") then self.Owner:RemoveStatus("Turret_Placed") end

		local turret = ents.Create( "npc_turret_floor" )
		if ( !IsValid( turret ) ) then return end
		turret:SetOwner( self.Owner )
		turret:SetPos( self:CalculatePos() )
		turret:SetAngles( self:CalculateAngles() )
		turret:Spawn()
		local turretphys = turret:GetPhysicsObject()
	    if turretphys:IsValid() then
	       turretphys:EnableMotion(false)
	    end

	    for _,target in pairs(player.GetAll()) do
			if target:Team() != self.Owner:Team() then
				turret:AddEntityRelationship( target, D_HT, 99 )
			else
				turret:AddEntityRelationship( target, D_LI, 99 )
			end
		end
		
		self.Owner:SetStatus({Name = "Turret_Placed", FuncEnd = function() turret:Remove() end, Show = false})

		
		self:StartPrimaryCooldown( cooldown)-- Start cooldown for first "ability"

	end
end