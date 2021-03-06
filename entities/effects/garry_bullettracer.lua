EFFECT.Mat = Material( "sprites/bluelaser1" )

-- slightly bigger tooltracer

--[[---------------------------------------------------------
   Init( data table )
-----------------------------------------------------------]]
function EFFECT:Init( data )

	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	-- Keep the start and end pos - we're going to interpolate between them
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self.EndPos = data:GetOrigin()
	
	self.Alpha = 255
	self.Life = 0

	self:SetRenderBoundsWS( self.StartPos, self.EndPos )

end

--[[---------------------------------------------------------
   THINK
-----------------------------------------------------------]]
function EFFECT:Think( )

	self.Life = self.Life + FrameTime() * 15 --def: 4
	self.Alpha = 255 * ( 1 - self.Life )
	
	return ( self.Life < 1 )

end

--[[---------------------------------------------------------
   Draw the effect
-----------------------------------------------------------]]
function EFFECT:Render()

	if ( self.Alpha < 1 ) then return end
	
	render.SetMaterial( self.Mat )
	local texcoord = math.Rand( 0, 1 )
	
	local norm = (self.StartPos - self.EndPos) * self.Life

	self.Length = norm:Length()
	
	for i = 1, 5 do
		
		render.DrawBeam( self.StartPos,
					self.EndPos,
					16,
					texcoord,
					texcoord + ((self.StartPos - self.EndPos):Length() / 128),
					Color( 255, 255, 255, 128 * ( 1 - self.Life ) ) )

	end


end