AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.Slot 				= 1

SWEP.Primary.Slot 			= 2
SWEP.Primary.Level 			= 4
SWEP.Secondary.Slot 		= 3
SWEP.Secondary.Level 		= 6

SWEP.ViewModel			= "models/weapons/c_toolgun.mdl"
SWEP.WorldModel			= "models/weapons/w_toolgun.mdl"

util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAbility() then return end

	self:ShootEffects()

	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT

		local trace = self.Owner:GetEyeTrace()

		local cooldown = 7

		self:ShootEffects() 

		self:CustomTracer("tooltracer", trace.HitPos)

		local grenade = ents.Create( "grenade_helicopter" )
		if ( !IsValid( grenade ) ) then return end
		grenade:SetOwner( self.Owner )
		grenade:SetPos( trace.HitPos + Vector(0,0,15) )
		grenade:Spawn()
		timer.Simple( 1, function()
		local explode = ents.Create("env_explosion")
			explode:SetPos( grenade:GetPos() )
			grenade:Remove()
			explode:SetOwner( self.Owner )
			explode:Spawn()
			explode:SetKeyValue("iMagnitude","75")
			explode:Fire("Explode", 0, 0 )
			explode:EmitSound("weapon_AWP.Single", 400, 400 )
		end)

		self:StartPrimaryCooldown( cooldown )
	end

end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAbility() then return end

	self:ShootEffects()

	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT

		local ply = self.Owner
		local cooldown = 60

		for _,target in pairs(player.GetAll()) do

			local status = {}
			status.Name = "Garry_Disarm"
			status.DisplayName = "Disarmed by Garry"
			status.Duration = 1.5
			status.FuncStart = function() target:StripWeapons() end
			status.FuncEnd = function() target:SetUpLoadout() end
			
			if target:Team() != ply:Team() then target:SetStatus( status ) end
		end

		self:StartSecondaryCooldown( cooldown )
	end	
end