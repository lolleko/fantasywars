AddCSLuaFile()

SWEP.Base = "weapon_fwplaceable"
SWEP.Slot = 1

SWEP.HoldType 			= "slam"

SWEP.Primary.Slot 			= 2
SWEP.Primary.Level 			= 4

SWEP.ViewModel			= "models/weapons/cstrike/c_c4.mdl"
SWEP.WorldModel			= "models/weapons/w_c4.mdl"
SWEP.ShowViewModel 		= true
local Preview = Model("models/weapons/w_c4_planted.mdl")
SWEP.PreviewModel 		= Preview

function SWEP:Deploy()
	if SERVER and self.Owner:HasStatus("Traitor_Invisible") then self.Owner:RemoveStatus("Traitor_Invisible") end
	return true
end
function SWEP:PrimaryAttack()
	if not self:CanPrimaryAbility() then return end

	if not self:CanPlace() then return end

	self:ShootEffects()
		
	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT
		local cooldown = 10
		local ply = self.Owner

		if self.Owner:HasStatus("Explosive_Placed") then self.Owner:RemoveStatus("Explosive_Placed") end

		local explosive = ents.Create( "prop_physics" )
		if ( !IsValid( explosive ) ) then return end
		explosive:SetModel( "models/weapons/w_c4_planted.mdl" )
		explosive:SetPos( self:CalculatePos() )
		explosive:SetAngles( self:CalculateAngles() )
		explosive:Spawn()
		local explosivephys = explosive:GetPhysicsObject()
	    if explosivephys:IsValid() then
	       explosivephys:EnableMotion(false)
	    end

		self.Owner:SetStatus({Name = "Explosive_Placed", FuncEnd = function()  Explode( explosive, ply ) end, Show = false})

		
		self:StartPrimaryCooldown( cooldown )-- Start cooldown for first "ability"

	end
end

function SWEP:SecondaryAttack()
	if SERVER then
		if self.Owner:HasStatus("Explosive_Placed") then self.Owner:RemoveStatus("Explosive_Placed") end
	end
end

function Explode( prop, ply )

	local ent = ents.Create( "env_explosion" )
	ent:SetPos( prop:GetPos() )
	ent:SetOwner( ply )
	ent:Spawn()
	ent:SetKeyValue( "iMagnitude", "125" )
	ent:Fire( "Explode", 0, 0 )
	ent:EmitSound( "weapon_AWP.Single", 500, 500 )

	prop:Remove()

end