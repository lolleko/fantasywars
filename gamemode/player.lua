function GM:PlayerInitialSpawn( ply )

	ply:SetTeam( TEAM_SPECTATOR )
	-- reduce number of bullet holes by default
	ply:ConCommand( "r_decals 50" )
	ply:SetCanZoom( false )

	player_manager.SetPlayerClass( ply, "player_warrior")
end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )

	-- Disable Headshots include option later maybe
	if ( hitgroup == HITGROUP_HEAD ) then

		dmginfo:ScaleDamage( 1 )

	end

	--Smae dmg everywhere
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
	elseif ply:IsPlayer() and victim:GetCreator() then
		if victim:GetCreator():IsPlayer() and ply:Team() == victim:GetCreator():Team() and ply != victim:GetCreator() then
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
	-- If the player doesn't have a team or a warrior in a TeamBased game
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

	if FW:GetRoundState() == FW_ROUND then
		if attacker:GetOwner():IsPlayer() and attacker:GetOwner():Team() != victim:Team() or attacker:IsPlayer() and attacker:Team() != victim:Team() then
			team.AddScore(attacker:Team(), 1)
		end
	end

	local respawnTime = 5

	victim.NextSpawnTime = CurTime() + respawnTime

	victim.DeathTime = CurTime()

	victim:SetNWInt("RespawnTimer", respawnTime)
	timer.Create(victim:SteamID().."RespawnTimer", 1, respawnTime, function()
		respawnTime = respawnTime -1
		victim:SetNWInt("RespawnTimer", respawnTime)
	end)
end
