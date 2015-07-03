AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType 			= "crossbow"
SWEP.Tracer				= 1
SWEP.CSMuzzleFlashes	= true

SWEP.Primary.Damage 		= 5
SWEP.Primary.Cone           = 0.08
SWEP.Primary.Delay 			= 0.1
SWEP.Primary.Automatic 		= true

SWEP.Primary.Slot 			= 0
SWEP.Secondary.Slot 		= 1

SWEP.Primary.Sound			= Sound("Weapon_m249.Single")

SWEP.ViewModel			= "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel			= "models/weapons/w_mach_m249para.mdl"

function SWEP:PrimaryAttack()
	self.Weapon:EmitSound(self.Primary.Sound)

	self:ShootBullet( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, 10000, 1 )

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAbility() then return end

	local trace = self:CompensatedTraceLine()

	self:CustomTracer( "garry_stuntracer", trace.HitPos )

	self:ShootEffects()
		
	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT
		local cooldown  = 10
		local hitEntity = trace.Entity
		if trace.Hit and IsValid(hitEntity) and (hitEntity:IsPlayer() and hitEntity:Team() != self.Owner:Team()) then

			local ply = self.Owner

			if self.Owner:HasStatus("Weapon_Steal") then self.Owner:RemoveStatus("Weapon_Steal") end

			local status = {}
			status.Name = "Weapon_steal"
			status.Inflictor = ply
			status.DisplayName = "stolen"
			status.Duration = 20
			status.FuncStart = 	function()
									ply:ResetCooldowns()
									ply:StripWeapons() 
									local wepclass = hitEntity:GetActiveWeapon():GetClass()
									ply:Give(wepclass)
								end
			status.FuncEnd = function() ply:StripWeapons() ply:SetUpLoadout() end

			self.Owner:SetStatus(status)
		else
			cooldown = cooldown/5 -- if target not hit reset to a lower cooldown
		end

		self:StartSecondaryCooldown( cooldown )-- Start cooldown for first "ability"

	end
end
