extends Thing

func action(command: Command, player: Player) -> String:
	match command.verb:
		Vocabulary.Verbs.DISEMBARK:
			return "You will have to specify a direction."
		Vocabulary.Verbs.FIND:
			return "You cannot see the forest for the trees."
		Vocabulary.Verbs.LISTEN:
			return "The pines and the hemlocks seem to be murmuring."
		Vocabulary.Verbs.WALK:
			return _handle_walk(command, player)
	return ""

func _handle_walk(command: Command, player: Player) -> String:
	if command.first_preposition != Vocabulary.Prepositions.AROUND: return ""
	if player.get_room().is_in_group(Vocabulary.Groups.ROOMS_AROUND_HOUSE): return "You aren't even in the forest."

	# TODO: return player.move_to_next_room_in_group(Vocabulary.Groups.ROOMS_IN_FOREST)
	return ""
