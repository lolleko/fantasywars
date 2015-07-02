AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType 			= "slam"
SWEP.Tracer				= 1
SWEP.Slot 				= 1

SWEP.Primary.Slot 			= 2

SWEP.Primary.Sound = Sound( "Weapon_357.Single" )

SWEP.ViewModel  = "models/weapons/c_medkit.mdl"
SWEP.WorldModel = "models/weapons/w_medkit.mdl"

function SWEP:Think()
	if SERVER and self:LessTicks() then
		local healAmount = 3
		local dmgAmount = 3
		for _,target in pairs(player.GetAll()) do
			if target:GetPos():Distance(self.Owner:GetPos()) < 400 then
				if target:Team() == self.Owner:Team() then 
					target:SetStatus({ Name = "Medic_Heal_Aura", Inflictor = self.Owner, DisplayName = "You are healed by a nearby Medic.", Duration = 1, FuncStart = function() if target:Health()+healAmount < target:GetMaxHealth() then target:SetHealth(target:Health()+healAmount) else target:SetHealth(target:GetMaxHealth() - target:Health()) end end })
				else
					target:SetStatus({ Name = "Medic_Damage_Aura", Inflictor = self.Owner, DisplayName = "You are damaged by a nearby Medic.", Duration = 1, FuncStart = function() if target:Health() - dmgAmount > 0 then target:SetHealth(target:Health() - dmgAmount) else target:SetHealth(1) end end })
				end
			end
		end
	end
end

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAbility() then return end

	local trace = self:CompensatedTraceLine(400)
	local hitEntity = trace.Entity

	if trace.Hit and hitEntity:IsPlayer() and hitEntity:Team() == self.Owner:Team() then

		self:ShootEffects()

		if SERVER then --we want the status and cd handeled by the server trace is shared for proper animations

			local cooldown = 20
			local healAmount = 25
			local ply = self.Owner

			--Set a status to notify the healed person
			local status = {}
			status.Name = "Medic_Heal"
			status.Inflictor = ply
			status.DisplayName = "You have been healed."
			status.Duration = 1
			status.FuncStart = 	function() if hitEntity:Health() + healAmount > hitEntity:GetMaxHealth() then hitEntity:SetHealth(hitEntity:GetMaxHealth()) else hitEntity:SetHealth(hitEntity:Health() + healAmount) end end

			hitEntity:SetStatus(status)

			self:StartPrimaryCooldown( cooldown )

		end
	else

		self.Owner:PrintMessage( HUD_PRINTTALK, "No ally found to heal!")

	end

end

function SWEP:SecondaryAttack()
	--TODO place medkit
end
