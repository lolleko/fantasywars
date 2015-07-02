AddCSLuaFile()

SWEP.Base = "weapon_fwbase"
SWEP.Slot            = 2
SWEP.DeploySpeed = 1 -- AWP has higher deploy speed 

SWEP.HoldType        = "ar2"
SWEP.TracerName      = "Tracer"
SWEP.Tracer          = 4
SWEP.Primary.Distance   = 10000
SWEP.CSMuzzleFlashes  = true

SWEP.Primary.Damage     = 50
SWEP.Primary.Cone       = 0.001
SWEP.Primary.Slot          = 2
SWEP.Primary.Level       = 6
SWEP.Primary.Recoil     = 1.7 -- Punch it hard

SWEP.ViewModelFOV    = 64
SWEP.ViewModelFlip   = true
SWEP.ViewModel       = "models/weapons/v_snip_awp.mdl"
SWEP.WorldModel         = "models/weapons/w_snip_awp.mdl"
SWEP.Primary.Sound         = Sound( "Weapon_awp.Single" )

function SWEP:PrimaryAttack()

   if not self:CanPrimaryAbility() then return end

   self.Weapon:EmitSound(self.Primary.Sound)

   self:ShootBullet( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone , self.Primary.Distance, self.Primary.Recoil )

   if SERVER then self:StartPrimaryCooldown( 10 ) end

end

function SWEP:SecondaryAttack()
   if self:GetIronsights() then self:SetIronsights(false) self:SetZoom(false) else self:SetIronsights(true) self:SetZoom(true)end
end

if CLIENT then
   local scope = surface.GetTextureID("sprites/scope")
   function SWEP:DrawHUD()
      if self:GetIronsights() then
         surface.SetDrawColor( 0, 0, 0, 255 )

         local x = ScrW() / 2.0
         local y = ScrH() / 2.0
         local scope_size = ScrH()

         -- crosshair
         surface.DrawLine( x, 0, x, ScrH() )
         surface.DrawLine( 0, y, ScrW(), y )

         -- cover edges
         local sh = scope_size / 2
         local w = (x - sh) + 2
         surface.DrawRect(0, 0, w, scope_size)
         surface.DrawRect(x + sh - 2, 0, w, scope_size)

         -- scope
         surface.SetTexture(scope)
         surface.SetDrawColor(255, 255, 255, 255)

         surface.DrawTexturedRectRotated(x, y+1, scope_size+4, scope_size+4, 0)

      else
         return self.BaseClass.DrawHUD(self)
      end
   end

  function SWEP:AdjustMouseSensitivity()
      return (self:GetIronsights() and 0.2) or nil
   end
end

function SWEP:Holster()
   if SERVER and IsValid(self.Owner) and self.Owner:IsPlayer() then
      self.Owner:SetFOV(0, 0.2)
      self:SetIronsights(false)
   end
   return true 
end


function SWEP:SetZoom(state)
    if CLIENT then
       return
    elseif IsValid(self.Owner) and self.Owner:IsPlayer() then
       if state then
          self.Owner:SetFOV(20, 0.3)
       else
          self.Owner:SetFOV(0, 0.2)
       end
    end
end

function SWEP:SetIronsights(b)

   self.Weapon:SetNetworkedBool("Ironsights", b)

end

function SWEP:GetIronsights()

   return self.Weapon:GetNWBool("Ironsights")

end