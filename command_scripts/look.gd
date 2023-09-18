extends Command

func action(_command: Command, player: Player) -> String:
	return player.get_room().describe()
