extends Command

func action(_command: Command, _player: Player) -> String:
	return "Taking..."

func preaction(_command: Command, _player: Player) -> String:
	print("Pre-Taking...")
	return ""
