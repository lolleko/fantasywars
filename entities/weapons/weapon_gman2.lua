AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType 			= "magic"
SWEP.Slot 				= 1

SWEP.Primary.Slot 			= 2
SWEP.Secondary.Slot 		= 3


function SWEP:DrawHUD()
	if not self:IsLevelAchieved(6, true) then return end
	for id,target in pairs(player.GetAll()) do
		if target:Alive() and self.Owner:Nick() != target:Nick() then

			local targetModelHeight = target:OBBMaxs():Length()
			local targetPos = target:GetPos() + Vector(0,0,targetModelHeight/2)
			local targetScreenpos = targetPos:ToScreen()
			
			surface.SetDrawColor( 200, 0, 0)
			surface.DrawLine( ScrW()/3, ScrH()/2, tonumber(targetScreenpos.x), tonumber(targetScreenpos.y))

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

		local cooldown = 1

		self:StartCooldown( self.Secondary.Slot ,cooldown)-- Start cooldown for first "ability"

	end
end