
require(game.ReplicatedStorage.Common.custom_env)()

local RocketLauncher = ObjectCloner(ReplicatedStorage.RocketLauncher)

local player_rocket = table.hash().setCleanup(function(v) v:Destroy() end)

CharacterAdded:Connect(function(player, character)
	player_rocket.remove(player)

	local rocket = RocketLauncher(player.Backpack)
	rocket:SetAttribute("player", player.UserId)

	player_rocket.add(player, rocket)
end)

PlayerRemoving:Connect(function(player)
	player_rocket.remove(player)
end)
