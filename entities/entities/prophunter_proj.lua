if SERVER then
   AddCSLuaFile()
end

ENT.Model =	Model("models/props_junk/")
ENT.Type = "anim"
ENT.Hit = true

AccessorFunc( ENT, "dmg", "Damage")

function ENT:SetupDataTables()
   self:NetworkVar("Int", 0, "RandomInt") --we need to generate the same random for both client and server
end

function ENT:Initialize()

	if SERVER then self:SetRandomInt(math.random(1,3)) end

	local models = {"PopCan01a.mdl","garbage_metalcan001a.mdl","garbage_metalcan002a.mdl"}

	self:SetModel(self.Model..models[self:GetRandomInt()])

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

end

function ENT:PhysicsCollide( data, phys )
	if self.Hit then
		self.Hit = false
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		if (data.HitEntity:IsNPC() and data.HitEntity:GetCreator():IsPlayer() and data.HitEntity:GetCreator():Team() != self:GetCreator():Team()) or (data.HitEntity:IsPlayer() and  data.HitEntity:Team() != self.Owner:Team())  then
			data.HitEntity:TakeDamage( self:GetDamage() or 10, self:GetCreator(), self)
			local effectdata = EffectData()
			effectdata:SetOrigin( data.HitPos )
			util.Effect( "BloodImpact" , effectdata )
		elseif data.HitEntity:IsWorld() then
			util.Decal( "ExplosiveGunshot", data.HitPos + data.HitNormal, data.HitPos )
		end
		SafeRemoveEntityDelayed( self, 3 )
	end
end