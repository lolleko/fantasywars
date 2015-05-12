GM.Name = "Fantasy Wars"
GM.Author = "N/A"
GM.Email = "N/A"
GM.Website = "N/A"

GM.TeamBased	= true

include( "modules/team.lua" )
include( "player_classes/player_test.lua" )

TEAM_BLUE = 1

TEAM_RED = 2

function GM:CreateTeams()

	team.SetUp( TEAM_BLUE, "Blue", Color(0,0,255))
	team.SetUp( TEAM_RED, "Red", Color(255,0,0))

	team.SetLevel( TEAM_BLUE, 1)
	team.SetLevel( TEAM_RED, 1)

	team.UpdateNeededXP( TEAM_BLUE )
	team.UpdateNeededXP( TEAM_RED )

	team.DistributeXP ( TEAM_BLUE )
	team.DistributeXP ( TEAM_BLUE )
	team.DistributeXP ( TEAM_BLUE )
	team.DistributeXP ( TEAM_BLUE )
	team.DistributeXP ( TEAM_BLUE )

end

function GM:Initialize()
	self.BaseClass.Initialize( self )
end
