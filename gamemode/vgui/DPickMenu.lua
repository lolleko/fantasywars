local PMENU = {}

surface.CreateFont( "Info_Header", {
	font = "Roboto",
	size = 48
} )

surface.CreateFont( "Info_Text", {
	font = "Roboto",
	size = 24
} )

surface.CreateFont( "Button_Normal", {
	font = "Roboto",
	size = 16
} )

surface.CreateFont( "Button_Small", {
	font = "Roboto",
	size = 12
} )

local clrs = { red = Color(231,77,60), blue = Color(53,152,219), green = Color(45,204,113), purple = Color(108,113,196), yellow = Color(241,196,16), lightgrey = Color(236,240,241), grey = Color(42,42,42), darkgrey = Color(26,26,26), black = Color(0,0,0)}

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

	--Pick part
	local Scroll = vgui.Create( "DScrollPanel", self ) //Create the Scroll panel
	Scroll:SetSize( ScrW()/1.5 -30 , ScrH()-40 )
	Scroll:SetPos( 20, 20 )

	local List	= vgui.Create( "DIconLayout", Scroll )
	List:Dock(FILL)
	List:SetSpaceY( 7 )
	List:SetSpaceX( 7 )

	--Info part
	local IPanel = vgui.Create( "DPanel", self)
	IPanel:SetPos( ScrW()/1.5 + 10, 20)
	IPanel:SetSize( ScrW()/3 - 30, ScrH() -110 )
	function IPanel:Paint()
		return
	end

	local IScroll = vgui.Create( "DScrollPanel", IPanel ) //Create the Scroll panel
	IScroll:SetSize( IPanel:GetSize() )

	local IList	= vgui.Create( "DIconLayout", IScroll )
	IList:Dock(FILL)
	IList:SetSpaceY( 20 )

	local NLabel = vgui.Create("DLabel", IList)
	NLabel:SetWide(IPanel:GetWide())
	NLabel:SetFont("Info_Header")
	NLabel:SetTextColor( clrs.red )
	NLabel:SetText("")
	NLabel:SizeToContentsY()

	local LLabel = vgui.Create("DLabel", IList)
	LLabel:SetWide(IPanel:GetWide())
	LLabel:SetFont("Info_Text")
	LLabel:SetTextColor( clrs.lightgrey )
	LLabel:SetWrap(true)
	LLabel:SetText("")

	local SLabel = vgui.Create("DLabel", IList)
	SLabel:SetSize( IPanel:GetWide()/3 , 142 )
	SLabel:SetFont("Info_Text")
	SLabel:SetTextColor( clrs.yellow )
	SLabel:SetText("")

	local SCLabel = vgui.Create("DLabel", IList)
	SCLabel:SetSize( IPanel:GetWide()/1.5 , 142 )
	SCLabel:SetFont("Info_Text")
	SCLabel:SetTextColor( clrs.yellow )
	SCLabel:SetText("")

	local PButton = vgui.Create( "DButton", self )
	PButton:SetPos( ScrW()/1.5 +20, ScrH()-90)
	PButton:SetSize( IPanel:GetWide(), 40 )
	PButton:SetFont("Button_Normal")
	PButton:SetText( "Choose your warrior!" )
	PButton:SetTextColor( clrs.lightgrey )
	PButton:SetDisabled(true )
	function PButton:Paint( w, h)
		draw.RoundedBox( 0, 0, 0, w, h, clrs.grey )
	end

	local SButton = vgui.Create( "DButton", self )
	SButton:SetPos( ScrW()/1.5 +20, ScrH()-40)
	SButton:SetSize( IPanel:GetWide(), 20 )
	SButton:SetFont("Button_Small")
	SButton:SetText( "Spectate" )
	SButton:SetTextColor( clrs.lightgrey )
	SButton.DoClick = function() self:Remove() gui.EnableScreenClicker(false) end
	function SButton:Paint( w, h)
		draw.RoundedBox( 0, 0, 0, w, h, clrs.black )
	end

	for _, warrior in pairs(FW:GetWarriorList()) do

		--create panel for each warrior
		local HPanel = vgui.Create( "DPanel", List )
		HPanel:SetSize( 240, 260 )
		function HPanel:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, clrs.grey )
			draw.RoundedBox( 0, 0, h-5, w, h, clrs.red )
		end
		--HPanel:SetBackgroundColor( clrs.grey )

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

			--set warrior name
			NLabel:SetText(warrior.Name)
			IList:Add(NLabel)

			--set lore
			if warrior.Lore then
				LLabel:SetText(warrior.Lore)
				LLabel:SizeToContentsY()
				IList:Add(LLabel)
			else
				LLabel:SetText("")
				LLabel:SizeToContentsY()
				IList:Add(LLabel)
			end

			--set stats
			SLabel:SetText("Speed:\nJump Power:\nHealth:\nArmor:")
			IList:Add(SLabel)

			SCLabel:SetText(warrior.Speed .."\n"..warrior.JumpPower.."\n"..warrior.Health.."\n"..warrior.Armor)
			IList:Add(SCLabel)

			--weapons

			--update pick button
			function PButton:Paint( w, h)
				draw.RoundedBox( 0, 0, 0, w, h, clrs.black )
			end
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

function PMENU:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, clrs.darkgrey )
end

vgui.Register('DPickMenu', PMENU)