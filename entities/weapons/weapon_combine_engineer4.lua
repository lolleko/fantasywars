AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType = "grenade"
SWEP.ViewModelFOV = 74
SWEP.ViewModel = "models/weapons/c_Grenade.mdl"
SWEP.WorldModel = "models/weapons/w_eq_smokegrenade.mdl"
SWEP.Slot 				= 3

SWEP.Primary.Damage 		= 20
SWEP.Primary.Cone           = 0.008
SWEP.Primary.Delay 			= 0.4
SWEP.Primary.Automatic 		= false

SWEP.Primary.Slot 			= 3
SWEP.Primary.Level 			= 6

function SWEP:DrawHUD()

	local trace = self.Owner:GetEyeTrace()
	
	if not self:IsLevelAchieved(4, true) or trace.HitPos:Distance(self.Owner:GetPos()) > 200 or trace.HitPos:Distance(self.Owner:GetPos()) < 30 then surface.DrawCircle( ScrW()/2, ScrH()/2, 24, Color(255,0,0)) return end
	surface.DrawCircle( ScrW()/2, ScrH()/2, 24, Color(0,255,0))

end
function SWEP:PrimaryAttack()
	if not self:CanPrimaryAbility() then return end

	local trace = self.Owner:GetEyeTrace()

	if trace.HitPos:Distance(self.Owner:GetPos()) > 200 then self.Owner:PrintMessage( HUD_PRINTTALK, "Can't place the Thumper so far away.") return end
	if trace.HitPos:Distance(self.Owner:GetPos()) < 30 then self.Owner:PrintMessage( HUD_PRINTTALK, "Can't place the Thumper so close.") return end
	if trace.HitNormal == Vector(0,1,0) or trace.HitNormal == Vector(0,-1,0) or trace.HitNormal == Vector(1,0,0) or trace.HitNormal == Vector(-1,0,0) then self.Owner:PrintMessage( HUD_PRINTTALK, "Can't place Thumper on walls.") return end

	self:ShootEffects()
		
	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT
		local cooldown = 10

		if self.Owner:HasStatus("Thumper_Placed") then self.Owner:RemoveStatus("Thumper_Placed") end

		local thumper = ents.Create( "prop_physics" )
		if ( !IsValid( thumper ) ) then return end
		thumper:SetModel( "models/props_combine/combinethumper002.mdl" )
		thumper:SetPos( trace.HitPos + trace.HitNormal )
		local ang = trace.HitNormal:Angle()
       	ang:RotateAroundAxis(ang:Right(), -90)
       	ang:RotateAroundAxis(ang:Up(), self.Owner:EyeAngles().y)
		thumper:SetAngles(ang)
		thumper:Spawn()
		local thumperphys = thumper:GetPhysicsObject()
	    if thumperphys:IsValid() then
	    	thumperphys:EnableMotion(false)
	    end
		
		self.Owner:SetStatus({Name = "Thumper_Placed", FuncEnd = function() thumper:Remove() end})

		
		self:StartPrimaryCooldown( cooldown)-- Start cooldown for first "ability"

	end
end
