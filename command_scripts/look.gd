extends Command

func action(_command: Command, player: Player) -> String:
	var room = player.get_room()
	return room.describe(true)
