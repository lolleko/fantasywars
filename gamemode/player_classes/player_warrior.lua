DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

PLAYER.WalkSpeed 			= 200
PLAYER.RunSpeed				= 600
PLAYER.JumpPower			= 800
PLAYER.CanUseFlashlight		= false

function PLAYER:Loadout()

	self.Player:RemoveAllAmmo()
	self.Player:SetUpLoadout()

end

player_manager.RegisterClass( "player_warrior", PLAYER, "player_default" )