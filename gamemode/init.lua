AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_teampick.lua" )
--AddCSLuaFile( "modules/team.lua")
AddCSLuaFile( "player_classes/player_test.lua" )
AddCSLuaFile( "sh_warriors.lua" )
AddCSLuaFile( "cl_warriors.lua")
AddCSLuaFile( "vgui/DPickMenu.lua" )

include( "shared.lua" )
include( "player.lua" )
include( "player_ext.lua" )
include( "sv_warriors.lua")

--net strings
util.AddNetworkString( "FW_SetWarrior" )
util.AddNetworkString( "FW_SetStatus" )
util.AddNetworkString( "FW_RemoveStatus" ) 
util.AddNetworkString( "FW_SetRoundState" )

net.Receive('FW_SetWarrior', function(length, ply)
	if  ply:IsValid() and ply:IsPlayer() then --add check if already picked
		ply:SetWarrior(net.ReadString())
	end
end)

FW:CreateRound()