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
    for _, status in pairs(FW:GetStatusTable()) do
        if status.Show then 
            FWHUD:DrawText( 30, ScrH()/2 + x, status.DisplayName, "treb_small", clrs.whiteText )
            x = x+30
        end
    end
end

function FWHUD:DrawAbilities( ply )
    local defclrs = { red = Color(231,77,60), blue = Color(53,152,219), green = Color(45,204,113), purple = Color(108,113,196), yellow = Color(241,196,16), lightgrey = Color(236,240,241), grey = Color(42,42,42), darkgrey = Color(26,26,26), black = Color(0,0,0)}
    local clrs = {
        outerBackground = {
            background = defclrs.grey
        },
        innerBackground = {
            border = Color(38,106,56),
            background = defclrs.darkgrey
        },
        outerBackgroundActive = {
            background = Color(38,106,56)
        },
        innerBackgroundCd = {
            border = defclrs.blue,
            background = defclrs.darkgrey
        },
        whiteText = Color( 255, 255, 255)
    }

    local weps = ply:GetWeapons()
    local x = 24 --x pos of screen
    local y = ScrH() - 114 --y pos of screen
    local b = 4 --borderwidth
    local k = 64 --ability panel size

    local actwep = ply:GetActiveWeapon()

    for slot,wep in pairs(weps) do --So many dirty little "ifs" (TIDY)

        if !wep:GetSecondarySlot() then
            if actwep == wep then
                self:DrawPanel(x-b,y+k+b*3,k+2*b,16, clrs.outerBackgroundActive)
            else
                self:DrawPanel(x-b,y+k+b*3,k+2*b,16, clrs.outerBackground)
            end
            self:DrawText(x+k/2,y+k+b*3, slot, "treb_small", clrs.whiteText ) 
        end

        if wep:GetSecondarySlot() and wep:GetPrimarySlot() then
            if actwep == wep then
                self:DrawPanel(x-b,y+k+b*3,k*2+6*b,16, clrs.outerBackgroundActive)
            else
                self:DrawPanel(x-b,y+k+b*3,k*2+6*b,16, clrs.outerBackground)
            end
            self:DrawText(x+k+b,y+k+b*3, slot, "treb_small", clrs.whiteText ) 
        end

        if wep:GetPrimarySlot() then
            local bCd = false
            local bClip = false
            if wep:IsPrimaryOnCooldown(true) then clr = clrs.innerBackgroundCd bCd = true else clr = clrs.innerBackground end
            if wep.Primary.Ammo != "none" then bClip = true if wep:Clip1() == 0 then clr = clrs.innerBackgroundCd end end
            self:DrawPanel(x,y,k,k, clr, b)
            if bCd then    
                self:DrawText(x+17,y+14, ply:GetNWInt( "Cooldown."..wep:GetPrimarySlot() ,0), "treb", clrs.whiteText )
            end 
            if bClip then
                self:DrawText(x+17,y+14, wep:Clip1(), "treb", clrs.whiteText )
            end
            x = x+k+b*4
        end

        if wep:GetSecondarySlot() then
            local bCd = false
            local bClip = false
            if wep:IsSecondaryOnCooldown(true) then clr = clrs.innerBackgroundCd bCd = true else clr = clrs.innerBackground end
            if wep.Secondary.Ammo != "none" then bClip = true if wep:Clip2() == 0 then clr = clrs.innerBackgroundCd end end
            self:DrawPanel(x,y,k,k, clr, b)
            if bCd then
                self:DrawText(x+17,y+14, ply:GetNWInt( "Cooldown."..wep:GetSecondarySlot() ,0), "treb", clrs.whiteText )
            end 
            if bClip then
                self:DrawText(x+17,y+14, wep:Clip2(), "treb", clrs.whiteText )
            end
            x = x+k+b*4
        end

        



        /*if not wep.Primary.Slot or not wep.Secondary.Slot then

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

            local cd = ply:GetNWInt( "Cooldown."..cdnumber ,0)
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
                self:DrawPanel(x+6,y+k-6,k*2-18,8, clrs.outerBackgroundActive)
            else
                self:DrawPanel(x+6,y+k-6,k*2-18,8, clrs.outerBackground)
            end

            x = x+8
            y = y+8
            k = k-16

            local cdprim    = ply:GetNWInt( "Cooldown."..wep.Primary.Slot,0)
            local cdsec     = ply:GetNWInt( "Cooldown."..wep.Secondary.Slot,0)

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

        end*/
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

    for w=1,5 do
        surface.DrawCircle( x, y, w, Color(255/w,255/w,255/w,10) )
    end
end

function FantasyHUD()

	local ply = LocalPlayer()
	local hp = ply:Health()
	local hpp = hp/ply:GetMaxHealth()
    local ap = ply:Armor()
    local app = ply:Armor()/300
    local state = FW:GetRoundState() or "State"
    local time = FW:GetTimeInMinutes()
    local roundnumber = FW:GetRoundNumber()
    local bs = team.GetScore(TEAM_BLUE)
    local rs = team.GetScore(TEAM_RED)

    local clrs = {
        hp = {
            background = Color(26,26,26),
            fill = Color( 142, 41, 44)
        },
        whiteText = Color(255,255,255),
        redText = Color(255,0,0,255),
        blueText = Color(0,0,255,255),
        ap = {
            fill = Color(25,25,100),
        },
        panelLightGrey = {
            background = Color(26,26,26,170)
        }
    }

    --FWHUD:DrawPanel( 0, ScrH()-210, 440, 210, clrs.panelLightGrey)

    FWHUD:DrawAbilities( ply ) --wrapped in extra function due to size

    FWHUD:DrawStatus( ply )

    FWHUD:Crosshair()

    --Health Points
    FWHUD:DrawBar( 20, ScrH() - 206, 400, 48, clrs.hp , hpp )
    FWHUD:DrawText( 30, ScrH() - 196, hp, "treb", clrs.whiteText )

    --ArmorBar
    FWHUD:DrawBar( 20, ScrH() - 160, 300, 24, clrs.ap , app )
    if ap > 0 then FWHUD:DrawText( 30, ScrH() - 156, ap, "treb_small", clrs.whiteText ) end

    --Round
    FWHUD:DrawText( 30, ScrH() - 400, time, "treb", clrs.whiteText )
    FWHUD:DrawText( 30, ScrH() - 370, state .." ".. roundnumber , "treb", clrs.whiteText )

    --Score
    FWHUD:DrawText( ScrW()/3+10, 20, bs, "treb", clrs.blueText )
    FWHUD:DrawText( ScrW()/1.5+35, 20, rs, "treb", clrs.redText )

    --RespawnTimer
    --local bRespawn = false
    if ply:GetNWInt("RespawnTimer", 0) > 0 and !ply:Alive() then
       --bRespawn = true
        FWHUD:DrawText( ScrW()/2-170, ScrH()/2, "You can respawn in "..ply:GetNWInt("RespawnTimer", 0).." seconds.", "treb", clrs.whiteText )
    end
    if ply:GetNWInt("RespawnTimer", 0) == 0 and !ply:Alive() then
        FWHUD:DrawText( ScrW()/2-100, ScrH()/2, "Click to respawn...", "treb", clrs.whiteText )
    end

    for id,target in pairs(player.GetAll()) do
        if target:Alive() and ply:Team() == target:Team() and ply != target then

            local targetCenter = target:OBBCenter()
            local targetPos = target:GetPos() + targetCenter
            local targetScreenpos = targetPos:ToScreen()

            surface.DrawCircle( tonumber(targetScreenpos.x), tonumber(targetScreenpos.y), 10, team.GetColor(ply:Team()))
        end
    end

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
*/
end
hook.Add( "HUDPaint", "FantasyHUD", FantasyHUD)

function GM:HUDDrawTargetID()
    local clrs = {
        hp = {
            background = Color(26,26,26),
            fill = Color( 142, 41, 44)
        },
        whiteText = Color(255,255,255),
    }

    local trace = LocalPlayer():GetEyeTrace()

    local hitEntity = trace.Entity

    if hitEntity and hitEntity:IsPlayer() or hitEntity:IsNPC() then
        local clr
        local name
        if hitEntity:IsNPC() then
            name = hitEntity:GetClass()
            if hitEntity:GetOwner() and hitEntity:GetOwner():IsPlayer() then
                clr = team.GetColor(hitEntity:GetOwner():Team())
            else
                clr =  clrs.whiteText
            end
        else
            name = hitEntity:Nick() clr = team.GetColor(hitEntity:Team())
        end
        local hp = hitEntity:Health()
        local hpp = hp/hitEntity:GetMaxHealth()
        FWHUD:DrawBar( ScrW()/2-200, 60, 400, 48, clrs.hp , hpp )
        FWHUD:DrawText( ScrW()/2-190, 20, name, "treb", clr )
        FWHUD:DrawText( ScrW()/2-190, 70, hp, "treb", clrs.whiteText )
    end
end