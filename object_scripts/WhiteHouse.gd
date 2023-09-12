extends Thing

func action(command: Command, player: Player) -> String:
	match(command.verb):
		"find":
			return _handle_find(command, player)
		"examine":
			return _handle_examine(command, player)
		"enter":
			return _handle_open(command, player)
		"open":
			return _handle_open(command, player)
		"burn":
			return _handle_burn(command, player)
	
	if command.verb == "walk" and command.preposition == "around":
		return _handle_walk_around(command, player)

	return ""

func _handle_find(_command:Command, _player: Player) -> String:
	return ""

func _handle_examine(_command:Command, _player: Player) -> String:
	return ""

func _handle_open(_command:Command, player: Player) -> String:
	var room = player.get_room()
	if room.name != "east-of-house": return "I can't see how to get in from here."
	
	var kitchen_window = room.get_local_object("kitchen-window") as Door
	if kitchen_window.is_open():
		var kitchen = room.get_node("../kitchen")
		return player.move_to(kitchen)
	else:
		return "The window is closed."

func _handle_burn(_command:Command, _player: Player) -> String:
	return ""

func _handle_walk_around(_command:Command, _player: Player) -> String:
	return ""
