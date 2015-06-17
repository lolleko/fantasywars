AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType = "grenade"
SWEP.ViewModelFOV = 74
local WorldModel = Model("models/combine_turrets/floor_turret.mdl")
SWEP.ViewModel = "models/weapons/c_Grenade.mdl"
SWEP.WorldModel = WorldModel
SWEP.Slot 				= 1
SWEP.ShowViewModel = false

SWEP.Primary.Damage 		= 20
SWEP.Primary.Cone           = 0.008
SWEP.Primary.Delay 			= 0.4
SWEP.Primary.Automatic 		= false

SWEP.Primary.Slot 			= 1
SWEP.Primary.Level 			= 2

function SWEP:DrawHUD()

	local trace = self.Owner:GetEyeTrace()

	if IsValid(self.viewturret) then
		local ply = LocalPlayer()
		if ply:GetActiveWeapon() == self then
			self.viewturret:SetNoDraw(false)
			self.viewturret:SetPos( self:CalculatePos() )
			self.viewturret:SetAngles( self:CalculateAngles() )
			if not self:CanPlace() then
				self.viewturret:SetColor(Color(128,0,0))
				self.viewturret:SetMaterial("models/shiny")
			else
				self.viewturret:SetColor(Color(255,255,255))
				self.viewturret:SetMaterial("")
			end
		end
	end

end
function SWEP:PrimaryAttack()
	if not self:CanPrimaryAbility() then return end

	if not self:CanPlace() then return end

	self:ShootEffects()
		
	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT
		local cooldown = 10

		if self.Owner:HasStatus("Turret_Placed") then self.Owner:RemoveStatus("Turret_Placed") end

		local turret = ents.Create( "npc_turret_floor" )
		if ( !IsValid( turret ) ) then return end
		turret:SetOwner( self.Owner )
		turret:SetPos( self:CalculatePos() )
		turret:SetAngles( self:CalculateAngles() )
		turret:Spawn()
		local turretphys = turret:GetPhysicsObject()
	    if turretphys:IsValid() then
	       turretphys:EnableMotion(false)
	    end

	    for _,target in pairs(player.GetAll()) do
			if target:Team() != self.Owner:Team() then
				turret:AddEntityRelationship( target, D_HT, 99 )
			else
				turret:AddEntityRelationship( target, D_LI, 99 )
			end
		end
		
		self.Owner:SetStatus({Name = "Turret_Placed", FuncEnd = function() turret:Remove() end, Show = false})

		
		self:StartPrimaryCooldown( cooldown)-- Start cooldown for first "ability"

	end
end

function SWEP:Initialize()
	if CLIENT then
		if !IsValid(self.viewturret) then
			self.viewturret = ents.CreateClientProp(WorldModel)
			self.viewturret:SetNoDraw(true)
		end
		if IsValid(self.viewturret) then
			self.viewturret:SetParent(self)
			self.viewturret:Spawn()
			self:Think()
		end
	end
	return true

end

function SWEP:Holster()
	if CLIENT then
		self.viewturret:SetNoDraw(true)
	end
	return true
end

function SWEP:CanPlace()
	local trace = self.Owner:GetEyeTrace()

	if trace.HitPos:Distance(self.Owner:GetPos()) > 80 then return false end
	if trace.HitNormal.z < 0.9 then return false end

	return true
end

function SWEP:CalculatePos()
	return self.Owner:GetEyeTrace().HitPos
end

function SWEP:CalculateAngles()
	local ang = self.Owner:EyeAngles()
	ang.pitch = 0
	ang.roll = 0
	return ang
end