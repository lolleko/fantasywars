AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType 			= "normal"
SWEP.AutoSwitchTo       = false
SWEP.AutoSwitchFrom     = false
SWEP.TracerName 		= "garry_bullettracer"
SWEP.Tracer				= 2

SWEP.Primary.Damage 		= 0.5
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"

SWEP.Primary.NumShots       = 1
SWEP.Primary.Cone           = 0.005
SWEP.Primary.Delay 			= 0.1

SWEP.Primary.Slot 			= 0
SWEP.Secondary.Slot 		= 1

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

SWEP.ViewModel  = "models/weapons/rainchu/v_nothing.mdl"
SWEP.WorldModel = "models/weapons/rainchu/w_nothing.mdl"

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
		if gmantracer == 7 then
			util.Effect( "gman_primary", effectdata )
			gmantracer = 0
		end
		gmantracer = gmantracer + 1
		if SERVER then 
			hitEntity:TakeDamage( self.Primary.Damage , self.Owner, self)
		end
	end
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
	-- check if required level is achieved if not return
	if not self:IsLevelAchieved(2) then return end
	if self:IsOnCooldown( self.Secondary.Slot ) then return end --check if ability is on cooldow

	--laser effect (modified green laser)
	local trace = self.Owner:GetEyeTrace()

	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT

		local cooldown = 2

		--Shittiest stuck prevention ever (maybe redo at some point)
		if trace.HitPos:Distance(trace.StartPos) > 3000 then
			
			self.Owner:PrintMessage( HUD_PRINTTALK, "Can't Teleport so far.")

			cooldown = 0

		elseif trace.HitSky or trace.HitPos:Distance(trace.StartPos) < 100 then
			
			self.Owner:PrintMessage( HUD_PRINTTALK, "Can't teleport there.")

			cooldown = 0

		else 

			local ratio = 0.993

			if trace.HitPos:Distance( trace.StartPos ) < 500 then ratio = 0.75
			elseif trace.HitPos:Distance(trace.StartPos) <1000 then ratio = 0.94
			elseif trace.HitPos:Distance(trace.StartPos) <2000 then ratio = 0.945
			elseif trace.HitPos:Distance(trace.StartPos) <3000 then ratio = 0.981 end
			

			self.Owner:SetPos(((trace.HitPos - trace.StartPos)*ratio) + trace.StartPos)

		end

		self:StartCooldown( self.Secondary.Slot ,cooldown)-- Start cooldown for first "ability"

	end
end