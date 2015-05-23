AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType 			= "normal"
SWEP.AutoSwitchTo       = false
SWEP.AutoSwitchFrom     = false

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

SWEP.ViewModel  = "models/weapons/v_hands.mdl"
SWEP.WorldModel = "models/weapons/c_arms_citizen.mdl"

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType ) -- Allow custom weapon hold type since it's just "pistol" in weapon_base
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetColor( Color(0, 0, 0, 0 ) )
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

		if trace.Hit and hitEntity:IsPlayer() then
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