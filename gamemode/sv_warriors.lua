function FW:CreateRound()
	self.RoundDuration = GetConVar("fw_roundtime"):GetInt()
	self.TimeLeft = -1
	self.BreakDuration = GetConVar("fw_breaktime"):GetInt()
	self.Break = true
	self.RoundNumber = 0
	self.MaxRounds = GetConVar("fw_maxrounds"):GetInt()

	timer.Create("FW_RoundTimer", 1, 0, function() self:RoundThink() end )
	self:RoundEnd()
end

function FW:RoundThink()
	if self.TimeLeft == 0 then
		if self.Break then
			self:RoundStart()
		else
			self:RoundEnd()
		end
	end
	for _, ply in pairs( player.GetAll() ) do
		ply:SetNWInt( "Time", self.TimeLeft )
	end

	self.TimeLeft = self.TimeLeft - 1
end

function FW:RoundStart()
	team.SetScore( TEAM_BLUE, 0)
	team.SetScore( TEAM_RED, 0)
	if self.RoundNumber == self.MaxRounds then self:EndGame() end
	self.Break = false
	self.TimeLeft = self.RoundDuration
	print(self.TimeLeft)
	self.RoundNumber = self.RoundNumber + 1
	/*net.Start( "FW_SetRoundState" )
		net.WriteString( "Round" )
		net.WriteFloat( self.RoundDuration )
		--net.WriteInt( self.RoundDuration, math.ceil(math.log(self.RoundDuration)/math.log(2)) )
	net.Broadcast()*/
	for _, ply in pairs( player.GetAll() ) do
		ply:SetNWString( "RoundState", "Round" )
		ply:SetNWInt( "RoundNumber", self.RoundNumber )
	end
	print("Round started")
end

function FW:RoundEnd()
	self.Break = true
	self.TimeLeft = self.BreakDuration
	for _, ply in pairs( player.GetAll() ) do
		ply:SetNWString( "RoundState", "Break" )
	end
	print("Round ended")
	print("Break started")
end

function FW:EndGame()
	game.LoadNextMap()
end


