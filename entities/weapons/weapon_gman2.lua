AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType 			= "magic"
SWEP.AutoSwitchTo       = false
SWEP.AutoSwitchFrom     = false
SWEP.Slot 				= 1

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"

SWEP.Primary.NumShots       = 1
SWEP.Primary.Cone           = 0.005
SWEP.Primary.Delay 			= 0.1

SWEP.Primary.Slot 			= 2
SWEP.Secondary.Slot 		= 3

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

SWEP.ViewModel  = "models/weapons/rainchu/v_nothing.mdl"
SWEP.WorldModel = "models/weapons/rainchu/w_nothing.mdl"

function SWEP:DrawHUD()
	if not self:IsLevelAchieved(6) then return end
	for id,target in pairs(player.GetAll()) do
		if target:Alive() and self.Owner:Nick() != target:Nick() then

			local targetModelHeight = target:OBBMaxs():Length()
			local targetPos = target:GetPos() + Vector(0,0,targetModelHeight/2)
			local targetScreenpos = targetPos:ToScreen()
			
			surface.DrawCircle( tonumber(targetScreenpos.x), tonumber(targetScreenpos.y), 15, Color(200,0,0))
		end
	end
end

function SWEP:PrimaryAttack()
	-- check if required level is achieved if not return
	if not self:IsLevelAchieved(4) then return end
	if self:IsOnCooldown( self.Secondary.Slot ) then return end --check if ability is on cooldow

	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT

		local cooldown = 15

		local trace = self.Owner:GetEyeTrace()

		local hitEntity = trace.Entity

		local wep = self

		local owner = self.Owner

		if trace.Hit and hitEntity:IsPlayer() and hitEntity:Team() != owner:Team() then
			hitEntity:SetStatus(7, "Gman_Mindray", function() hitEntity:SetColor( Color(100, 40, 130 ) ) end, function() hitEntity:SetColor( Color(255, 255, 255 ) ) end, function() hitEntity:TakeDamage( 5 , owner, wep) end )
		else 
			cooldown = cooldown / 5
		end

		self:StartCooldown( self.Primary.Slot ,cooldown)-- Start cooldown for first "ability"

	end
end

function SWEP:SecondaryAttack()
	-- check if required level is achieved if not return
	if not self:IsLevelAchieved(6) then return end
	if self:IsOnCooldown( self.Secondary.Slot ) then return end --check if ability is on cooldow

	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT

		local cooldown = 2

		self:StartCooldown( self.Secondary.Slot ,cooldown)-- Start cooldown for first "ability"

	end
end