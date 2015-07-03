AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = ""
SWEP.HoldType 			= "magic"
SWEP.Slot 				= 1

SWEP.Primary.Slot 			= 2
SWEP.Primary.Level 			= 4

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAbility() then return end

	local trace = self:CompensatedTraceLine()

	self:CustomTracer( "gman_propaganda", trace.HitPos )

	local hitEntity = trace.Entity

	local owner = self.Owner

	if trace.Hit and hitEntity:IsPlayer() and hitEntity:Team() != owner:Team() then
		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetNormal( trace.HitNormal )
		effectdata:SetMagnitude( 8 )
		effectdata:SetScale( 1 )
		effectdata:SetRadius( 16 )
		util.Effect( "Sparks", effectdata )
	end

	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT

		local cooldown = 15

		if trace.Hit and hitEntity:IsPlayer() and hitEntity:Team() != owner:Team() then
			
			local wep = self.Weapon

			local status = {}
			status.Name = "Gman_Mindray"
			status.Inflictor = owner
			status.DisplayName = "Propaganda"
			status.Duration = 7
			status.FuncStart = function() hitEntity:SetColor( Color(100, 40, 130 ) ) end
			status.FuncEnd = function() hitEntity:SetColor( Color(255, 255, 255 ) ) end
			status.FuncTick = function() hitEntity:TakeDamage( 5 , owner, wep) end

			hitEntity:SetStatus( status )
			
		else 
			cooldown = cooldown / 5
		end

		self:StartPrimaryCooldown( cooldown )-- Start cooldown for first "ability"

	end
end
