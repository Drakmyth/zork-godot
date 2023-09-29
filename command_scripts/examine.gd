extends Command

func action(command: Command, _player: Player) -> String:
	return command.direct_objects[0].examine()
