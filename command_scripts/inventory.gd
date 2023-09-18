extends Command

func action(_command: Command, player: Player) -> String:
	return player.describe_inventory()
