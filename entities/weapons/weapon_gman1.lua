AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.HoldType 			= "normal"
SWEP.Primary.Damage 		= 0.0075 --percantage 1%

SWEP.Primary.Slot 			= 0
SWEP.Secondary.Slot 		= 1
SWEP.Secondary.Level 		= 2

local gmantracer = 0 

function SWEP:Think()
	--laser effect (modified green laser)
	local trace = self.Owner:GetEyeTrace()

	local hitEntity = trace.Entity

	if trace.Hit and hitEntity:IsPlayer() and hitEntity:Team() != self.Owner:Team() then
		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )

		if CLIENT then
			effectdata:SetStart( self.Owner:GetShootPos() - Vector(0,0,20))
		elseif SERVER then
			effectdata:SetStart( self.Owner:GetShootPos())
		end

		effectdata:SetAttachment( 1 )
		effectdata:SetEntity( self.Weapon )
		if gmantracer == 5 then
			util.Effect( "gman_primary", effectdata )
			gmantracer = 0
		end
		gmantracer = gmantracer + 1

		if SERVER then 
			hitEntity:TakeDamage( hitEntity:GetMaxHealth() * self.Primary.Damage , self.Owner, self) --percentage base dmg
		end
	end
end

function SWEP:PrimaryAttack()
	return 
end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAbility() then return end

	--laser effect (modified green laser)
	local trace = self.Owner:GetEyeTrace()

	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT

		local cooldown = 2

		--Shittiest stuck prevention ever (maybe redo at some point) 
		--NOTE TO ME Redo it with normalized vectors
		if trace.HitPos:Distance(trace.StartPos) > 3000 then
			
			self.Owner:PrintMessage( HUD_PRINTTALK, "Can't Teleport so far.")

			cooldown = 0

		elseif trace.HitSky or trace.HitPos:Distance(trace.StartPos) < 100 then
			
			self.Owner:PrintMessage( HUD_PRINTTALK, "Can't teleport there.")

			cooldown = 0

		else 

			self.Owner:SetPos(trace.HitPos + (trace.HitNormal * 25) )

		end

		self:StartSecondaryCooldown( cooldown)-- Start cooldown for first "ability"

	end
end