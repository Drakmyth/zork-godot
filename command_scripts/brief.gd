extends Command

func action(_command: Command, _player: Player) -> String:
	System.descriptionmode = System.DescriptionMode.Brief
	return "Brief descriptions."
