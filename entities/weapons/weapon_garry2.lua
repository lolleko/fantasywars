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

	local trace = self.Owner:GetEyeTrace()

	self:ShootEffects()

	self:CustomTracer("tooltracer", trace.HitPos)

	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT

		local cooldown = 7

		local grenade = ents.Create( "prop_physics" )
		if ( !IsValid( grenade ) ) then return end
		grenade:SetModel("models/combine_helicopter/helicopter_bomb01.mdl")
		grenade:SetOwner( self.Owner )
		grenade:SetPos( trace.HitPos + Vector(0,0,15) )
		grenade:Spawn()
		timer.Simple( 1, function()
		local explode = ents.Create("env_explosion")
			explode:SetPos( grenade:GetPos() )
			grenade:Remove()
			explode:SetCreator( self.Owner )
			explode:SetOwner( self.Owner )
			explode:Spawn()
			explode:SetKeyValue("iMagnitude","75")
			explode:Fire("Explode", 0, 0 )
			explode:EmitSound( "ambient/explosions/explode_" .. math.random( 1, 9 ) .. ".wav", 400, 400 )
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
			print(target)
			local status = {}
			status.Name = "Garry_Disarm"
			status.Inflictor = ply
			status.DisplayName = "Disarmed by Garry"
			status.Duration = 2.5
			status.FuncStart = function() target:StripWeapons() end
			status.FuncEnd = function() if target:Alive() then target:SetUpLoadout() end --this will reset ammo on all players... is it a bug or a feature!?
			
			if target:Team() != ply:Team() then target:SetStatus( status ) end end
		end

		self:StartSecondaryCooldown( cooldown )
	end	
end