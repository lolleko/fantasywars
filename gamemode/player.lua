function GM:PlayerInitialSpawn( ply )

	ply:SetTeam( TEAM_UNASSIGNED )
	
	if ( GAMEMODE.TeamBased ) then
		ply:ConCommand( "gm_showteam" )
		player_manager.SetPlayerClass( ply, "player_test")
	end

end

function GM:PlayerDeath( victim, infl, attacker)

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



