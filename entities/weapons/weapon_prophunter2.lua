AddCSLuaFile()

SWEP.Base = "weapon_fwbase"
SWEP.Slot = 1

SWEP.HoldType 			= "shotgun"
SWEP.Primary.Damage 		= 1
SWEP.Primary.Delay 			= 1
SWEP.Primary.Damage 		= 10
SWEP.Primary.Automatic 		= true
SWEP.Primary.Cone 			= 0.035
SWEP.Primary.ClipSize       = 5
SWEP.Primary.DefaultClip    = 5
SWEP.Primary.Ammo           = "Pistol"

SWEP.Primary.Slot 			= 2
SWEP.Secondary.Slot 		= 3

SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"

SWEP.Primary.Sound = Sound("Weapon_Shotgun.Single")

function SWEP:Equip( o )
	local wep = self.Weapon

	local status = {}
	status.Name = "Can_Restore"
	status.FuncTick = function() if wep:Clip1() < 5 then wep:SetClip1(wep:Clip1() + 1) end end
	status.Duration = 0
	status.TickDuration = 10

	self.Owner:SetStatus( status )
end

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end

	if SERVER and self.Owner:HasStatus("Prophunter_Disguise") then self.Owner:RemoveStatus("Prophunter_Disguise") end

	self.Weapon:EmitSound(self.Primary.Sound)
	self.Weapon:ShootEffects()

	if SERVER then
		local ent = ents.Create( "prophunter_proj" )
		if ( !IsValid( ent ) ) then return end
		ent:SetPos( self.Owner:GetShootPos() + ( self.Owner:GetAimVector()  ) )
		ent:SetAngles( self.Owner:EyeAngles() )
		ent:SetOwner( self.Owner )
		ent:SetDamage( 40 )
		ent:Spawn()
		local phys = ent:GetPhysicsObject()
		if ( !IsValid( phys ) ) then ent:Remove() return end
		local velocity = self.Owner:GetAimVector()
		velocity = velocity * 2500
		phys:ApplyForceCenter( velocity )

		self:TakePrimaryAmmo(1)
	end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAbility() then return end

	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT

		local cooldown = 15
		local ply = self.Owner
		local wep = self.Weapon

		local status = {}
		status.Name = "Prophunter_Disguise"
		status.DisplayName = "Disguised"
		status.Duration = 3
		status.FuncStart = function() ply:SetModel("models/props_junk/PopCan01a.mdl") ply:SetWarriorSpeed(ply:GetWarriorSpeed()+200) wep:SetRenderMode(RENDERMODE_TRANSALPHA) wep:SetColor( Color(0, 0, 0, 0 ) ) wep:DrawShadow(false) end
		status.FuncEnd = function()  ply:SetModel(ply:GetWarriorModel()) ply:SetWarriorSpeed(ply:GetWarriorSpeed()) wep:SetColor( Color(0, 0, 0, 255 ) ) wep:DrawShadow(true) end

		ply:SetStatus( status )

		self:StartSecondaryCooldown( cooldown)-- Start cooldown for first "ability"

	end

end

function SWEP:Holster()
	if SERVER and self.Owner:HasStatus("Prophunter_Disguise") then self.Owner:RemoveStatus("Prophunter_Disguise") end
	return true
end

function SWEP:OnRemove()
	if SERVER and self.Owner:HasStatus("Can_Restore") then self.Owner:RemoveStatus("Can_Restore") end --it's impoportant to remove any weapon depend status on removal otherwise status will stay and throw errors if player gets disarmed or smthg
end