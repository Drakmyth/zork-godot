extends Command

func action(_command: Command, player: Player) -> String:
	return player.look(true)
