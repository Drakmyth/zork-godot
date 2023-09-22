extends Command

func action(_command: Command, player: Player) -> String:
	player.description_mode = Player.DescriptionMode.Superbrief
	return "Superbrief descriptions."
