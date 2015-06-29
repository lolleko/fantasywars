include( "shared.lua" )
include( "vgui/DPickMenu.lua")
include( "cl_hud.lua")
include( "cl_warriors.lua")

vgui.Create('DPickMenu')

concommand.Add( "fw_pick", function()
	vgui.Create('DPickMenu')
end )
