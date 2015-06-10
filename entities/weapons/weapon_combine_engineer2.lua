AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType = "grenade"
SWEP.ViewModelFOV = 74
SWEP.ViewModel = "models/weapons/c_Grenade.mdl"
SWEP.WorldModel = "models/weapons/w_eq_smokegrenade.mdl"
SWEP.Slot 				= 1

SWEP.Primary.Damage 		= 20
SWEP.Primary.Cone           = 0.008
SWEP.Primary.Delay 			= 0.4
SWEP.Primary.Automatic 		= false

SWEP.Primary.Slot 			= 1
SWEP.Primary.Level 			= 2

function SWEP:DrawHUD()

	local trace = self.Owner:GetEyeTrace()
	
	if not self:IsLevelAchieved(4, true) or trace.HitPos:Distance(self.Owner:GetPos()) > 200 then surface.DrawCircle( ScrW()/2, ScrH()/2, 24, Color(255,0,0)) return end
	surface.DrawCircle( ScrW()/2, ScrH()/2, 24, Color(0,255,0))

end
function SWEP:PrimaryAttack()
	if not self:CanPrimaryAbility() then return end

	local trace = self.Owner:GetEyeTrace()

	if trace.HitPos:Distance(self.Owner:GetPos()) > 200 then self.Owner:PrintMessage( HUD_PRINTTALK, "Can't Place the Turret so far away.") return end
	if trace.HitNormal == Vector(0,1,0) or trace.HitNormal == Vector(0,-1,0) or trace.HitNormal == Vector(1,0,0) or trace.HitNormal == Vector(-1,0,0) then self.Owner:PrintMessage( HUD_PRINTTALK, "Can't Place Turret on walls") return end

	self:ShootEffects()
		
	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT
		local cooldown = 10

		if self.Owner:HasStatus("Turret_Placed") then self.Owner:RemoveStatus("Turret_Placed") end

		local turret = ents.Create( "npc_turret_floor" )
		if ( !IsValid( turret ) ) then return end
		turret:SetOwner( self.Owner )
		turret:SetPos( trace.HitPos + trace.HitNormal )
        local ang = trace.HitNormal:Angle()
       	ang:RotateAroundAxis(ang:Right(), -90)
       	ang:RotateAroundAxis(ang:Up(), self.Owner:EyeAngles().y)
		turret:SetAngles(ang)
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
		
		self.Owner:SetStatus({Name = "Turret_Placed", FuncEnd = function() turret:Remove() end})

		
		self:StartPrimaryCooldown( cooldown)-- Start cooldown for first "ability"

	end
end
