local PMENU = {}

function PMENU:Init()

	local Frame = vgui.Create( "DFrame" )
	Frame:SetPos( 50, 50 )
	Frame:SetSize( ScrW() -100 , ScrH()-100 )
	Frame:SetTitle( "Choose your warrior!" )
	Frame:SetVisible( true )
	Frame:SetDraggable( false )
	Frame:ShowCloseButton( true )
	Frame:MakePopup()

	local posx = 20
	local posy = 40

	for _, name in pairs(WL:GetNames()) do
		local PButton = vgui.Create( "DButton", Frame )
		PButton:SetPos( posx, posy )
		PButton:SetText( name )
		PButton.DoClick = function()
			net.Start('FW_SetWarrior')
				net.WriteString(name)
			net.SendToServer()
		end
		posx = posx + 80
	end
end

vgui.Register('DPickMenu', PMENU)