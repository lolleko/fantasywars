local PMENU = {}

surface.CreateFont( "Info_Header", {
	font = "Roboto",
	size = 48
} )

surface.CreateFont( "Info_Text", {
	font = "Roboto",
	size = 24
} )

local clrs = {steamdarkblue = Color(18,20,25), steamblue = Color(21,29,42), steamgrey = Color(150,150,150), lightgrey = Color(190,190,190)}

function PMENU:Init()

	gui.EnableScreenClicker(true)

	self:SetSize(ScrW() , ScrH())

	/*local Frame = vgui.Create( "DFrame" )
	Frame:SetPos( 0, 0 )
	Frame:SetSize( ScrW()/1.5 , ScrH())
	Frame:SetTitle( "Choose your warrior!" )
	Frame:SetVisible( true )
	Frame:SetDraggable( false )
	Frame:ShowCloseButton( true )
	Frame:MakePopup()*/

	local Scroll = vgui.Create( "DScrollPanel", self ) //Create the Scroll panel
	Scroll:SetSize( ScrW()/1.5 , ScrH() )
	Scroll:SetPos( 20, 30 )

	local List	= vgui.Create( "DIconLayout", Scroll )
	List:SetSize( ScrW()/1.5 , ScrH() )
	List:SetPos( 0, 0 )
	List:SetSpaceY( 5 )
	List:SetSpaceX( 5 )

	local ScrollInfo = vgui.Create( "DListLayout", self )
	ScrollInfo:SetPos( ScrW()/1.50, 20)
	ScrollInfo:SetSize( ScrW()/3 , ScrH() )

	local InfoName = vgui.Create("DLabel", ScrollInfo)
	InfoName:SetFont("Info_Header")
	InfoName:SetTextColor( clrs.steamgrey )
	InfoName:SetText("")
	ScrollInfo:Add(InfoName)

	local InfoLore = vgui.Create("DLabel", ScrollInfo)
	InfoLore:SetFont("Info_Text")
	InfoLore:SetTextColor( clrs.steamgrey )
	InfoLore:SetText("")
	InfoLore:SetWrap(true)
	InfoLore:SetAutoStretchVertical( true )
	ScrollInfo:Add(InfoLore)

	local InfoStats = vgui.Create("DLabel", ScrollInfo)
	InfoStats:SetFont("Info_Text")
	InfoStats:SetTextColor( clrs.steamgrey )
	InfoStats:SetText("")
	InfoStats:SetWrap(true)
	InfoStats:SetAutoStretchVertical( true )
	ScrollInfo:Add(InfoStats)

	local PButton = vgui.Create( "DButton", self )
	PButton:SetPos( ScrW()/1.5 +20, ScrH()-60)
	PButton:SetSize( ScrW()/3 - 40, 40 )
	PButton:SetText( "CHOOSE YOUR WARRIOR!" )
	PButton:SetDisabled(true )

	
	for _, warrior in pairs(FW:GetWarriorList()) do

		--create panel for each warrior
		local HPanel = vgui.Create( "DPanel", List )
		HPanel:SetSize( 240, 260 )
		HPanel:SetBackgroundColor( clrs.steamblue )

		local icon = vgui.Create( "DModelPanel", HPanel )
		icon:SetSize( 240, 260 )
		icon:SetModel( warrior.Model )
		function icon:LayoutEntity( ent ) 
			return
		end -- disables default rotation

		local WButton = vgui.Create( "DButton", HPanel )
		WButton:SetSize( 240, 260 )
		WButton:SetFont( "Info_Text" )
		WButton:SetTextColor( clrs.lightgrey )
		WButton:SetText( warrior.Name )
		WButton.Paint = function() return end
		WButton.DoClick = function()
			InfoName:SetText( string.upper(warrior.Name) ) 
			InfoName:SizeToContents()

			if warrior.Lore then InfoLore:SetText(warrior.Lore) else InfoLore:SetText("") end
			InfoLore:SetSize(ScrW()/3 - 20, 0)
			
			InfoStats:SetText("Speed: "..warrior.Speed .."\nJump Power: "..warrior.JumpPower.."\nHealth: "..warrior.Health.."\nArmor:"..warrior.Armor)
			InfoStats:SetSize(ScrW()/3 - 20, 0)
			
			PButton:SetText( "Pick!" )
			PButton:SetDisabled( false )
			PButton.DoClick = function() 
				net.Start('FW_SetWarrior')
				net.WriteString( warrior.Name )
				net.SendToServer()
				self:Remove()
				gui.EnableScreenClicker(false)
			end
		end

	List:Add(HPanel)

	end
end

function PMENU:AddInfo(warrior)

	

end

function PMENU:RemoveInfo(warrior)

end

function PMENU:Paint( w, h )
	draw.RoundedBoxEx( 0, 0, 0, w/1.5, h, clrs.steamdarkblue )
	draw.RoundedBoxEx( 0, w/1.5, 0, w/3, h, clrs.steamdarkblue )
end

vgui.Register('DPickMenu', PMENU)