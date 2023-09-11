extends Door

func _first_description_tokens() -> Array:
	return []

func _floor_description_tokens() -> Array:
	return [description] if floor_description.is_empty() else []

func action(command: Command, player: Player) -> String:
	match(command.verb):
		"open":
			return _handle_open(command, player)
		"close":
			return _handle_close(command, player)
		"examine":
			return _handle_examine(command, player)
		"walk":
			return _handle_walk(command, player)
	
	if command.verb == "look" and ["with", "in"].has(command.preposition):
		return _handle_look_in(command, player)

	return ""

func _handle_open(_command:Command, _player: Player) -> String:
	if open: return Vocabulary.get_random_dummy_response()

	open = true
	return "With great effort, you open the window far enough to allow entry."

func _handle_close(_command:Command, _player: Player) -> String:
	if not open: return Vocabulary.get_random_dummy_response()

	open = false
	return "The window closes (more easily than it opened)."

func _handle_examine(_command:Command, _player: Player) -> String:
	return ""

func _handle_walk(_command:Command, _player: Player) -> String:
	return ""

func _handle_look_in(_command:Command, _player: Player) -> String:
	return ""
