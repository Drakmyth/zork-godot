extends Command

func action(command: Command, player: Player) -> String:
	player.drop(command.direct_objects[0])
	return "Dropped."

func preaction(_command: Command, _player: Player) -> String:
	return ""
