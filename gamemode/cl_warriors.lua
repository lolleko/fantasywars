FW.Status = {}

net.Receive('FW_SetStatus', function(length)
	FW.Status[net.ReadString()] = net.ReadTable()
	PrintTable(FW.Status)
	print("test")
end)

net.Receive('FW_RemoveStatus', function(length)
	FW.Status[net.ReadString()] = nil
end)

/*net.Receive('FW_SetRoundState', function(length)
	FW.RoundState = net.ReadString()
	FW.Time = 0
	FW:StartClientTimer(net.ReadFloat())
end)*/

function FW:GetStatusTable()
	return self.Status
end

function FW:HasStatus( name )
	if self:GetStatusTable()[name] then
		return true
	end
	return false
end

function FW:StartClientTimer(time)
	print("Timer started?")
	if timer.Exists("FW_RoundTimer") then timer.Destroy("FW_RoundTimer") end
	timer.Create("FW_RoundTimer", 1, time, function() self.Time = self.Time + 1 end )
end

function FW:GetTimeInMinutes()
	return string.ToMinutesSeconds(LocalPlayer():GetNWInt("Time", 0))
end

function FW:GetRoundState()
	return LocalPlayer():GetNWString("RoundState", "Break")
end

function FW:GetRoundNumber()
	return LocalPlayer():GetNWString("RoundNumber", 0)
end