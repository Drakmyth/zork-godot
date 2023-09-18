extends Command

func action(_command: Command, _player: Player) -> String:
	System.description_mode = System.DescriptionMode.Brief
	return "Brief descriptions."
