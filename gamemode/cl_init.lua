include( "shared.lua" )
include( "cl_teampick.lua" )

surface.CreateFont( "treb",
     {
                    font    = "Trebuchet24", -- Not file name, font name
                    size    = 32,
                    weight  = 400,
                    antialias = true,
                    shadow = false
            })

surface.CreateFont( "treb_small",
     {
                    font    = "Trebuchet24", -- Not file name, font name
                    size    = 16,
                    weight  = 400,
                    antialias = true,
                    shadow = false
            })

function hidehud(name) -- Removing the default HUD
	for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", })do
		if name == v then return false end
	end
end
hook.Add("HUDShouldDraw", "HideOurHud:D", hidehud)

function FantasyHUD()
	local ply = LocalPlayer()
	local hp = ply:Health()
	local hpp = ply:Health()/ply:GetMaxHealth() * 400
	local bl = team.GetLevel( 1 )
    local rl = team.GetLevel( 2 )
    local bxp = team.GetXP( 1 )
    local rxp = team.GetXP( 2 )
    local bxpp = team.GetXP( 1 )/team.GetNeededXP( 1 ) * 100
    local rxpp = team.GetXP( 2 )/team.GetNeededXP( 2 ) * 100

	draw.RoundedBox( 0, 50, ScrH() - 200, 400, 40, Color(0,0,0) )
	draw.RoundedBox( 0, 50, ScrH() - 200, hpp, 40, Color(230,40,40) )

	surface.SetTextColor( 255, 255, 255, 255)
    surface.SetTextPos( 60, ScrH() - 195 )
    surface.SetFont( "treb" )
    surface.DrawText( hp )

	surface.SetTextColor( 0, 0, 255, 255)
    surface.SetTextPos( ScrW()/3, 20 )
    surface.SetFont( "treb" )
    surface.DrawText( bl )

    surface.SetTextColor( 255, 0, 0, 255)
    surface.SetTextPos( ScrW()/1.5, 20 )
    surface.SetFont( "treb" )
    surface.DrawText( rl )

    draw.RoundedBox( 0, ScrW()/3, 50, 100, 20, Color(0,0,0) )
    draw.RoundedBox( 0, ScrW()/3, 50, bxpp, 20, Color(0,0,255) )

    surface.SetTextColor( 255, 255, 255, 255)
    surface.SetTextPos( ScrW()/3+10, 50 )
    surface.SetFont( "treb_small" )
    surface.DrawText( bxp )

    draw.RoundedBox( 0, ScrW()/1.5, 50, 100, 20, Color(0,0,0) )
    draw.RoundedBox( 0, ScrW()/1.5, 50, rxpp, 20, Color(0,0,255) )

    surface.SetTextColor( 255, 255, 255, 255)
    surface.SetTextPos( ScrW()/1.5+10, 50 )
    surface.SetFont( "treb_small" )
    surface.DrawText( rxp )

end
hook.Add( "HUDPaint", "FantasyHUD", FantasyHUD)
