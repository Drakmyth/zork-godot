extends Thing

func action(command: Command, _player: Player) -> String:
	match command.verb:
		Vocabulary.Verbs.OPEN:
			return "The windows are boarded and can't be opened."
		Vocabulary.Verbs.DESTROY:
			return "You can't break the windows open."

	return ""
