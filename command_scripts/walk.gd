extends Command

func action(command: Command, player: Player) -> String:
	return player.move(command.direct_objects[0].description)
