AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_teampick.lua" )
--AddCSLuaFile( "modules/team.lua")
AddCSLuaFile( "screen_effects.lua" )
AddCSLuaFile( "player_classes/player_warrior.lua" )
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

net.Receive('FW_SetWarrior', function(length, ply)
	if  ply:IsValid() and ply:IsPlayer() then --TODO add check if already picked
		ply:SetTeam(team.BestAutoJoinTeam())
		ply:RemoveWarrior()
		if ply:HasWarrior() then
			ply:ClearStatus()
		end
		ply:StripWeapons()
		ply:SetWarrior(net.ReadString())
		ply:Spawn()
	end
end)

FW_WAITING = "Waiting for players!"
FW_ROUND = "Round"
FW_BREAK = "Break"

function GM:Think()
	if FW:GetRoundState() == FW_WAITING and team.NumPlayers(TEAM_RED) > 0 and team.NumPlayers(TEAM_BLUE) > 0 then
		print("Starting Game")
		FW:CreateRound()
	end
	if team.NumPlayers(TEAM_RED) == 0 or team.NumPlayers(TEAM_BLUE) == 0 then FW:StopRound() end
end	