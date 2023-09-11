extends Command

func action(_command: Command, _player: Player) -> String:
	return "Burning %s %s..." % [first_preposition, direct_objects[0].description]

func preaction(_command: Command, _player: Player) -> String:
	print("Pre-Burning...")
	return ""
