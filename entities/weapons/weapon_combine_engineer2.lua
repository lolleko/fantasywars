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

function SWEP:DrawHUD()

	local trace = self.Owner:GetEyeTrace()
	
	if not self:IsLevelAchieved(4, true) or trace.HitPos:Distance(self.Owner:GetPos()) > 200 then surface.DrawCircle( ScrW()/2, ScrH()/2, 24, Color(255,0,0)) return end
	surface.DrawCircle( ScrW()/2, ScrH()/2, 24, Color(0,255,0))

end
function SWEP:PrimaryAttack()
	-- check if required level is achieved if not return
	if not self:IsLevelAchieved(4) then return end
	if self:IsOnCooldown( self.Primary.Slot ) then return end --check if ability is on cooldow

	local trace = self.Owner:GetEyeTrace()

	if trace.HitPos:Distance(self.Owner:GetPos()) > 200 then self.Owner:PrintMessage( HUD_PRINTTALK, "Can't Place the Turret so far Away.") return end

	self:ShootEffects()
		
	if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT
		local cooldown = 30

		local turret = ents.Create( "npc_turret_floor" )
		if ( !IsValid( turret ) ) then return end
		turret:SetOwner( self.Owner )
		turret:SetPos( trace.HitPos + trace.HitNormal )
		turret:SetAngles(Angle(0, self.Owner:EyeAngles().y , 0))
		turret:Spawn()
		local turretphys = turret:GetPhysicsObject()
	    if turretphys:IsValid() then
	        turretphys:EnableMotion(false)
	    end
		timer.Simple( 20, function()
			turret:Remove()
		end )

		
		self:StartCooldown( self.Primary.Slot ,cooldown)-- Start cooldown for first "ability"

	end
end
