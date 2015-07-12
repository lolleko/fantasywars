SWEP.Base = "weapon_fwbase"

local PreviewModel = Model("models/combine_turrets/floor_turret.mdl")
SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = ""
SWEP.PreviewModel = PreviewModel
SWEP.PreviewShow = true

SWEP.OnWall = false
SWEP.PlaceRange = 90

function SWEP:DrawHUD()
	if IsValid(self.PreviewProp) then
		local ply = LocalPlayer()
		if ply:GetActiveWeapon() == self then
			self.PreviewProp:SetNoDraw(false)
			self.PreviewProp:SetPos( self:CalculatePos() )
			self.PreviewProp:SetAngles( self:CalculateAngles() )
			if not self:CanPlace() then
				self.PreviewProp:SetColor(Color(128,0,0))
				self.PreviewProp:SetMaterial("models/shiny")
			else
				self.PreviewProp:SetColor(Color(255,255,255))
				self.PreviewProp:SetMaterial("")
			end
		end
	end
end

function SWEP:Initialize()
    self:SetPrimarySlot( self.Primary.Slot ) -- Setup slots here since we want to be able to change them
    self:SetSecondarySlot( self.Secondary.Slot )
	if CLIENT and self.PreviewShow then
		if !IsValid(self.PreviewProp) then
			self.PreviewProp = ents.CreateClientProp(self.PreviewModel)
			self.PreviewProp:SetNoDraw(true)
		end
		if IsValid(self.PreviewProp) then
			self.PreviewProp:SetOwner(self)
			self.PreviewProp:Spawn()
		end
	end
	return true

end

function SWEP:Holster()
	if CLIENT and IsValid(self.PreviewProp) then
		self.PreviewProp:SetNoDraw(true)
	end
	return true
end

function SWEP:CanPlace()
	local trace = self.Owner:GetEyeTrace()

	if !trace.HitWorld then return false end
	if trace.HitPos:Distance(self.Owner:GetPos()) > self.PlaceRange then return false end
	if trace.HitNormal.z < 0.9 and !self.OnWall then return false end

	/*local tracedata = {}
	tracedata.start = trace.HitPos
	tracedata.endpos = trace.HitPos
	tracedata.mins = self.PreviewProp:OBBMins()
	tracedata.maxs = self.PreviewProp:OBBMaxs()
	trace = util.TraceHull( tracedata )

	if trace.Hit then
		return false
    end*/

	return true
end

function SWEP:CalculatePos()
	return self.Owner:GetEyeTrace().HitPos
end

function SWEP:CalculateAngles()
	local ang
	if self.OnWall then
		ang = self.Owner:GetEyeTrace().HitNormal:Angle()
		ang.pitch = ang.pitch + 90
	else
		ang = self.Owner:EyeAngles()
		ang.pitch = 0
		ang.roll = 0
	end
	return ang
end

function SWEP:OnRemove()
	if CLIENT and IsValid(self.PreviewProp) then self.PreviewProp:Remove() end
	return
end