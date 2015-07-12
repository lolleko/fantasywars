AddCSLuaFile()

SWEP.Base = "weapon_fwbase"
SWEP.Slot = 5

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

	local hitEntity = trace.Entity

	local ply = self.Owner

	local wep

	if trace.Hit and IsValid(hitEntity) and (hitEntity:IsPlayer() and hitEntity:Team() != self.Owner:Team()) then

		local wepclass = hitEntity:GetActiveWeapon():GetClass()
		if SERVER then
			ply:Give(wepclass)
			wep = ply:GetWeapon(wepclass)
			wep:SetPrimarySlot(2)
			wep:SetSecondarySlot(3)
		end

		if CLIENT then
			wep = ply:GetWeapon(wepclass)
			if wep then
				wep:SetPrimarySlot(2)
				wep:SetSecondarySlot(3)
			end
		end
	end

	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT
		local cooldown  = 20
		if trace.Hit and IsValid(hitEntity) and (hitEntity:IsPlayer() and hitEntity:Team() != self.Owner:Team()) then
			if self.Owner:HasStatus("Weapon_Steal") then self.Owner:RemoveStatus("Weapon_Steal") end

			local status = {}
			status.Name = "Weapon_steal"
			status.Inflictor = ply
			status.DisplayName = "stolen"
			status.Duration = 30
			status.FuncEnd = function()
									ply:StripWeapon(wepclass)
									ply:ResetCooldowns()
							end

			self.Owner:SetStatus(status)
		else
			cooldown = cooldown / 5
		end
		
		self:StartSecondaryCooldown( cooldown )
	end
end
