extends Thing

func action(command: Command, _player: Player) -> String:
	return "The boards are securely fastened." if [Vocabulary.Verbs.TAKE, Vocabulary.Verbs.EXAMINE].has(command.verb) else ""
