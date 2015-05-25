GM.Name = "Fantasy Wars"
GM.Author = "N/A"
GM.Email = "N/A"
GM.Website = "N/A"

GM.TeamBased	= true

include( "modules/team.lua" )
include( "sh_warriors.lua")
include( "player_classes/player_test.lua" )
include( "player_ext_sh.lua" )
include( "screen_effects.lua" )

TEAM_BLUE = 1

TEAM_RED = 2

WL:CreateList()

function GM:CreateTeams()

	team.SetUp( TEAM_BLUE, "Blue", Color(0,0,255))
	team.SetUp( TEAM_RED, "Red", Color(255,0,0))

	team.SetLevel( TEAM_BLUE, 1)
	team.SetLevel( TEAM_RED, 1)

	team.UpdateNeededXP( TEAM_BLUE )
	team.UpdateNeededXP( TEAM_RED )

end

function GM:Initialize()
	self.BaseClass.Initialize( self )
end