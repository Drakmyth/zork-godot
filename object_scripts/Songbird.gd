extends Thing

func action(command: Command, _player: Player) -> String:
	match command.verb:
		Vocabulary.Verbs.FIND:
			return "The songbird is not here but is probably nearby."
		Vocabulary.Verbs.TAKE:
			return "The songbird is not here but is probably nearby."
		Vocabulary.Verbs.LISTEN:
			return "You can't hear the songbird now."
		Vocabulary.Verbs.FOLLOW:
			return "It can't be followed."
	return "You can't see any songbird here."
