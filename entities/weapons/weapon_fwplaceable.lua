SWEP.Base = "weapon_fwbase"

local PreviewdModel = Model("models/combine_turrets/floor_turret.mdl")
SWEP.ViewModel = "models/weapons/c_Grenade.mdl"
SWEP.PreviewModel = PreviewModel
SWEP.ShowViewModel = false

SWEP.OnWall = false
SWEP.PlaceRange = 90

function SWEP:DrawHUD()
	if IsValid(self.preview) then
		local ply = LocalPlayer()
		if ply:GetActiveWeapon() == self then
			self.preview:SetNoDraw(false)
			self.preview:SetPos( self:CalculatePos() )
			self.preview:SetAngles( self:CalculateAngles() )
			if not self:CanPlace() then
				self.preview:SetColor(Color(128,0,0))
				self.preview:SetMaterial("models/shiny")
			else
				self.preview:SetColor(Color(255,255,255))
				self.preview:SetMaterial("")
			end
		end
	end

end

function SWEP:Initialize()
	if CLIENT then
		if !IsValid(self.preview) then
			self.preview = ents.CreateClientProp(self.PreviewModel)
			self.preview:SetNoDraw(true)
		end
		if IsValid(self.preview) then
			self.preview:SetParent(self)
			self.preview:Spawn()
			self:Think()
		end
	end
	return true

end

function SWEP:Holster()
	if CLIENT then
		self.preview:SetNoDraw(true)
	end
	return true
end

function SWEP:CanPlace()
	local trace = self.Owner:GetEyeTrace()

	if !trace.HitWorld then return false end
	if trace.HitPos:Distance(self.Owner:GetPos()) > self.PlaceRange then return false end
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

function SWEP:OnRemove()
	if CLIENT then self.preview:Remove() end
	return
end