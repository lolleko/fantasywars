--Round Controller

FW.RoundDuration = GetConVar("fw_roundtime"):GetInt()
FW.BreakDuration = GetConVar("fw_breaktime"):GetInt()
FW.RoundState = FW_WAITING
FW.RoundNumber = 0
FW.MaxRounds = GetConVar("fw_maxrounds"):GetInt()

function FW:CreateRound()
	self.TimeLeft = -1
	self.Break = true
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

	self:BroadcastRoundTime()

	self.TimeLeft = self.TimeLeft - 1
end

function FW:RoundStart()
	for _, ply in pairs( player.GetAll() ) do
		ply:Spawn()
		ply:ResetCooldowns()
	end
	team.SetScore( TEAM_BLUE, 0)
	team.SetScore( TEAM_RED, 0)
	if self.RoundNumber == self.MaxRounds then self:EndGame() end
	self.Break = false
	self.TimeLeft = self.RoundDuration
	self.RoundNumber = self.RoundNumber + 1
	/*net.Start( "FW_SetRoundState" )
		net.WriteString( "Round" )
		net.WriteFloat( self.RoundDuration )
		--net.WriteInt( self.RoundDuration, math.ceil(math.log(self.RoundDuration)/math.log(2)) )
	net.Broadcast()*/
	self:SetRoundState(FW_ROUND)
	self:BroadcastRoundState()
	for _, ply in pairs( player.GetAll() ) do
		ply:SetNWInt( "RoundNumber", self.RoundNumber )
	end
	print("Round started")
end

function FW:RoundEnd()
	self.Break = true
	self.TimeLeft = self.BreakDuration
	self:SetRoundState(FW_BREAK)
	self:BroadcastRoundState()
	print("Round ended")
	print("Break started")
end

function FW:EndGame()
	game.LoadNextMap()
end

function FW:BroadcastRoundState()
	for _, ply in pairs( player.GetAll() ) do
		ply:SetNWString( "RoundState", self.RoundState )
	end
end

function FW:BroadcastRoundTime()
	for _, ply in pairs( player.GetAll() ) do
		ply:SetNWInt( "Time", self.TimeLeft )
	end
end

function FW:SetRoundState( state )
	self.RoundState = state
end

function FW:GetRoundState(state)
	return self.RoundState
end

function FW:StopRound()
	self:SetRoundState(FW_WAITING)
	self:BroadcastRoundState()
	if timer.Exists("FW_RoundTimer") then timer.Destroy("FW_RoundTimer") end
	self.Break = true
	self.TimeLeft = -1
end