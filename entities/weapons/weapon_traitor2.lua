AddCSLuaFile()

SWEP.Base = "weapon_fwbase"
SWEP.Slot = 1

SWEP.HoldType 			= "slam"

SWEP.Primary.Slot 			= 2
SWEP.Primary.Level 			= 4
SWEP.Secondary.Slot 		= 3
SWEP.Secondary.Level 		= 6

SWEP.ViewModel			= "models/weapons/cstrike/c_c4.mdl"
SWEP.WorldModel			= "models/weapons/w_c4.mdl"

function SWEP:Deploy()

	if SERVER and self.Owner:HasStatus( "Traitor_Invisible" ) then self.Owner:RemoveStatus( "Traitor_Invisible" ) end

end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAbility() then return end

	local ply = self.Owner

	local effectdata = EffectData()
	effectdata:SetOrigin( ply:GetPos() )
	effectdata:SetNormal( ply:GetPos() )
	effectdata:SetMagnitude( 8 )
	effectdata:SetScale( 1 )
	effectdata:SetRadius( 16 )
	util.Effect( "Sparks", effectdata )
	self.BaseClass.ShootEffects( self )
	
	if (SERVER) then

		local status = {}
		status.Name = "Traitor_Jihad"
		status.DisplayName = "Kabooooom"
		status.Duration = 2
		status.FuncStart = function() ply:SetWalkSpeed( ply:GetWalkSpeed() + 200 ) end
		status.FuncEnd = function() Explode( ply ) ply:SetWalkSpeed( ply:GetWalkSpeed() - 200 ) end

		ply:SetStatus( status )

		self:StartPrimaryCooldown( 50 )
	end
end

function SWEP:SecondaryAttack() --TODO AWESOME ULT
	if not self:CanSecondaryAbility() then return end

	if SERVER then

		self:StartSecondaryCooldown(2)

	end
end

function Explode( ply )

	local ent = ents.Create( "env_explosion" )
	ent:SetPos( ply:GetPos() )
	ent:SetOwner( ply )
	ent:Spawn()
	ent:SetKeyValue( "iMagnitude", "125" )
	ent:Fire( "Explode", 0, 0 )
	ent:EmitSound( "siege/big_explosion.wav", 500, 500 )

end