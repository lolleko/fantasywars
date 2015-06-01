AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType 			= "ar2"
SWEP.AutoSwitchTo       = false
SWEP.AutoSwitchFrom     = false
SWEP.TracerName 		= "Tracer"
SWEP.Tracer				= 1
SWEP.Primary.Distance 	= 1500

SWEP.Primary.Damage 		= 10
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"

SWEP.Primary.NumShots       = 8
SWEP.Primary.Cone           = 0.085
SWEP.Primary.Delay 			= 1.5

SWEP.Primary.Slot 			= 0
SWEP.Secondary.Slot 		= 1

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_shot_xm1014.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_xm1014.mdl"
SWEP.Primary.Sound			= Sound( "Weapon_XM1014.Single" )

function SWEP:PrimaryAttack()

	if SERVER and self.Owner:HasStatus( "Traitor_Invisible" ) then self.Owner:RemoveStatus( "Traitor_Invisible" ) end
	
	self.Weapon:EmitSound(self.Primary.Sound)

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

function MakeVisible( ply, state )
	if( state ) then
		ply:GetWeapon( "weapon_traitor1" ):SetRenderMode(RENDERMODE_TRANSALPHA)
		ply:GetWeapon( "weapon_traitor1" ):SetColor( Color(0, 0, 0, 255 ) )
		ply:SetColor( Color(0, 0, 0, 255 ) )
		ply:SetWalkSpeed( ply:GetWalkSpeed() - 200 )
		ply:DrawViewModel( true )
	else
		ply:GetWeapon( "weapon_traitor1" ):SetColor( Color(0, 0, 0, 0 ) )
		ply:SetRenderMode(RENDERMODE_TRANSALPHA)
		ply:SetColor( Color(0, 0, 0, 15 ) )
		ply:DrawViewModel( false )
		ply:SetWalkSpeed( ply:GetWalkSpeed() + 200 )
	end
end