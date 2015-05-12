DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

HealthGain = 10

PLAYER.WalkSpeed 			= 200
PLAYER.RunSpeed				= 600
PLAYER.JumpPower			= 800
PLAYER.CanUseFlashlight		= false
PLAYER.StartHealth 			= 120

function PLAYER:Loadout()

	self.Player:RemoveAllAmmo()

	self.Player:GiveAmmo( 256, 	"Pistol", 		true )
	self.Player:Give( "weapon_pistol" )

end

function PLAYER:Spawn()
	local MaxHealth = PLAYER.StartHealth + (HealthGain * team.GetLevel(self.Player:Team()))
	self.Player:SetMaxHealth(MaxHealth)
	self.Player:SetHealth(MaxHealth)
end

player_manager.RegisterClass( "player_test", PLAYER, "player_default" )