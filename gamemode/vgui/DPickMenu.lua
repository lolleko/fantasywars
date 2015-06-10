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

	local Scroll = vgui.Create( "DScrollPanel", Frame ) //Create the Scroll panel
	Scroll:SetSize( ScrW() -120 , ScrH()-140 )
	Scroll:SetPos( 10, 30 )

	local List	= vgui.Create( "DIconLayout", Scroll )
	List:SetSize( ScrW() -135 , ScrH()-140 )
	List:SetPos( 0, 0 )
	List:SetSpaceY( 5 )
	List:SetSpaceX( 5 )

	for _, warrior in pairs(WL:GetList()) do

		--create panel for each warrior
		local HPanel = vgui.Create( "DPanel", Frame )
		HPanel:SetSize( 240, 300 )
		HPanel:SetBackgroundColor( Color(0,0,0,50) )

		local icon = vgui.Create( "DModelPanel", HPanel )
		icon:SetPos( 20, 20 )
		icon:SetSize( 200, 200 )
		icon:SetModel( warrior.Model )
		function icon:LayoutEntity( Entity ) return end -- disables default rotation

		local PButton = vgui.Create( "DButton", HPanel )
		PButton:SetPos( 20, 240 )
		PButton:SetSize( 200, 40 )
		PButton:SetText( warrior.Name )
		PButton.DoClick = function()
			net.Start('FW_SetWarrior')
				net.WriteString( warrior.Name )
			net.SendToServer()
			Frame:Close()
		end

	List:Add(HPanel)

	end
end

vgui.Register('DPickMenu', PMENU)