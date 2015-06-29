AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType = "grenade"
SWEP.ViewModelFOV = 74
SWEP.ViewModel = "models/weapons/c_Grenade.mdl"
SWEP.WorldModel = "models/weapons/w_eq_smokegrenade.mdl"
SWEP.Slot 				= 2

SWEP.Primary.Damage 		= 20
SWEP.Primary.Cone           = 0.008
SWEP.Primary.Delay 			= 0.4
SWEP.Primary.Automatic 		= false

SWEP.Primary.Slot 			= 2
SWEP.Primary.Level 			= 4

local ShootSound = Sound( "Metal.SawbladeStick" )

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAbility() then return end

	local cooldown = 10

	local tr = self.Owner:GetEyeTrace()

	local effectdata = EffectData()
	effectdata:SetOrigin( tr.HitPos )
	effectdata:SetNormal( tr.HitNormal )
	effectdata:SetMagnitude( 8 )
	effectdata:SetScale( 1 )
	effectdata:SetRadius( 16 )
	util.Effect( "Sparks", effectdata )
 
	self.Weapon:EmitSound( ShootSound )
	self:ShootEffects()
 
	if !SERVER then return end
 
	if self.Owner:HasStatus("Manhack_Placed") then self.Owner:RemoveStatus("Manhack_Placed") end

	local ent = ents.Create( "npc_manhack" )
	ent:SetPos( tr.HitPos + self.Owner:GetAimVector() * -16 )
	ent:SetAngles( tr.HitNormal:Angle() )
	ent:SetOwner( self.Owner )
	ent:Spawn()

	for _,target in pairs(player.GetAll()) do
		if target:Team() != self.Owner:Team() then
			ent:AddEntityRelationship( target, D_HT, 99 )
		else
			ent:AddEntityRelationship( target, D_LI, 99 )
		end
	end

	self.Owner:SetStatus({Name = "Manhack_Placed", FuncEnd = function() if IsValid(ent) then ent:Remove() end end, Show = false})

	self:StartPrimaryCooldown( cooldown)-- Start cooldown for first "ability"
end
