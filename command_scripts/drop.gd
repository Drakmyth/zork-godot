extends Command

func action(_command: Command, _player: Player) -> String:
	return "Dropping..."

func preaction(_command: Command, _player: Player) -> String:
	print("Pre-Dropping...")
	return ""
