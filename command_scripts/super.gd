extends Command

func action(_command: Command, _player: Player) -> String:
	System.description_mode = System.DescriptionMode.Superbrief
	return "Superbrief descriptions."
