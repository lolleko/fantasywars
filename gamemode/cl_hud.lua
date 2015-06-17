FWHUD = {}
FWHUD.__index = FWHUD

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
	for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudCrosshair"})do
		if name == v then return false end
	end
end
hook.Add("HUDShouldDraw", "HideOurHud", hidehud)

--Nice Tutorial http://facepunch.com/showthread.php?t=1178196

local function color( clr ) return clr.r, clr.g, clr.b, clr.a end --not equal to "Color()"

function FWHUD:DrawStatus( ply )
    local clrs = {
        whiteText = Color(255,255,255,255)
    }
    local x = 0
    for _, status in pairs(WL:GetStatusTable()) do
        if status.Show then 
            FWHUD:DrawText( 30, ScrH()/2 + x, status.DisplayName, "treb_small", clrs.whiteText )
            x = x+30
        end
    end
end

function FWHUD:DrawAbilities( ply )
    local clrs = {
        outerBackground = {
            background = Color( 18, 18, 18, 255)
        },
        innerBackground = {
            border = Color( 71,96,28,255),
            background = Color( 25, 25, 25, 255)
        },
        outerBackgroundActive = {
            background = Color( 67, 67, 67, 255),
        },
        innerBackgroundCd = {
            border = Color( 54,129,166,255),
            background = Color( 25, 25, 25, 255)
        },
        whiteText = Color( 255, 255, 255, 255 )
    }

    local weps = ply:GetWeapons()
    local x = 20
    local y = ScrH() - 98

    local k = 72

    local actwep = ply:GetActiveWeapon()

    for slot,wep in pairs(weps) do --So many dirty little "ifs" (TIDY)

        if not wep.Primary.Slot or not wep.Secondary.Slot then

            local xsave = x
            local ysave = y
            local ksave = k  --SO DIRTY

            if actwep and actwep.Slot == slot-1 then
                self:DrawPanel(x,y,k,k, clrs.outerBackgroundActive)
            else
                self:DrawPanel(x,y,k,k, clrs.outerBackground)
            end

            x = x+8
            y = y+8
            k = k -16

            if not wep.Primary.Slot then cdnumber = wep.Secondary.Slot else cdnumber = wep.Primary.Slot end

            local cd = ply:GetNWInt( ply:Nick()..".Cooldown."..cdnumber ,0)
            if cd == 0 and wep.Primary.Ammo != "none" then cd = wep:Clip1() end

            if not wep.Primary.Slot then
                if wep:IsOnCooldown(wep.Secondary.Slot, true) or wep.Secondary.Ammo != "none" then
                    self:DrawPanel(x,y,k,k, clrs.innerBackgroundCd, 2)
                    self:DrawText(x+17,y+14, cd,  "treb", clrs.whiteText ) 
                else
                    self:DrawPanel(x,y,k,k, clrs.innerBackground, 2)
                end
            else
                if wep:IsOnCooldown(wep.Primary.Slot, true) or wep.Primary.Ammo != "none" then
                    self:DrawPanel(x,y,k,k, clrs.innerBackgroundCd, 2)
                    self:DrawText(x+17,y+14, cd,  "treb", clrs.whiteText ) 
                else
                    self:DrawPanel(x,y,k,k, clrs.innerBackground, 2)
                end
            end

            x = xsave+88
            y = ysave
            k = ksave

        else

            local xsave = x
            local ysave = y
            local ksave = k 

            if actwep and actwep.Slot == slot-1 then
                self:DrawPanel(x,y,k*2-6,k, clrs.outerBackgroundActive)
            else
                self:DrawPanel(x,y,k*2-6,k, clrs.outerBackground)
            end

            x = x+8
            y = y+8
            k = k-16

            local cdprim    = ply:GetNWInt( ply:Nick()..".Cooldown."..wep.Primary.Slot,0)
            local cdsec     = ply:GetNWInt( ply:Nick()..".Cooldown."..wep.Secondary.Slot,0)

            if wep:IsOnCooldown(wep.Primary.Slot, true) then
                self:DrawPanel(x,y,k,k, clrs.innerBackgroundCd ,2)
                self:DrawText(x+17,y+14, cdprim,  "treb", clrs.whiteText ) 
            else
                self:DrawPanel(x,y,k,k, clrs.innerBackground ,2)
            end
            
            x = x+k+10

            if wep:IsOnCooldown(wep.Secondary.Slot, true) then
                self:DrawPanel(x,y,k,k, clrs.innerBackgroundCd ,2)
                self:DrawText(x+17,y+14, cdsec,  "treb", clrs.whiteText ) 
            else
                self:DrawPanel(x,y,k,k, clrs.innerBackground ,2)
            end

            x = xsave+154
            y = ysave
            k = ksave

        end
    end

end

function FWHUD:DrawPanel( x, y, w, h, clrs, brdwidth)

    local b 
    
    if not brdwidth then b = 1 else b = brdwidth end

    if clrs.border then
        surface.SetDrawColor( color( clrs.border ) )

        for i=0, b - 1 do
            surface.DrawOutlinedRect( x + i - b, y + i - b , w + b * 2 - i * 2, h + b * 2 - i * 2 ) --What a mess (TIDY)
        end

    end
 
    surface.SetDrawColor( color( clrs.background ) )
    surface.DrawRect( x, y, w, h )

end

function FWHUD:DrawText(x, y, text, font, clr)
    surface.SetFont( font )
 
    surface.SetTextPos( x, y )
    surface.SetTextColor( color( clr ) )
    surface.DrawText( text )
end

function FWHUD:DrawBar( x, y, w, h, clrs, value )
 
    if clrs.border then
        surface.SetDrawColor( color( clrs.border ) )
        surface.DrawOutlinedRect( x, y, w, h )
    end
    
    x = x + 1
    y = y + 1
    w = w - 2
    h = h - 2
 
    if clrs.background then 
        surface.SetDrawColor( color( clrs.background ) )
        surface.DrawRect( x, y, w, h )
    end
 
    local width = w * math.Clamp( value, 0, 1 )

    surface.SetDrawColor( color( clrs.fill ) )
    surface.DrawRect( x, y, width, h )
 
end

function FWHUD:Crosshair()
    local x = ScrW() / 2
    local y = ScrH() / 2

    surface.DrawCircle( x, y, 1, Color(255,255,255) )
end

function FantasyHUD()

	local ply = LocalPlayer()
	local hp = ply:Health()
	local hpp = ply:Health()/ply:GetMaxHealth()
    local ap = ply:Armor()
    local app = ply:Armor()/300

    local clrs = {
        hp = {
            background = Color( 18, 18, 18, 255),
            fill = Color( 142, 41, 44, 255)
        },
        whiteText = Color(255,255,255,255),
        ap = {
            fill = Color(25,25,100,255),
        },
        panelLightGrey = {
            background = Color(25,25,25,100)
        }
    }

    FWHUD:DrawPanel( 0, ScrH()-210, 440, 210, clrs.panelLightGrey)

    FWHUD:DrawAbilities( ply ) --wrapped in extra function due to size

    FWHUD:DrawStatus( ply )

    FWHUD:Crosshair()

    --Health Points
    FWHUD:DrawBar( 20, ScrH() - 190, 400, 48, clrs.hp , hpp )
    FWHUD:DrawText( 30, ScrH() - 180, hp, "treb", clrs.whiteText )

    --ArmorBar
    FWHUD:DrawBar( 20, ScrH() - 144, 300, 24, clrs.ap , app )
    if ap > 0 then FWHUD:DrawText( 30, ScrH() - 140, ap, "treb_small", clrs.whiteText ) end

	/*
    local bl = team.GetLevel( TEAM_BLUE )
    local rl = team.GetLevel( TEAM_RED )
    local bxp = team.GetXP( 1 )
    local rxp = team.GetXP( 2 )
    local bxpp = team.GetXP( 1 )/team.GetNeededXP( 1 ) * 100
    local rxpp = team.GetXP( 2 )/team.GetNeededXP( 2 ) * 100

    surface.SetTextColor( 12,91,173, 255)
    surface.SetTextPos( ScrW()/3+35, 20 )
    surface.SetFont( "treb" )
    surface.DrawText( bl )

    surface.SetTextColor( 108,0,5, 255)
    surface.SetTextPos( ScrW()/1.5+35, 20 )
    surface.SetFont( "treb" )
    surface.DrawText( rl )

    draw.RoundedBox( 0, ScrW()/3, 50, 100, 20, Color(255,255,255, 100) )
    draw.RoundedBox( 0, ScrW()/3, 50, bxpp, 20, Color(12,91,173) )

    surface.SetTextColor( 0, 0, 0, 255)
    surface.SetTextPos( ScrW()/3+10, 52 )
    surface.SetFont( "treb_small" )
    surface.DrawText( bxp )

    draw.RoundedBox( 0, ScrW()/1.5, 50, 100, 20, Color(255,255,255, 100) )
    draw.RoundedBox( 0, ScrW()/1.5, 50, rxpp, 20, Color(108,0,5) )

    surface.SetTextColor( 0, 0, 0, 255)
    surface.SetTextPos( ScrW()/1.5+10, 52 )
    surface.SetFont( "treb_small" )
    surface.DrawText( rxp )*/

    /*
	for id,target in pairs(player.GetAll()) do
		if target:Alive() and ply:IsLineOfSightClear(target:GetPos()) then

			local targetModelHeight = target:OBBMaxs():Length()
			local targetPos = target:GetPos() + Vector(-50,0,targetModelHeight)
			local targetScreenpos = targetPos:ToScreen()

			local hpp = target:Health()/target:GetMaxHealth() * 100
			
			draw.RoundedBox( 0, tonumber(targetScreenpos.x), tonumber(targetScreenpos.y), 100, 10, Color(0,0,0) )
			draw.RoundedBox( 0, tonumber(targetScreenpos.x), tonumber(targetScreenpos.y), hpp, 10, Color(230,40,40) )
		end
	end*/
end
hook.Add( "HUDPaint", "FantasyHUD", FantasyHUD)




