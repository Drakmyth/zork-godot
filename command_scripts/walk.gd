extends Command

func action(_command: Command, _player: Player) -> String:
	return "Walking %s..." % direct_objects[0].description
