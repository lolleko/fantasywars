AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType = "grenade"
SWEP.ViewModelFOV = 74
local WorldModel = Model("models/props_combine/combinethumper002.mdl")
SWEP.ViewModel = "models/weapons/c_Grenade.mdl"
SWEP.WorldModel = WorldModel
SWEP.Slot 				= 3

SWEP.Primary.Damage 		= 20
SWEP.Primary.Cone           = 0.008
SWEP.Primary.Delay 			= 0.4
SWEP.Primary.Automatic 		= false

SWEP.Primary.Slot 			= 3
SWEP.Primary.Level 			= 6

function SWEP:DrawHUD()

	local trace = self.Owner:GetEyeTrace()

	if IsValid(self.viewthumper) then
		local ply = LocalPlayer()
		if ply:GetActiveWeapon() == self then
			self.viewthumper:SetNoDraw(false)
			self.viewthumper:SetPos( self:CalculatePos() )
			self.viewthumper:SetAngles( self:CalculateAngles() )
			if not self:CanPlace() then
				self.viewthumper:SetColor(Color(128,0,0))
				self.viewthumper:SetMaterial("models/shiny")
			else
				self.viewthumper:SetColor(Color(255,255,255))
				self.viewthumper:SetMaterial("")
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

		if self.Owner:HasStatus("Thumper_Placed") then self.Owner:RemoveStatus("Thumper_Placed") end

		local thumper = ents.Create( "prop_physics" )
		if ( !IsValid( thumper ) ) then return end
		thumper:SetModel( "models/props_combine/combinethumper002.mdl" )
		thumper:SetPos( self:CalculatePos() )
		thumper:SetAngles( self:CalculateAngles() )
		thumper:Spawn()
		local thumperphys = thumper:GetPhysicsObject()
	    if thumperphys:IsValid() then
	       thumperphys:EnableMotion(false)
	    end

		self.Owner:SetStatus({Name = "Thumper_Placed", FuncEnd = function() thumper:Remove() end, Show = false})

		
		self:StartPrimaryCooldown( cooldown)-- Start cooldown for first "ability"

	end
end

function SWEP:Initialize()
	if CLIENT then
		if !IsValid(self.viewthumper) then
			self.viewthumper = ents.CreateClientProp(WorldModel)
			self.viewthumper:SetNoDraw(true)
		end
		if IsValid(self.viewthumper) then
			self.viewthumper:SetParent(self)
			self.viewthumper:Spawn()
			self:Think()
		end
	end
	return true

end

function SWEP:Holster()
	if CLIENT then
		self.viewthumper:SetNoDraw(true)
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