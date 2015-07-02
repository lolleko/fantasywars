if SERVER then
   AddCSLuaFile()
end


ENT.Model =	Model("models/items/ar2_grenade.mdl")
ENT.Type = "anim"


function ENT:Initialize()

   self:SetModel(self.Model)

   self:PhysicsInit(SOLID_VPHYSICS)
   self:SetMoveType(MOVETYPE_VPHYSICS)
   self:SetSolid(SOLID_BBOX)
   self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

end

function ENT:PhysicsCollide( data, phys )
	local explode = ents.Create("env_explosion")
	explode:SetPos( self:GetPos() )
	self:Remove()
	explode:SetCreator( self.Owner )
	explode:Spawn()
	explode:SetKeyValue("iMagnitude","75")
	explode:Fire("Explode", 0, 0 )
	explode:EmitSound( "ambient/explosions/explode_" .. math.random( 1, 9 ) .. ".wav", 400, 400 )
end