AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType 			= "ar2"
SWEP.AutoSwitchTo       = false
SWEP.AutoSwitchFrom     = false
SWEP.TracerName 		= "Tracer"
SWEP.Tracer				= 1

SWEP.Primary.Damage 		= 30
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"

SWEP.Primary.NumShots       = 1
SWEP.Primary.Cone           = 0.0075
SWEP.Primary.Delay 			= 0.5

SWEP.Primary.Slot 			= 0
SWEP.Secondary.Slot 		= 1

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

SWEP.Primary.Sound       	= Sound( "Weapon_AK47.Single" )
SWEP.ViewModelFlip 			= true

SWEP.ViewModel  = "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"

function SWEP:PrimaryAttack()

	if SERVER and self.Owner:HasStatus( "Traitor_Invisible" ) then self.Owner:RemoveStatus( "Traitor_Invisible" ) end
	
	self.Weapon:EmitSound(self.Primary.Sound)

	self:ShootBullet( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
end

function SWEP:SecondaryAttack()
	if not self:IsLevelAchieved(2) then return end 	-- check if required level is achieved if not return
	if self:IsOnCooldown( self.Secondary.Slot ) then return end -- check if ability is on cooldow

	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT

		local cooldown = 15

		self.Owner:SetStatus( 5, "Traitor_Invisible", function() self:MakeVisible( false ) end , function() self:MakeVisible( true ) end )

		self:StartCooldown( self.Secondary.Slot ,cooldown)-- Start cooldown for first "ability"

	end
end

function SWEP:MakeVisible( state )
	if( state ) then
		self:SetColor( Color(0, 0, 0, 255 ) )
		self.Owner:SetColor( Color(0, 0, 0, 255 ) )
		self.Owner:SetWalkSpeed( self.Owner:GetWalkSpeed() - 200 )
		self.Owner:DrawViewModel( true )
	else
		self:SetRenderMode(RENDERMODE_TRANSALPHA)
		self:SetColor( Color(0, 0, 0, 0 ) )
		self.Owner:SetRenderMode(RENDERMODE_TRANSALPHA)
		self.Owner:SetColor( Color(0, 0, 0, 15 ) )
		self.Owner:DrawViewModel( false )
		self.Owner:SetWalkSpeed( self.Owner:GetWalkSpeed() + 200 )
	end
end