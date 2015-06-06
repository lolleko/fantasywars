function GM:PlayerInitialSpawn( ply )

	ply:SetTeam( TEAM_UNASSIGNED )
	-- reduce number of bullet holes by default
	ply:ConCommand( "r_decals 50" )
	ply:SetCanZoom( false )
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
	team.LevelUp(TEAM_RED)

	if ( GAMEMODE.TeamBased ) then
		ply:ConCommand( "gm_showteam" )
		player_manager.SetPlayerClass( ply, "player_test")
	end

end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )

	// More damage when we're shot in the head
	if ( hitgroup == HITGROUP_HEAD ) then

		dmginfo:ScaleDamage( 1 )

	end

	// Less damage when we're shot in the arms or legs
	if ( hitgroup == HITGROUP_LEFTARM or
		hitgroup == HITGROUP_RIGHTARM or
		hitgroup == HITGROUP_LEFTLEG or
		hitgroup == HITGROUP_RIGHTLEG or
		hitgroup == HITGROUP_GEAR ) then

		dmginfo:ScaleDamage( 1 )

	end

end

function GM:GetFallDamage( ply, speed )
	--returning 0 to disable fall damage
	return ( 0 )
end

function GM:PlayerShouldTakeDamage( ply, victim )
	if ply:IsPlayer() and victim:IsPlayer() then
		if ply:Team() == victim:Team() then
			return false
		end
	elseif ply:IsPlayer() and IsEntity( victim ) then
		if victim:GetOwner():IsPlayer() and ply:Team() == victim:GetOwner():Team() then
			return false
		end
	end
	
	return true
end

function GM:PlayerSetModel(ply)
	--set warrior specific model
   local mdl = ply:GetWarriorModel()
   util.PrecacheModel(mdl)
   ply:SetModel(mdl)
end

function GM:PlayerSpawn( ply )
	--
	-- If the player doesn't have a team in a TeamBased game
	-- then spawn him as a spectator
	--
	if ( GAMEMODE.TeamBased && ( ply:Team() == TEAM_SPECTATOR || ply:Team() == TEAM_UNASSIGNED ) ) then

		GAMEMODE:PlayerSpawnAsSpectator( ply )
		return
	
	end

	-- Stop observer mode
	ply:UnSpectate()

	ply:SetupHands()

	player_manager.OnPlayerSpawn( ply )
	player_manager.RunClass( ply, "Spawn" )

	-- Call item loadout function
	hook.Call( "PlayerLoadout", GAMEMODE, ply )
	
	-- Set player model
	hook.Call( "PlayerSetModel", GAMEMODE, ply )

	ply:SetUpStats()	
end

function GM:PlayerDeath( victim, infl, attacker)

	victim:ClearStatus()

	victim:Freeze(false)
	victim:Spectate(OBS_MODE_IN_EYE)

	local rag_ent = victim.server_ragdoll or victim:GetRagdollEntity()
	victim:SpectateEntity(rag_ent)

	victim:Flashlight(false)

	victim:Extinguish()

	if(attacker:Team() != victim:Team()) then
		team.DistributeXP(attacker:Team())
	end

end



