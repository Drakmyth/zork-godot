extends Command

func action(_command: Command, player: Player) -> String:
	var room = player.get_room()
	var descriptions = [room.title, room.describe_room(), room.describe_contents()]
	return "\n".join(descriptions)
