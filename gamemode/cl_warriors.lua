WL.Status = {}

net.Receive('FW_SetStatus', function(length)
	WL.Status[net.ReadString()] = net.ReadTable()
	PrintTable(WL.Status)
	print("test")
end)

net.Receive('FW_RemoveStatus', function(length)
	WL.Status[net.ReadString()] = nil
end)

function WL:GetStatusTable()
	return self.Status
end

function WL:HasStatus( name )
	if self:GetStatusTable()[name] then
		return true
	end
	return false
end