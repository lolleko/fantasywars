GM.Name = "Fantasy Wars"
GM.Author = "N/A"
GM.Email = "N/A"
GM.Website = "N/A"

GM.TeamBased	= true

--include( "modules/team.lua" )
include( "sh_warriors.lua")
include( "player_classes/player_warrior.lua" )
include( "screen_effects.lua" )

TEAM_BLUE = 1

TEAM_RED = 2

FW:CreateList()

function GM:CreateTeams()

	team.SetUp( TEAM_BLUE, "Blue", Color(0,0,255))
	team.SetUp( TEAM_RED, "Red", Color(255,0,0))

	team.SetSpawnPoint( TEAM_BLUE, { "info_player_counterterrorist" } )
	team.SetSpawnPoint( TEAM_RED, { "info_player_terrorist" } )

	/*team.SetLevel( TEAM_BLUE, 1)
	team.SetLevel( TEAM_RED, 1)

	team.UpdateNeededXP( TEAM_BLUE )
	team.UpdateNeededXP( TEAM_RED )

	team.LevelUp(TEAM_BLUE)
	team.LevelUp(TEAM_BLUE)
	team.LevelUp(TEAM_BLUE)
	team.LevelUp(TEAM_BLUE)
	team.LevelUp(TEAM_BLUE)
	team.LevelUp(TEAM_BLUE)

	team.LevelUp(TEAM_RED)
	team.LevelUp(TEAM_RED)
	team.LevelUp(TEAM_RED)
	team.LevelUp(TEAM_RED)
	team.LevelUp(TEAM_RED)
	team.LevelUp(TEAM_RED)*/

end