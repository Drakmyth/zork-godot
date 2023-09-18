extends Door

func action(command: Command, _player: Player) -> String:
	match command.verb:
		Vocabulary.Verbs.OPEN:
			return "The door cannot be opened."
		Vocabulary.Verbs.BURN:
			return "You cannot burn this door."
		Vocabulary.Verbs.DESTROY:
			return "You can't seem to damage the door."
		Vocabulary.Verbs.LOOK:
			return "It won't open." if command.first_preposition == Vocabulary.Prepositions.BEHIND else ""

	return ""
