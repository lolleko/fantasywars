AddCSLuaFile()

SWEP.Base = "weapon_fwplaceable"

SWEP.HoldType = "grenade"
SWEP.ViewModelFOV = 74
local WorldModel = Model("models/props_combine/combinethumper002.mdl")
SWEP.ViewModel = "models/weapons/c_Grenade.mdl"
SWEP.WorldModel = WorldModel
SWEP.PreviewModel = WorldModel
SWEP.Slot 				= 3

SWEP.Primary.Slot 			= 3
SWEP.Primary.Level 			= 6

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAbility() then return end

	if not self:CanPlace() then return end

	self:ShootEffects()
		
	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT
		local cooldown = 10

		if self.Owner:HasStatus("Thumper_Placed") then self.Owner:RemoveStatus("Thumper_Placed") end

		local thumper = ents.Create( "prop_physics" )
		if ( !IsValid( thumper ) ) then return end
		thumper:SetModel( "models/props_combine/combinethumper002.mdl" )
		thumper:SetCreator( self.Owner )
		thumper:SetPos( self:CalculatePos() )
		thumper:SetAngles( self:CalculateAngles() )
		thumper:Spawn()
		thumper:SetMoveType(MOVETYPE_NONE)

		self.Owner:SetStatus({Name = "Thumper_Placed", FuncEnd = function() thumper:Remove() end, Show = false})

		
		self:StartPrimaryCooldown( cooldown)-- Start cooldown for first "ability"

	end
end