FW = {}
FW.__index = FW

FW.Warriors = {}

function FW:CreateList()
	local wardata = file.Find('fantasywars/gamemode/warriors/*', 'LUA')

	--Get table of all warriors stored in "warriros/" 
	for _, warrior in pairs(wardata) do
			AddCSLuaFile( "warriors/"..warrior )
			WARRIOR = {}

			include( "warriors/"..warrior )

			self.Warriors[WARRIOR.Name] = WARRIOR
	end

	print("Loaded following Warriors:")
	PrintTable(self.Warriors)

end

function FW:GetWarrior( name )
	return self.Warriors[name]
end

function FW:GetWarriorList()
	return self.Warriors
end

function FW:GetNames()
	local wlist = {}
	for _, warrior in pairs(self.Warriors) do
		wlist[#wlist+1] = warrior.Name
	end

	return wlist	
end