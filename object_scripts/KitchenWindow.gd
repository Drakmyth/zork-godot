extends Door

func action(command: Command, player: Player) -> String:
	match(command.verb):
		Vocabulary.Verbs.OPEN:
			return _handle_open_close(command)
		Vocabulary.Verbs.CLOSE:
			return _handle_open_close(command)
		Vocabulary.Verbs.WALK:
			return _handle_walk(player)
		Vocabulary.Verbs.BOARD:
			return _handle_walk(player)
		Vocabulary.Verbs.ENTER:
			return _handle_walk(player)
		Vocabulary.Verbs.LOOK:
			return _handle_look(command, player)

	return ""

func examine() -> String:
	return "The window is slightly ajar, but not enough to allow entry." if not is_touched() else super()

func _handle_open_close(command:Command) -> String:
	state_flags |= Thing.StateFlags.TOUCHED
	if command.verb == Vocabulary.Verbs.OPEN and open: return Vocabulary.get_random_dummy_response()
	if command.verb == Vocabulary.Verbs.CLOSE and not open: return Vocabulary.get_random_dummy_response()

	open = command.verb == Vocabulary.Verbs.OPEN
	return "With great effort, you open the window far enough to allow entry." if open \
		else "The window closes (more easily than it opened)."

func _handle_walk(player: Player) -> String:
	return player.move(Vocabulary.Directions.EAST) if player.get_room().name == "kitchen" else player.move(Vocabulary.Directions.WEST)

func _handle_look(command:Command, player: Player) -> String:
	if not command.preposition == Vocabulary.Prepositions.IN: return ""

	if player.get_room().name == "kitchen":
		return "You can see a clear area leading towards a forest."
	else:
		return "You can see what appears to be a kitchen."
