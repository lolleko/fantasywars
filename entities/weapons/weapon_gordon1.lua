AddCSLuaFile()

SWEP.Base = "weapon_fwbase"

SWEP.HoldType 			= "melee"
SWEP.AutoSwitchTo       = false
SWEP.AutoSwitchFrom     = false
SWEP.TracerName 		= "Tracer"
SWEP.Tracer				= -1

SWEP.Primary.Damage 		= 60
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"

SWEP.Primary.NumShots       = 1
SWEP.Primary.Cone           = 0.01
SWEP.Primary.Delay 			= 0.1

SWEP.Primary.Slot 			= 0
SWEP.Secondary.Slot 		= 1

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

SWEP.Primary.Sound       	= Sound( "Weapon_Crowbar.Single" )

SWEP.ViewModel				= "models/weapons/c_crowbar.mdl"
SWEP.WorldModel				= "models/weapons/w_crowbar.mdl"

function SWEP:PrimaryAttack()
--stolen from weapon_zm_improvised (TTT) mayb i will recode it from scratch at somepoint

   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not IsValid(self.Owner) then return end

   if self.Owner.LagCompensation then -- for some reason not always true
      self.Owner:LagCompensation(true)
   end

   local spos = self.Owner:GetShootPos()
   local sdest = spos + (self.Owner:GetAimVector() * 70)

   local tr_main = util.TraceLine({start=spos, endpos=sdest, filter=self.Owner, mask=MASK_SHOT_HULL})
   local hitEnt = tr_main.Entity

   self.Weapon:EmitSound( self.Primary.Sound )

   if IsValid(hitEnt) or tr_main.HitWorld then
      self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )

      if not (CLIENT and (not IsFirstTimePredicted())) then
         local edata = EffectData()
         edata:SetStart(spos)
         edata:SetOrigin(tr_main.HitPos)
         edata:SetNormal(tr_main.Normal)
         edata:SetSurfaceProp(tr_main.SurfaceProps)
         edata:SetHitBox(tr_main.HitBox)
         --edata:SetDamageType(DMG_CLUB)
         edata:SetEntity(hitEnt)

         if hitEnt:IsPlayer() or hitEnt:GetClass() == "prop_ragdoll" then
            util.Effect("BloodImpact", edata)

            -- does not work on players rah
            --util.Decal("Blood", tr_main.HitPos + tr_main.HitNormal, tr_main.HitPos - tr_main.HitNormal)

            -- do a bullet just to make blood decals work sanely
            -- need to disable lagcomp because firebullets does its own
            self.Owner:LagCompensation(false)
            self.Owner:FireBullets({Num=1, Src=spos, Dir=self.Owner:GetAimVector(), Spread=Vector(0,0,0), Tracer=0, Force=1, Damage=0})
         else
            util.Effect("Impact", edata)
         end
      end
   else
      self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
   end


   if CLIENT then
      -- used to be some shit here
   else -- SERVER

      -- Do another trace that sees nodraw stuff like func_button
      local tr_all = nil
      tr_all = util.TraceLine({start=spos, endpos=sdest, filter=self.Owner})
      
      self.Owner:SetAnimation( PLAYER_ATTACK1 )

      if hitEnt and hitEnt:IsValid() then

         local dmg = DamageInfo()
         dmg:SetDamage(self.Primary.Damage)
         dmg:SetAttacker(self.Owner)
         dmg:SetInflictor(self.Weapon)
         dmg:SetDamageForce(self.Owner:GetAimVector() * 1500)
         dmg:SetDamagePosition(self.Owner:GetPos())
         dmg:SetDamageType(DMG_CLUB)

         hitEnt:DispatchTraceAttack(dmg, spos + (self.Owner:GetAimVector() * 3), sdest)

--         self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )         

--         self.Owner:TraceHullAttack(spos, sdest, Vector(-16,-16,-16), Vector(16,16,16), 30, DMG_CLUB, 11, true)
--         self.Owner:FireBullets({Num=1, Src=spos, Dir=self.Owner:GetAimVector(), Spread=Vector(0,0,0), Tracer=0, Force=1, Damage=20})
      
      else
--         if tr_main.HitWorld then
--            self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
--         else
--            self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
--         end

         -- See if our nodraw trace got the goods
         if tr_all.Entity and tr_all.Entity:IsValid() then
            self:OpenEnt(tr_all.Entity)
         end
      end
   end

   if self.Owner.LagCompensation then
      self.Owner:LagCompensation(false)
   end
end

function SWEP:SecondaryAttack()
	if self:IsOnCooldown( self.Secondary.Slot ) then return end --check if ability is on cooldow

		-- check if required level is achieved if not return
		if not self:IsLevelAchieved(2) then return end

		if SERVER then -- we want the skill and cooldown to be handled by the SERVER not by the CLIENT

			local cooldown = 15

			self.Owner:SetArmor(200)
			self.Owner:SetStatus( 3, "Gordon_ArmorCharge", function() self.Owner:SetWalkSpeed(-1) self.Owner:SetRunSpeed(-1) end , function() self.Owner:SetWalkSpeed( self.Owner:GetWarriorSpeed() ) self.Owner:SetRunSpeed( self.Owner:GetWarriorSpeed() ) end )

			self:StartCooldown( self.Secondary.Slot ,cooldown)-- Start cooldown for first "ability"

		end
end
