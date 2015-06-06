AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.Slot 				= 1

SWEP.Primary.Slot 			= 2
SWEP.Secondary.Slot 		= 3

SWEP.ViewModel			= "models/weapons/c_toolgun.mdl"
SWEP.WorldModel			= "models/weapons/w_toolgun.mdl"

util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )

function SWEP:PrimaryAttack()
	if not self:IsLevelAchieved(4) then return end 	-- check if required level is achieved if not return
	if self:IsOnCooldown( self.Primary.Slot ) then return end -- check if ability is on cooldow

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

		self:StartCooldown( self.Primary.Slot ,cooldown)
	end

end

function SWEP:SecondaryAttack()
	if not self:IsLevelAchieved(6) then return end 	-- check if required level is achieved if not return
	if self:IsOnCooldown( self.Secondary.Slot ) then return end -- check if ability is on cooldow

	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT

		local cooldown = 60
		local status = {}
		status.Name = "Garry_Disarm"
		status.DisplayName = "Disarmed by Garry"
		status.Duration = 1.5
		status.FuncStart = function() ply:StripWeapons() end
		status.FuncEnd = function() ply:SetUpLoadout() end

		for _,ply in pairs(player.GetAll()) do
			if ply:Team() != self.Owner:Team() then ply:SetStatus( status ) end
		end

		self:StartCooldown( self.Secondary.Slot ,cooldown)
	end	
end