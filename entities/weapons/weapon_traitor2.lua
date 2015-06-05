AddCSLuaFile()

SWEP.Base = "weapon_fwbase"
SWEP.Slot = 1

SWEP.HoldType 			= "slam"

SWEP.Primary.Slot 			= 2
SWEP.Secondary.Slot 		= 3

SWEP.ViewModel			= "models/weapons/cstrike/c_c4.mdl"
SWEP.WorldModel			= "models/weapons/w_c4.mdl"

function SWEP:PrimaryAttack()

	if SERVER and self.Owner:HasStatus( "Traitor_Invisible" ) then self.Owner:RemoveStatus( "Traitor_Invisible" ) end
	
	self:ShootBullet( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, self.Primary.Distance )

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
end

function SWEP:SecondaryAttack()
	if not self:IsLevelAchieved(2) then return end 	-- check if required level is achieved if not return
	if self:IsOnCooldown( self.Secondary.Slot ) then return end -- check if ability is on cooldow

	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT

		local cooldown = 15
		local ply = self.Owner

		ply:SetStatus( 5, "Traitor_Invisible", function() MakeVisible(  ply, false ) end , function() MakeVisible( ply, true ) end )
		ply:SetStatusScreenEffect("Traitor_Invisible", "Blur")

		self:StartCooldown( self.Secondary.Slot ,cooldown)-- Start cooldown for first "ability"

	end
end

function Explode( ply, state )

end