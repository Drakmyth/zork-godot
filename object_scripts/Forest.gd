extends Thing

func action(command: Command, _player: Player) -> String:
	match command.verb:
		Vocabulary.Verbs.DISEMBARK:
			return "You will have to specify a direction."
		Vocabulary.Verbs.FIND:
			return "You cannot see the forest for the trees."
		Vocabulary.Verbs.LISTEN:
			return "The pines and the hemlocks seem to be murmuring."
	return ""

