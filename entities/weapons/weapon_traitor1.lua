AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType 			= "ar2"
SWEP.TracerName 		= "Tracer"
SWEP.Tracer				= 1
SWEP.CSMuzzleFlashes	= true
SWEP.Primary.Distance 	= 1500

SWEP.Primary.Damage 		= 10
SWEP.Primary.NumShots       = 8
SWEP.Primary.Cone           = 0.085
SWEP.Primary.Delay 			= 1.5

SWEP.Primary.Slot 			= 0
SWEP.Secondary.Slot 		= 1
SWEP.Secondary.Level 		= 2

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
	if not self:CanSecondaryAbility() then return end

	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT

		local cooldown = 15
		local ply = self.Owner

		local status = {}
		status.Name = "Traitor_Invisible"
		status.DisplayName = "Traitor Cloak"
		status.Duration = 5
		status.FuncStart = function() MakeVisible(  ply, false ) end
		status.FuncEnd = function() MakeVisible( ply, true ) end
		status.ScreenEffect = "Blur"

		ply:SetStatus( status )

		self:StartSecondaryCooldown( cooldown)-- Start cooldown for first "ability"

	end
end

function MakeVisible( ply, state ) -- TODO make weapon invis too
	if state  then
		ply:GetWeapon( "weapon_traitor1" ):SetRenderMode(RENDERMODE_TRANSALPHA)
		ply:GetWeapon( "weapon_traitor1" ):SetColor( Color(0, 0, 0, 255 ) )
		ply:SetColor( Color(0, 0, 0, 255 ) )
		ply:SetWarriorSpeed( ply:GetWalkSpeed() - 100 )
		ply:DrawViewModel( true )
	else
		ply:GetWeapon( "weapon_traitor1" ):SetRenderMode(RENDERMODE_TRANSALPHA)
		ply:GetWeapon( "weapon_traitor1" ):SetColor( Color(0, 0, 0, 0 ) )
		ply:SetRenderMode(RENDERMODE_TRANSALPHA)
		ply:SetColor( Color(0, 0, 0, 15 ) )
		ply:DrawViewModel( false )
		ply:SetWarriorSpeed( ply:GetWalkSpeed() + 100 )
	end
end

function SWEP:Holster()
	if SERVER and self.Owner:HasStatus("Traitor_Invisible") then self.Owner:RemoveStatus("Traitor_Invisible") end
	return true
end