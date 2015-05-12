AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_teampick.lua" )
AddCSLuaFile( "modules/team.lua")
AddCSLuaFile( "player_classes/player_test.lua" )

include( "shared.lua" )
include( "player.lua" )

function GM:GetFallDamage( ply, speed )
	return ( 0 )
end

function PlayerCount()
   local playercount = 0

   for _, ply in pairs(player.GetAll()) do
        playercount = playercount + 1
   end
   return playercount
end