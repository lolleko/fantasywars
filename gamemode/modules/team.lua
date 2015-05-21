module( "team", package.seeall )

local TeamInfo = {}
local DefaultColor = Color(255, 255, 100, 255)

TeamInfo[TEAM_CONNECTING] 	= { Name = "Joining/Connecting", 	Color = DefaultColor, 	Score = 0, 	Joinable = false }
TeamInfo[TEAM_UNASSIGNED] 	= { Name = "Unassigned", 			Color = DefaultColor, 	Score = 0, 	Joinable = false }
TeamInfo[TEAM_SPECTATOR] 	= { Name = "Spectator", 			Color = DefaultColor, 	Score = 0, 	Joinable = true }

--[[------------------------------------------------------------

	OVERWRITTES "lua/includes/modules/team.lua" modified for use with Level and XP
	OTHER ADDONS SHOULD NOT (BUT CAN) BE BROKEN

--------------------------------------------------------------]]

function SetUp( id, name, color, joinable )

	if ( joinable == nil ) then joinable = true end

	TeamInfo[id] = { Name = name, Color = color, Score = 0, Joinable = joinable }

end

function GetLevel( id )

	return GetGlobalInt( "Team."..tostring(id)..".Level", 0 )

end

function SetLevel( id, lvl )

	return SetGlobalInt( "Team."..tostring(id)..".Level", lvl )

end

function GetXP( id )

	return GetGlobalInt( "Team."..tostring(id)..".XP", 0 )

end

function SetXP( id, xp )

	return SetGlobalInt( "Team."..tostring(id)..".XP", xp )

end

function LevelUp( id )

	--called when team has enough xp for levelup

	SetLevel( id, GetLevel( id ) + 1) --add one level
	UpdateNeededXP( id ) --next level requirements are higher

	for _,ply in pairs( player.GetAll() ) do
		if (IsValid(ply) and ply:Team() == id) then
			ply:LevelUpPlayer() --level up/renew all stats for each player
		end
	end

end

function AddXP( id, amount)

	SetXP( id, GetXP( id ) + amount)

end

function DistributeXP( id )
	--addxp
	--TODO better function comeback stuff....
	AddXP( id, 50)
	local neededxp = GetNeededXP( id )

	--check if levelup is available
	if neededxp <= GetXP( id ) then
		SetXP( id, neededxp - GetXP( id ))
		LevelUp( id )
	end
end

function GetNeededXP( id )

	return GetGlobalInt( "Team."..tostring(id)..".NeededXP", 0)

end

function SetNeededXP( id, xp )

	return SetGlobalInt( "Team."..tostring(id)..".NeededXP", xp )

end

function UpdateNeededXP( id )

	SetNeededXP( id, GetConVarNumber( "fw_neededxp" ) * GetLevel( id ) )

end

--default functions from /includes/modules/team.lua

function GetAllTeams()

	return TeamInfo -- copyof?

end

function Valid( id )

	if ( !TeamInfo[id] ) then return false end
	return true

end

function Joinable( id )

	if ( !TeamInfo[id] ) then return false end
	return TeamInfo[id].Joinable

end

function GetSpawnPoint( id )

	if ( !TeamInfo[id] ) then return end
	return TeamInfo[id].SpawnPointTable

end

function GetSpawnPoints( id )

	if ( IsTableOfEntitiesValid( TeamInfo[id].SpawnPoints ) ) then return TeamInfo[id].SpawnPoints end

	local SpawnPointTable = team.GetSpawnPoint( id )
	if ( !SpawnPointTable ) then return end

	TeamInfo[id].SpawnPoints = {}

	for k, entname in pairs( SpawnPointTable ) do

		TeamInfo[id].SpawnPoints = table.Add( TeamInfo[id].SpawnPoints, ents.FindByClass( entname ) )

	end

	return TeamInfo[id].SpawnPoints

end

function SetSpawnPoint( id, ent_name )

	if ( !TeamInfo[id] ) then return end
	if ( !istable( ent_name ) ) then ent_name = {ent_name} end

	TeamInfo[id].SpawnPointTable = ent_name

end

function SetClass( id, classtable )

	if ( !TeamInfo[id] ) then return end
	if ( !istable( classtable ) ) then classtable = {classtable} end

	TeamInfo[id].SelectableClasses = classtable

end

function GetClass( id )

	if ( !TeamInfo[id] ) then return end
	return TeamInfo[id].SelectableClasses

end

function TotalDeaths(index)

	local score = 0
	for id,pl in pairs( player.GetAll() ) do
		if (pl:Team() == index) then
			score = score + pl:Deaths()
		end
	end
	return score

end

function TotalFrags(index)

	local score = 0
	for id,pl in pairs( player.GetAll() ) do
		if (pl:Team() == index) then
			score = score + pl:Frags()
		end
	end
	return score

end

function NumPlayers(index)

	return #GetPlayers(index)

end

function GetPlayers(index)

	local TeamPlayers = {}

	for id,pl in pairs( player.GetAll() ) do
		if (IsValid(pl) and pl:Team() == index) then
			table.insert(TeamPlayers, pl)
		end
	end

	return TeamPlayers

end

function GetScore(index)

	return GetGlobalInt( "Team."..tostring(index)..".Score", 0 )

end

function GetName( index )

	if (!TeamInfo[index]) then return "" end
	return TeamInfo[index].Name

end

function SetColor( index, color )

	if ( !TeamInfo[ index ] ) then return false; end
	TeamInfo[ index ].Color = color

	return color

end

function GetColor( index )

	if (!TeamInfo[index]) then return DefaultColor end
	return table.Copy( TeamInfo[index].Color )

end

function SetScore(index, score)

	return SetGlobalInt( "Team."..tostring(index)..".Score", score )

end

function AddScore(index, score)

	SetScore( index, GetScore( index ) + score )

end

function BestAutoJoinTeam()

	local SmallestTeam = TEAM_UNASSIGNED
	local SmallestPlayers = 1000

	for id, tm in pairs( team.GetAllTeams() ) do

		if ( id != TEAM_SPECTATOR && id != TEAM_UNASSIGNED && id != TEAM_CONNECTING && tm.Joinable ) then

			local PlayerCount = team.NumPlayers( id )
			if ( PlayerCount < SmallestPlayers || (PlayerCount == SmallestPlayers && id < SmallestTeam ) ) then
				SmallestPlayers = PlayerCount
				SmallestTeam = id
			end

		end

	end

	return SmallestTeam

end